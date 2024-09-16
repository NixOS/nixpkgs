#!/usr/bin/env bb

;; to get a repl
;; - Terminal
;;       $ nix-shell -p babashka curl --run "bb"
;;       user=> (load-file "activity.bb")
;;       user=> (pprint (file-query :org-repos {:org "nixos"}))
;; - IDE support
;;       $ nix-shell -p babashka curl --run "bb nrepl-server"
;;   - connect to 127.0.0.1:1667 with emacs/cider or vscode/calva

;; # Configuration

(require '[babashka.curl :as curl]
         '[babashka.cli :as cli])

(def wd (.getParentFile (fs/file *file*)))

(def graphql-path
  "Make working directory overridable"
  (str
   (or (System/getenv "NIXOS_ACTIVITY_GQL_PATH")
       wd)))

(def maintainers-path
  "Make maintainers path overridable"
  (str
   (or (System/getenv "NIXOS_MAINTAINERS_PATH")
       (fs/canonicalize
        (fs/file wd "../..")))))

;; (println "graphql path:" graphql-path)

(defn get-access-token
  "GitHub access token lookup"
  []
  (or (System/getenv "GITHUB_TOKEN")
      (try
        (slurp (fs/file (fs/home) ".config/nixpkgs/maintainer-activity-access-token"))
        (catch Exception e nil))
      (try
        (->> (line-seq (io/reader (fs/file (fs/home) ".config/nix/nix.conf")))
             (map #(re-matches #"access-tokens\W*=.*github.com=(\w*)" %))
             (map second)
             (filter some?)
             first)
        (catch Exception e nil))
      (do (.println System/err "Please set GitHub Access Token
  - GITHUB_TOKEN=<token>
  - ~/.config/nixpkgs/maintainer-activity-access-token <token>
  - ~/.config/nix/nix.conf access-tokens = github.com=<token>
")
          (System/exit 1))))

;; ## nixos org and its repositories

(comment
  ;; to regenerate org id
  (unwrap (file-query :org-repos {:org "nixos"})
          [:organization :id]))

(def org-id "O_kgDOAAdwkA")

(def repo-map (edn/read (java.io.PushbackReader.
                         (io/reader (io/file graphql-path
                                             "repos.edn")))))

(defn interesting-repo? [nixpkgs-only]
  (into #{}
        (map repo-map)
        (if nixpkgs-only
          ["nixpkgs"]           ; to scope down which repos to look at
          (keys repo-map))))

;; # low-level access: graphql

(defn query
  "github graphql API access"
  [query & [variables operation-name]]
  (->
   (curl/post "https://api.github.com/graphql"
              {:headers {"Authorization" (str "bearer " (get-access-token))}
               :throw false
               :body (json/encode {:query query
                                   :variables variables
                                   :operationName operation-name})})
   (update :body json/decode keyword)))

(defn unwrap
  "graphql result unpacking with error check and print remaining credits"
  [response path]
  (let [{:keys [status headers body err]} response
        _ (when-not (= 200 status)
            (throw (ex-info "Non-200 HTTP status" {:response response})))
        _ (.println System/err (format ".. got %s/%s credits left"
                                       (get headers "x-ratelimit-remaining")
                                       (get headers "x-ratelimit-limit")))
        {:keys [data errors]
         {:keys [warnings]} :extensions} body
        _ (when-not (empty? errors)
            (throw (ex-info "GQL Errors" {:body body})))
        _ (when-not (empty? warnings)
            (doseq [w warnings]
              (.println System/err (format "WARNING: %s" w))))]
    (get-in data path)))

;; # low-level access: search

;; Search API has its own credit system and lives in its own universe

(defn unpack-search-result
  "search response unpacking with error check and print remaining credits"
  [{:keys [status headers body]}]
  (assert (= 200 status))
  (.println System/err (format ".. got %s/%s search credits left"
                               (get headers "x-ratelimit-remaining")
                               (get headers "x-ratelimit-limit")))
  {:total (:total_count body)
   :latest (-> body :items first
               (select-keys [:node_id :url :updated_at :commit]))})

(defn search-issues
  "github search API for issues and PRs"
  [& {:keys [q]}]
  (->
   (curl/get "https://api.github.com/search/issues"
             {:headers
              {"Authorization" (str "bearer " (get-access-token))
               "Accept" "application/vnd.github+json"
               "X-GitHub-Api-Version" "2022-11-28"}
              :query-params
              {:sort "updated"
               :order "desc"
               :per_page "1"
               :q (str/join " "
                            (map (fn [[k v]]
                                   (str (name k) ":" v))
                                 q))}})
   (update :body json/decode keyword)
   (unpack-search-result)))

(defn search-commits
  "github search API for commits"
  [& {:keys [q]}]
  (->
   (curl/get "https://api.github.com/search/commits"
             {:headers
              {"Authorization" (str "bearer " (get-access-token))
               "Accept" "application/vnd.github+json"
               "X-GitHub-Api-Version" "2022-11-28"}
              :query-params
              {:sort "committer-date"
               :order "desc"
               :per_page "1"
               :q (str/join " "
                            (map (fn [[k v]]
                                   (str (name k) ":" v))
                                 q))}})
   (update :body json/decode keyword)
   (unpack-search-result)))

(defn search-for
  "Find user activity in nixos via search api"
  [user]
  {:authored-issue (search-issues
                    :q {:org "NixOS" :author user})
   :commented-issue (search-issues
                     :q {:org "NixOS" :commenter user})
   :authored-commit (search-commits
                     :q {:org "NixOS" :author user})
   :committed-commit (search-commits
                      :q {:org "NixOS" :committer user})})

;; # Queries: GQL for fine-grained data, REST for search API

(defn file-query
  "Query one of the *.gql files"
  [file-name & [variables operation-name extra-query]]
  (query (str (slurp (fs/file graphql-path (str (name file-name) ".gql")))
              extra-query)
         variables
         operation-name))

;; issue comments are already finicky, because they can be accessed by
;; user, but across all github repos. So if a user is active in other
;; repositories, their latest comment to a nixos repo issue may not
;; even be on the first page

;; so we search backwards, until we find a nixos repo issue comment ..

(defn issue-comment-page
  "Get a page of issue comments for user (across all of github)"
  [login after-cursor]
  (.println System/err (format "Fetching issue comments for %s after page %s" login after-cursor))
  (unwrap (file-query :issue-comments
                      {:login "bendlas"
                       :after after-cursor
                       :pageSize 100}
                      "IssueCommentsFor")
          [:user :issueComments]))

;; .. by (lazily) fetching all of them ..

(defn issue-comments
  "Lazy sequence of all issue comments for user (across all of github)"
  [login & [after-cursor]]
  (lazy-seq
   (let [{:keys [pageInfo nodes]} (issue-comment-page login after-cursor)]
     (concat nodes
             (when (:hasNextPage pageInfo)
               (issue-comments login (:endCursor pageInfo)))))))

;; .. and finding the first one from a repo, we've listed in ./repos.edn

(defn latest-issue-comment-for
  "Find latest issue comment for user within NixOS"
  [login nixpkgs-only]
  (-> (issue-comments login)
      (->> (filter (comp (interesting-repo? nixpkgs-only)
                         :id :repository)))
      first
      (dissoc :repository)))

;; Contributions are what backs the user front page. They can be
;; fetched per fixed time frame, max 1 year

(defn latest-contributions-for
  "Find org contributions via github activity"
  [user]
  (->
   (file-query :org-contributions {:login user :orgId org-id})
   (unwrap [:user :contributionsCollection])))

(comment

  (file-query :issue-comments {:login "bendlas"})
  (def icp (issue-comment-page "bendlas" nil))
  (def icb (issue-comments "bendlas"))
  (file-query :org-contributions {:login "bendlas" :orgId org-id}))

;; Batched queries are a specialty use case, enabled by graphql named
;; queries. Cannot be parameterized in a .gql file (but still re-use
;; fragments), so need stringual query generation.

(comment
  (file-query :issue-comments
              {:pageSize 1} #_{:after nil}
              "Main"
              "
query Main($after:String,$pageSize:Int!) {
  bendlas:user(login:\"bendlas\") { ...issueCommentFields }
  grahamc:user(login:\"grahamc\") { ...issueCommentFields }
}
")
  )

(defn- gql-sanitize [user]
  (str "_" (str/replace user #"[^a-zA-Z0-9]" "_")))

(defn issue-comments-queries
  "Get a page of issue comments for multiple users simultaneously.
   This functionality is subject to restricted capability from github:
   If requesting too much data at once (especially users in parallel),
   then queries can start timing out."
  [users]
  (str/join
   (concat
    ["query Main($after:String,$pageSize:Int!) {\n"]
    (mapcat
     (fn [user]
       ["  " (gql-sanitize user) ":user(login:\"" user "\") { ...issueCommentFields }\n"])
     users)
    ["}"])))

(comment
  (println (issue-comments-queries ["SuperSandro2000" "bendlas" "superherointj" "thiagokokada"]))
  (file-query :issue-comments
              {:pageSize 1} #_{:after nil}
              "Main"
              (issue-comments-queries ["SuperSandro2000" "bendlas" "superherointj" "thiagokokada"]))
  )

;; Easily process maintainers-list.nix

(defn read-maintainer-list
  "Read maintainer-list.nix"
  []
  (-> (shell/sh "nix" "eval" "--impure" "--json" "--expr"
                (str "import "
                     (fs/file maintainers-path "maintainer-list.nix")))
      :out json/parse-string))

(defn maintainer-names
  "List maintainer github handles from maintainer map"
  [ml]
  (mapv (fn [[k {:strs [github]}]]
          (or github
              (do (.println System/err (str "WARNING: User " k " has no associated github user"))
                  k)))
        ml))

(comment
  (def x
    (->
     (file-query :issue-comments
                 {:pageSize 6} #_{:after nil}
                 "Main"
                 (issue-comments-queries
                  (take 40
                        (maintainer-names
                         (read-maintainer-list)))))
     (unwrap [])))
  )

;; # graphql explorer

;; proxying requests to https://api.github.com/graphql
;; in order to work with CORS rules

(require '[org.httpkit.server :as server]
         '[org.httpkit.client :as client])
(defn router
  "HTTP routes for explorer"
  [auth-header]
  (fn [req]
    (try (let [resp (case (:uri req)
                      "/" {:headers {"Content-Type" "text/html"}
                           :body (fs/file wd "explorer/index.html")}
                      "/graphql" (select-keys
                                  @(client/post "https://api.github.com/graphql"
                                                {:headers {"Authorization" auth-header}
                                                 :body (:body req)})
                                  [:status :body])
                      {:status 404})]
           resp)
         (catch Exception e
           (println "Request error" e)
           {:status 500}))))

(defn serve-explorer
  "Start server for graphiql explorer"
  [access-token]
  (server/run-server
   (router (str "bearer " access-token))
   {:port 1337
    :legacy-return-value? false})
  (println "Running on localhost:1337")
  (shell/sh "xdg-open" "http://localhost:1337")
  @(promise))

(comment
  ;; run webserver in a thread, so that repl doesn't hang
  (def server (future (serve-explorer (get-access-token))))
  #__)

;; # CLI - Command line interface

(defn exit-error [{:keys [spec type cause msg option] :as data}]
  (if (= :org.babashka/cli type)
    (case cause
      :require
      (println
       (format "Missing required argument: %s\n" option))
      :validate
      (println
       (format "%s does not exist!\n" msg))))
  (System/exit 1))

(def user-spec
  {:user {:require true
          :desc "A GitHub user to operate on"}})

(def issue-comments-spec
  {:nixpkgs-only {:require false
                  :coerce :boolean
                  :desc "Whether to only look at nixpkgs or all nixos repositories"}})

(declare help-dispatch)
(def table
  [{:cmds ["gh" "latest-issue-comment-for"]
    :spec (merge user-spec
                 issue-comments-spec)
    :error-fn exit-error
    :fn #(assoc % :entry latest-issue-comment-for
                :eargs [(-> % :opts :user)
                        (-> % :opts :nixpkgs-only)] )
    :args->opts [:user]}
   {:cmds ["gh" "latest-contributions-for"]
    :spec user-spec
    :error-fn exit-error
    :fn #(assoc % :entry latest-contributions-for
                :eargs [(-> % :opts :user)])
    :args->opts [:user]}
   {:cmds ["gh" "search-for"]
    :spec user-spec
    :error-fn exit-error
    :fn #(assoc % :entry search-for
                :eargs [(-> % :opts :user)])
    :args->opts [:user]}
   {:cmds ["gh" "explorer"]
    :error-fn exit-error
    :fn #(assoc % :entry (partial serve-explorer (get-access-token)))}
   {:cmds ["maintainer" "map"]
    :error-fn exit-error
    :fn #(assoc % :entry read-maintainer-list)}
   {:cmds ["maintainer" "names"]
    :error-fn exit-error
    :fn #(assoc % :entry (comp maintainer-names read-maintainer-list))}
   {:cmds [] :fn #(assoc-in % [:opts :help] true)}])

(defn show-help [{:as arg :keys [dispatch]}]
  (when-let [dc (some #(and (= (:cmds %)
                             dispatch)
                          %)
                    table)]
    (apply println (concat (:cmds dc) (:args->opts dc)))
    (println
     (cli/format-opts
      (assoc dc
             :order (vec (keys (:spec dc)))))))
  (doseq [{:keys [cmds args->opts]} table]
    (apply println "" (concat cmds args->opts))))

(defn -main [& args]
  (let [{:as arg :keys [opts help entry eargs]} (cli/dispatch table args)]
    (if (or help (get opts :h) (get opts :help))
      (show-help arg)
      (let [res (apply entry eargs)]
        (.println System/err "------")
        (json/generate-stream res *out*
                              {:pretty true})))))

(when (= *file* (System/getProperty "babashka.file"))
  (apply -main *command-line-args*))
