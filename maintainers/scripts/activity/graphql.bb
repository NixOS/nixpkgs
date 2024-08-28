#!/usr/bin/env bb

(require '[babashka.curl :as curl])

(def graphql-path
  (str
   (or (System/getenv "NIXOS_ACTIVITY_GQL_PATH")
       (fs/cwd))))

(println "graphql path:" graphql-path)

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
               (select-keys [:node_id :url :updated_at :commit])
               #_(dissoc :repository :author
                       :committer :parents :score :comments_url :html_url :sha
                       :labels :assignees ))})
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

(comment
  ;; to regenerate repo map
  (let [{:keys [totalCount nodes]}
        (unwrap (file-query :org-repos {:org "nixos"})
                [:organization :repositories])]
    (assert (<= totalCount 100)
            "More than 100 repos in NixOS org")
    (into {} (map (juxt :name :id)) nodes)))

(def repo-map
  {"ofborg" "MDEwOlJlcG9zaXRvcnkxMDg3NzEyMzk=",
   "language-nix" "MDEwOlJlcG9zaXRvcnkyMTYxMzYzNg==",
   "marketing" "R_kgDOLWZbjA",
   "nixops-dashboard" "MDEwOlJlcG9zaXRvcnk0NjI5NTY2MA==",
   "cabal2nix" "MDEwOlJlcG9zaXRvcnkyMTYxMDMx",
   "org" "R_kgDOLmjLpw",
   "first-time-contribution-tagger" "R_kgDOJvBNDQ",
   "foundation" "MDEwOlJlcG9zaXRvcnkzODY4NDIwNQ==",
   "teams-collaboration" "R_kgDOKxmm7w",
   "nixpkgs-merge-bot" "R_kgDOKgBr_w",
   "nix.dev" "MDEwOlJlcG9zaXRvcnk1ODA0Mzg4Ng==",
   "nixos" "MDEwOlJlcG9zaXRvcnk0NTQyNzEx",
   "security" "MDEwOlJlcG9zaXRvcnk2ODk2NTk5NQ==",
   "amis" "R_kgDOKxghxQ",
   "nixos-channel-scripts" "MDEwOlJlcG9zaXRvcnkzMDQyNTU0Ng==",
   "package-list" "MDEwOlJlcG9zaXRvcnkyMjU1ODgz",
   "hydra-ant-logger" "MDEwOlJlcG9zaXRvcnkyNjY5MjM3",
   "darwin-stubs" "MDEwOlJlcG9zaXRvcnkzMTIwMDQ5NTc=",
   "calamares-nixos-extensions" "R_kgDOGjVhbw",
   "experimental-nix-installer" "R_kgDOJhZmPw",
   "reproducible.nixos.org" "R_kgDOJPeMLQ",
   "jailbreak-cabal" "MDEwOlJlcG9zaXRvcnk1NjcwNTYz",
   "nixpkgs-check-by-name" "R_kgDOLhHQ0w",
   "nixpkgs-channels" "MDEwOlJlcG9zaXRvcnkzMTcxNjkxNw==",
   "nixos-metrics" "R_kgDOG5X19A",
   ".github" "MDEwOlJlcG9zaXRvcnkxOTgzNzUxNDg=",
   "nixos-wiki-infra" "R_kgDOJhfr7w",
   "nixos-planet" "MDEwOlJlcG9zaXRvcnkyNTQ1OTE4MDA=",
   "hydra-provisioner" "MDEwOlJlcG9zaXRvcnk0MTQzMTgxNw==",
   "nixos-artwork" "MDEwOlJlcG9zaXRvcnkyNTY4MjEzMg==",
   "rfc39" "MDEwOlJlcG9zaXRvcnkyMDEzODY1NjY=",
   "nixpart" "MDEwOlJlcG9zaXRvcnkxMDk1NzYxMw==",
   "nixops-hetzner" "MDEwOlJlcG9zaXRvcnkyMDQ3NjkwNDg=",
   "nix-book" "R_kgDOHWt3AQ",
   "ofborg-viewer" "MDEwOlJlcG9zaXRvcnkxMTgwNzA2MjQ=",
   "rfc39-record" "MDEwOlJlcG9zaXRvcnkzMjUwODU5OTc=",
   "hydra-scale-equinix-metal" "R_kgDOLiDiZw",
   "nix-pills" "MDEwOlJlcG9zaXRvcnkxMDAyNDg4NDQ=",
   "patchelf" "MDEwOlJlcG9zaXRvcnkyOTI4MTY0",
   "flake-regressions" "R_kgDOKiganA",
   "nixops" "MDEwOlJlcG9zaXRvcnkyNjM3MjAz",
   "hydra" "MDEwOlJlcG9zaXRvcnkyNjY5MDQx",
   "flake-registry" "MDEwOlJlcG9zaXRvcnkxODgxMDg1NDM=",
   "whats-new-in-nix" "R_kgDOJHHfzA",
   "nixos-common-styles" "MDEwOlJlcG9zaXRvcnkzMjIxMzI4MzY=",
   "npm2nix" "MDEwOlJlcG9zaXRvcnkxOTM2ODc1Mg==",
   "distribution-nixpkgs" "MDEwOlJlcG9zaXRvcnk2MTE0NzM1Nw==",
   "equinix-metal-builders" "MDEwOlJlcG9zaXRvcnkxOTg1Mjc3MTc=",
   "nix-mode" "MDEwOlJlcG9zaXRvcnk2NTk0MDc2Mw==",
   "nix-idea" "MDEwOlJlcG9zaXRvcnk2NzY4NTI5Nw==",
   "docker" "MDEwOlJlcG9zaXRvcnkxMzgxOTA2Nzg=",
   "templates" "MDEwOlJlcG9zaXRvcnkyNjk0MzE0MDk=",
   "nixos-search" "MDEwOlJlcG9zaXRvcnkyNTA3MTI1Nzc=",
   "mobile-nixos-website" "MDEwOlJlcG9zaXRvcnkyMTkxNTgxMjY=",
   "nixos-weekly" "MDEwOlJlcG9zaXRvcnk2NjU3OTg1NA==",
   "infra" "MDEwOlJlcG9zaXRvcnkxMDQwNTU3MQ==",
   "nixpkgs" "MDEwOlJlcG9zaXRvcnk0NTQyNzE2",
   "flake-regressions-data" "R_kgDOKqcSUw",
   "snapd-nix-base" "MDEwOlJlcG9zaXRvcnkxOTI1NjQ2MDc=",
   "bundlers" "R_kgDOGtZjhA",
   "aarch64-build-box" "MDEwOlJlcG9zaXRvcnkxMTQwNjU2MzU=",
   "nixops-aws" "MDEwOlJlcG9zaXRvcnkyMDQ3NjkxNzA=",
   "rfcs" "MDEwOlJlcG9zaXRvcnk4MTY2MjUwMQ==",
   "GSoC" "R_kgDOLMcmwQ",
   "moderation" "R_kgDOGTEbJw",
   "nixos-status" "MDEwOlJlcG9zaXRvcnkzMTgxOTMwNjE=",
   "release-wiki" "MDEwOlJlcG9zaXRvcnkzMDA1MjYxMzk=",
   "nixos-summer" "MDEwOlJlcG9zaXRvcnkzNDc1MDMzNDY=",
   "nix-eclipse" "MDEwOlJlcG9zaXRvcnkyNjY5MjYx",
   "nix-constitutional-assembly" "R_kgDOMDSWnw",
   "nix" "MDEwOlJlcG9zaXRvcnkzMzg2MDg4",
   "systemd" "MDEwOlJlcG9zaXRvcnk0MTMwMDYzMA==",
   "nixos-hardware" "MDEwOlJlcG9zaXRvcnk1MTI5MjQ5MQ==",
   "20th-nix" "R_kgDOJJ7TAA",
   "rfc-steering-committee" "MDEwOlJlcG9zaXRvcnkxOTA3NTYxMTY=",
   "nixos-homepage" "MDEwOlJlcG9zaXRvcnkxNDM5NjkwMA==",
   "nixfmt" "MDEwOlJlcG9zaXRvcnkxNDMyOTIyNzA=",
   "hackage-db" "MDEwOlJlcG9zaXRvcnkyMjY0MDIx",
   "mvn2nix-maven-plugin" "MDEwOlJlcG9zaXRvcnkzNzg1MjA4MQ=="})

(def interesting-repo?
  #_(into #{}
          (map repo-map)
          ["nix" "nixpkgs"])
  (into #{} (vals repo-map)))

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

(comment

  (file-query :issue-comments {:login "bendlas"})
  (def icp (issue-comment-page "bendlas" nil))
  (def icb (issue-comments "bendlas"))
  (file-query :org-contributions {:login "bendlas" :orgId org-id})

  )
