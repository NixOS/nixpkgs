#!/usr/bin/env bb

(require '[babashka.curl :as curl]
         '[babashka.cli :as cli])

(def graphql-path
  (str
   (or (System/getenv "NIXOS_ACTIVITY_GQL_PATH")
       (fs/cwd))))

;; (println "graphql path:" graphql-path)

(defn get-access-token []
  (or (System/getenv "ACCESS_TOKEN")
      (slurp (fs/file (fs/home) ".config/nix/extra-token"))
      (->> (line-seq (io/reader (fs/file (fs/home) ".config/nix/nix.conf")))
           (map #(re-matches #"access-tokens\W*=.*github.com=(\w*)" %))
           (map second)
           (filter some?)
           first)))


(defn query [q & [v]]
  (->
   (curl/post "https://api.github.com/graphql"
              {:headers {"Authorization" (str "bearer " (get-access-token))}
               :body (json/encode {:query q
                                   :variables v})})
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

(defn file-query [query-name & [variables]]
  (query (slurp (fs/file graphql-path (str (name query-name) ".gql")))
         variables))

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
  (unwrap (file-query :issue-comments {:login "bendlas" :after after-cursor})
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
