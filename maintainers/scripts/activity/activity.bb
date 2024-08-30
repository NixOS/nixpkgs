#!/usr/bin/env bb

;; to get a repl
;; - Terminal
;;       $ nix-shell -p babashka curl --run "bb"
;;       user=> (load-file "activity.bb")
;;       user=> (pprint (file-query :org-repos {:org "nixos"}))
;; - IDE support
;;       $ nix-shell -p babashka curl --run "bb nrepl-server"
;;   - connect to 127.0.0.1:1667 with emacs/cider or vscode/calva

(require '[babashka.curl :as curl]
         '[babashka.cli :as cli])

(def graphql-path
  "Make working directory overridable"
  (str
   (or (System/getenv "NIXOS_ACTIVITY_GQL_PATH")
       (fs/cwd))))

(def maintainers-path
  "Make maintainers path overridable"
  (str
   (or (System/getenv "NIXOS_MAINTAINERS_PATH")
       (fs/canonicalize
        (fs/file (fs/cwd) "../..")))))

;; (println "graphql path:" graphql-path)

(defn get-access-token
  "GitHub access token lookup"
  []
  (or (System/getenv "ACCESS_TOKEN")
      (try
        (slurp (fs/file (fs/home) ".config/nix/gh-access-token"))
        (catch Exception e nil))
      (try
        (->> (line-seq (io/reader (fs/file (fs/home) ".config/nix/nix.conf")))
             (map #(re-matches #"access-tokens\W*=.*github.com=(\w*)" %))
             (map second)
             (filter some?)
             first)
        (catch Exception e nil))
      (do (.println System/err "Please set GitHub Access Token
  - ACCESS_TOKEN=<token>
  - ~/.config/nix/gh-access-token <token>
  - ~/.config/nix/nix.conf access-tokens = github.com=<token>
")
          (System/exit 1))))


(defn query [q & [v n]]
  (->
   (curl/post "https://api.github.com/graphql"
              {:headers {"Authorization" (str "bearer " (get-access-token))}
               :throw false
               :body (json/encode {:query q
                                   :variables v
                                   :operationName n})})
   (update :body json/decode keyword)))

(defn unpack-search-result [{:keys [status headers body]}]
  (assert (= 200 status))
  (.println System/err (format ".. got %s/%s search credits left"
                               (get headers "x-ratelimit-remaining")
                               (get headers "x-ratelimit-limit")))
  {:total (:total_count body)
   :latest (-> body :items first
               (select-keys [:node_id :url :updated_at :commit]))})
(defn search-issues [& {:keys [q]}]
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

(defn search-commits [& {:keys [q]}]
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

(defn file-query [file-name & [variables operation-name extra-query]]
  (query (str (slurp (fs/file graphql-path (str (name file-name) ".gql")))
              extra-query)
         variables
         operation-name))

(defn unwrap [response path]
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

(comment
  ;; to regenerate org id
  (unwrap (file-query :org-repos {:org "nixos"})
          [:organization :id]))

(def org-id "O_kgDOAAdwkA")

(def repo-map (edn/read (java.io.PushbackReader.
                         (io/reader (io/file graphql-path
                                             "repos.edn")))))

(def interesting-repo?
  (into #{}
        (map repo-map)
        #_["nix" "nixpkgs"]
        (keys repo-map)))

(defn issue-comment-page [login after-cursor]
  (.println System/err (format "Fetching issue comments for %s after page %s" login after-cursor))
  (unwrap (file-query :issue-comments {:login "bendlas" :after after-cursor} "IssueCommentFor")
          [:user :issueComments]))

(defn issue-comments [login & [after-cursor]]
  (lazy-seq
   (let [{:keys [pageInfo nodes]} (issue-comment-page login after-cursor)]
     (concat nodes
             (when (:hasNextPage pageInfo)
               (issue-comments login (:endCursor pageInfo)))))))

(defn latest-issue-comment [login]
  (-> (issue-comments login)
   (->> (filter (comp interesting-repo? :id :repository)))
   first
   (dissoc :repository)))

(defn search-for [user]
  {:authored-issue (search-issues
                    :q {:org "NixOS" :author user})
   :commented-issue (search-issues
                     :q {:org "NixOS" :commenter user})
   :authored-commit (search-commits
                     :q {:org "NixOS" :author user})
   :committed-commit (search-commits
                      :q {:org "NixOS" :committer user})})

(defn latest-contributions [user]
  (->
   (file-query :org-contributions {:login user :orgId org-id})
   (unwrap [:user :contributionsCollection])))

(comment

  (file-query :issue-comments {:login "bendlas"})
  (def icp (issue-comment-page "bendlas" nil))
  (def icb (issue-comments "bendlas"))
  (file-query :org-contributions {:login "bendlas" :orgId org-id})

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

  )

(defn gql-sanitize [user]
  (str "_" (str/replace user #"[^a-zA-Z0-9]" "_")))

(defn issue-comments-queries [users]
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

(defn read-maintainer-list []
  (-> (shell/sh "nix" "eval" "--impure" "--json" "--expr"
                (str "import "
                     (fs/file maintainers-path "maintainer-list.nix")))
      :out json/parse-string))

(defn maintainer-names [ml]
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

;;; CLI

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

(defn entry-point [f & opt-names]
  (fn [{:as arg :keys [opts]}]
    (assoc arg :entry-fn
           #(apply f (map opts opt-names)))))

(declare help-dispatch)
(def table
  [{:cmds ["issue-comment-for"]
    :spec user-spec
    :error-fn exit-error
    :fn #(assoc % :entry latest-issue-comment
                :eargs [(-> % :opts :user)] )
    :args->opts [:user]}
   {:cmds ["contributions-for"]
    :spec user-spec
    :error-fn exit-error
    :fn #(assoc % :entry latest-contributions
                :eargs [(-> % :opts :user)])
    :args->opts [:user]}
   {:cmds ["search-for"]
    :spec user-spec
    :error-fn exit-error
    :fn #(assoc % :entry search-for
                :eargs [(-> % :opts :user)])
    :args->opts [:user]}
   {:cmds [] :fn #(assoc % :help true)}])

(defn show-help [{:as arg :keys [dispatch]}]6
  (if-let [dc (some #(and (= (:cmds %)
                             dispatch)
                          %)
                    table)]
    (do
      (apply println (concat (:cmds dc) (:args->opts dc)))
      (println
       (cli/format-opts
        (assoc dc
               :order (vec (keys (:spec dc)))))))
    (doseq [{:keys [cmds args->opts]} table]
      (apply println "" (concat cmds args->opts)))))

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
