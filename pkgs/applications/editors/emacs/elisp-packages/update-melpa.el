;; -*- lexical-binding: t -*-

;; This is the updater for recipes-archive-melpa.json

(require 'promise)
(require 'semaphore-promise)
(require 'url)
(require 'json)
(require 'cl-lib)
(require 'subr-x)
(require 'seq)

;; # Lib

(defun alist-set (key value alist)
  (cons
   (cons key value)
   (assq-delete-all
    key alist)))

(defun alist-update (key f alist)
  (let ((value (alist-get key alist)))
    (cons
     (cons key (funcall f value))
     (assq-delete-all
      key alist))))


(defun process-promise (semaphore program &rest args)
  "Generate an asynchronous process and
return Promise to resolve in that process."
  (promise-then
   (semaphore-promise-gated
    semaphore
    (lambda (resolve reject)
      (funcall resolve (apply #'promise:make-process program args))))
   #'car))

(defun mangle-name (s)
  (if (string-match "^[a-zA-Z].*" s)
      s
    (concat "_" s)))

;; ## Shell promise + env

(defun as-string (o)
  (with-output-to-string (princ o)))

(defun assocenv (env &rest namevals)
  (let ((process-environment (copy-sequence env)))
    (mapc (lambda (e)
            (setenv (as-string (car e))
                    (cadr e)))
          (seq-partition namevals 2))
    process-environment))

(defun shell-promise (semaphore env script)
  (semaphore-promise-gated
   semaphore
   (lambda (resolve reject)
     (let ((process-environment env))
       (funcall resolve (promise:make-shell-command script))))))

;; # Updater

;; ## Previous Archive Reader

(defun previous-commit (index ename variant)
  (when-let (pdesc (and index (gethash ename index)))
    (when-let (desc (and pdesc (gethash variant pdesc)))
      (gethash 'commit desc))))

(defun previous-sha256 (index ename variant)
  (when-let (pdesc (and index (gethash ename index)))
    (when-let (desc (and pdesc (gethash variant pdesc)))
      (gethash 'sha256 desc))))

(defun parse-previous-archive (filename)
  (let ((idx (make-hash-table :test 'equal)))
    (cl-loop for desc in
          (let ((json-object-type 'hash-table)
                (json-array-type 'list)
                (json-key-type 'symbol))
            (json-read-file filename))
          do (puthash (gethash 'ename desc)
                      desc idx))
    idx))

;; ## Prefetcher

;; (defun latest-git-revision (url)
;;   (process-promise "git" "ls-remote" url))

(defun prefetch (semaphore fetcher repo commit)
  (promise-then
   (apply 'process-promise
          semaphore
          (pcase fetcher
            ("github"    (list "nix-prefetch-url"
                               "--unpack" (concat "https://github.com/" repo "/archive/" commit ".tar.gz")))
            ("gitlab"    (list "nix-prefetch-url"
                               "--unpack" (concat "https://gitlab.com/api/v4/projects/"
                                                  (url-hexify-string repo)
                                                  "/repository/archive.tar.gz?ref="
                                                  commit)))
            ("sourcehut" (list "nix-prefetch-url"
                               "--unpack" (concat "https://git.sr.ht/~" repo "/archive/" commit ".tar.gz")))
            ("codeberg" (list "nix-prefetch-url"
                              "--unpack" (concat "https://codeberg.org/" repo "/archive/" commit ".tar.gz")))
            ("bitbucket" (list "nix-prefetch-hg"
                               (concat "https://bitbucket.com/" repo) commit))
            ("hg"        (list "nix-prefetch-hg"
                               repo commit))
            ("git"       (list "nix-prefetch-git"
                               "--fetch-submodules"
                               "--url" repo
                               "--rev" commit))
            (_           (throw 'unknown-fetcher fetcher))))
   (lambda (res)
     (pcase fetcher
       ("git" (alist-get 'sha256 (json-read-from-string res)))
       (_ (car (split-string res)))))))

(defun source-sha (semaphore ename eprops aprops previous variant)
  (let* ((fetcher (alist-get 'fetcher eprops))
         (url     (alist-get 'url eprops))
         (repo    (alist-get 'repo eprops))
         (commit  (gethash 'commit aprops))
         (prev-commit (previous-commit previous ename variant))
         (prev-sha256 (previous-sha256 previous ename variant)))
    (if (and commit prev-sha256
             (equal prev-commit commit))
        (progn
          (message "INFO: %s: re-using %s %s" ename prev-commit prev-sha256)
          (promise-resolve `((sha256 . ,prev-sha256))))
      (if (and commit (or repo url))
          (promise-then
           (prefetch semaphore fetcher (or repo url) commit)
           (lambda (sha256)
             (message "INFO: %s: prefetched repository %s %s" ename commit sha256)
             `((sha256 . ,sha256)))
           (lambda (err)
             (message "ERROR: %s: during prefetch %s" ename err)
             (promise-resolve
              `((error . ,err)))))
        (progn
          (message "ERROR: %s: no commit information" ename)
          (promise-resolve
           `((error . "No commit information"))))))))

(defun source-info (recipe archive source-sha)
  (let* ((esym    (car recipe))
         (ename   (symbol-name esym))
         (eprops  (cdr recipe))
         (aentry  (gethash esym archive))
         (version (and aentry (gethash 'ver aentry)))
         (deps    (when-let (deps (gethash 'deps aentry))
                    (remove 'emacs (hash-table-keys deps))))
         (aprops  (and aentry (gethash 'props aentry)))
         (commit  (gethash 'commit aprops)))
    (append `((version . ,version))
            (when (< 0 (length deps))
              `((deps . ,(sort deps 'string<))))
            `((commit . ,commit))
            source-sha)))

(defun recipe-info (recipe-index ename)
  (if-let (desc (gethash ename recipe-index))
      (cl-destructuring-bind (rcp-commit . rcp-sha256) desc
        `((commit . ,rcp-commit)
          (sha256 . ,rcp-sha256)))
    `((error . "No recipe info"))))

(defun start-fetch (semaphore recipe-index-promise recipes unstable-archive stable-archive previous)
  (promise-all
   (mapcar (lambda (entry)
             (let* ((esym    (car entry))
                    (ename   (symbol-name esym))
                    (eprops  (cdr entry))
                    (fetcher (alist-get 'fetcher eprops))
                    (url     (alist-get 'url eprops))
                    (repo    (alist-get 'repo eprops))

                    (unstable-aentry  (gethash esym unstable-archive))
                    (unstable-aprops  (and unstable-aentry (gethash 'props unstable-aentry)))
                    (unstable-commit  (and unstable-aprops (gethash 'commit unstable-aprops)))

                    (stable-aentry (gethash esym stable-archive))
                    (stable-aprops (and stable-aentry (gethash 'props stable-aentry)))
                    (stable-commit  (and stable-aprops (gethash 'commit stable-aprops)))

                    (unstable-shap (if unstable-aprops
                                       (source-sha semaphore ename eprops unstable-aprops previous 'unstable)
                                     (promise-resolve nil)))
                    (stable-shap (if (equal unstable-commit stable-commit)
                                     unstable-shap
                                   (if stable-aprops
                                       (source-sha semaphore ename eprops stable-aprops previous 'stable)
                                     (promise-resolve nil)))))

               (promise-then
                (promise-all (list recipe-index-promise unstable-shap stable-shap))
                (lambda (res)
                  (seq-let [recipe-index unstable-sha stable-sha] res
                    (append `((ename   . ,ename))
                            (if-let (desc (gethash ename recipe-index))
                                (cl-destructuring-bind (rcp-commit . rcp-sha256) desc
                                  (append `((commit . ,rcp-commit)
                                            (sha256 . ,rcp-sha256))
                                          (when (not unstable-aprops)
                                            (message "ERROR: %s: not in archive" ename)
                                            `((error . "Not in archive")))))
                              `((error . "No recipe info")))
                            `((fetcher . ,fetcher))
                            (if (or (equal "github" fetcher)
                                    (equal "bitbucket" fetcher)
                                    (equal "gitlab" fetcher)
                                    (equal "sourcehut" fetcher)
                                    (equal "codeberg" fetcher))
                                `((repo . ,repo))
                              `((url . ,url)))
                            (when unstable-aprops `((unstable . ,(source-info entry unstable-archive unstable-sha))))
                            (when stable-aprops `((stable . ,(source-info entry stable-archive stable-sha))))))))))
           recipes)))

;; ## Emitter

(defun emit-json (prefetch-semaphore recipe-index-promise recipes archive stable-archive previous)
  (promise-then
   (start-fetch
    prefetch-semaphore
    recipe-index-promise
    (sort recipes (lambda (a b)
                    (string-lessp
                     (symbol-name (car a))
                     (symbol-name (car b)))))
    archive stable-archive
    previous)
   (lambda (descriptors)
     (message "Finished downloading %d descriptors" (length descriptors))
     (let ((buf (generate-new-buffer "*recipes-archive*")))
       (with-current-buffer buf
         ;; (switch-to-buffer buf)
         ;; (json-mode)
         (insert
          (let ((json-encoding-pretty-print t)
                (json-encoding-default-indentation " "))
            (json-encode descriptors)))
         buf)))))

;; ## Recipe indexer

(defun http-get (url parser)
  (promise-new
   (lambda (resolve reject)
     (url-retrieve
      url (lambda (status)
            (funcall resolve (condition-case err
                                 (progn
                                   (url-http-parse-headers)
                                   (goto-char url-http-end-of-headers)
                                   (message (buffer-substring (point-min) (point)))
                                   (funcall parser))
                               (funcall reject err))))))))

(defun json-read-buffer (buffer)
  (with-current-buffer buffer
    (save-excursion
      (mark-whole-buffer)
      (json-read))))

(defun error-count (recipes-archive)
  (length
   (seq-filter
    (lambda (desc)
      (alist-get 'error desc))
    recipes-archive)))

;; (error-count (json-read-buffer "recipes-archive-melpa.json"))

(defun latest-recipe-commit (semaphore repo base-rev recipe)
  (shell-promise
   semaphore (assocenv process-environment
                       "GIT_DIR" repo
                       "BASE_REV" base-rev
                       "RECIPE" recipe)
   "exec git log --first-parent -n1 --pretty=format:%H $BASE_REV -- recipes/$RECIPE"))

(defun latest-recipe-sha256 (semaphore repo base-rev recipe)
  (promise-then
   (shell-promise
    semaphore (assocenv process-environment
                        "GIT_DIR" repo
                        "BASE_REV" base-rev
                        "RECIPE" recipe)
    "exec nix-hash --flat --type sha256 --base32 <(
       git cat-file blob $(
         git ls-tree $BASE_REV recipes/$RECIPE | cut -f1 | cut -d' ' -f3
       )
     )")
   (lambda (res)
     (car
      (split-string res)))))

(defun index-recipe-commits (semaphore repo base-rev recipes)
  (promise-then
   (promise-all
    (mapcar (lambda (recipe)
              (promise-then
               (latest-recipe-commit semaphore repo base-rev recipe)
               (let ((sha256p (latest-recipe-sha256 semaphore repo base-rev recipe)))
                 (lambda (commit)
                   (promise-then sha256p
                                 (lambda (sha256)
                                   (message "Indexed Recipe %s %s %s" recipe commit sha256)
                                   (cons recipe (cons commit sha256))))))))
            recipes))
   (lambda (rcp-commits)
     (let ((idx (make-hash-table :test 'equal)))
       (mapc (lambda (rcpc)
               (puthash (car rcpc) (cdr rcpc) idx))
             rcp-commits)
       idx))))

(defun with-melpa-checkout (resolve)
  (let ((tmpdir (make-temp-file "melpa-" t)))
    (promise-finally
     (promise-then
      (shell-promise
       (semaphore-create 1 "dummy")
       (assocenv process-environment "MELPA_DIR" tmpdir)
       "cd $MELPA_DIR
       (git init --bare
        git remote add origin https://github.com/melpa/melpa.git
        git fetch origin) 1>&2
       echo -n $MELPA_DIR")
      (lambda (dir)
        (message "Created melpa checkout %s" dir)
        (funcall resolve dir)))
     (lambda ()
       (delete-directory tmpdir t)
       (message "Deleted melpa checkout %s" tmpdir)))))

(defun list-recipes (repo base-rev)
  (promise-then
   (shell-promise nil (assocenv process-environment
                                "GIT_DIR" repo
                                "BASE_REV" base-rev)
                  "git ls-tree --name-only $BASE_REV recipes/")
   (lambda (s)
     (mapcar (lambda (n)
               (substring n 8))
             (split-string s)))))

;; ## Main runner

(defvar recipe-indexp)
(defvar archivep)

(defun run-updater ()
  (message "Turning off logging to *Message* buffer")
  (setq message-log-max nil)
  (setenv "GIT_ASKPASS")
  (setenv "SSH_ASKPASS")
  (setq process-adaptive-read-buffering nil)

  ;; Indexer and Prefetcher run in parallel

  ;; Recipe Indexer
  (setq recipe-indexp
        (with-melpa-checkout
         (lambda (repo)
           (promise-then
            (promise-then
             (list-recipes repo "origin/master")
             (lambda (recipe-names)
               (promise:make-thread #'index-recipe-commits
                                    ;; The indexer runs on a local git repository,
                                    ;; so it is CPU bound.
                                    ;; Adjust for core count + 2
                                    (semaphore-create 6 "local-indexer")
                                    repo "origin/master"
                                    ;; (seq-take recipe-names 20)
                                    recipe-names)))
            (lambda (res)
              (message "Indexed Recipes: %d" (hash-table-count res))
              (defvar recipe-index res)
              res)
            (lambda (err)
              (message "ERROR: %s" err))))))

  ;; Prefetcher + Emitter
  (setq archivep
        (promise-then
         (promise-then (promise-all
                        (list (http-get "https://melpa.org/recipes.json"
                                        (lambda ()
                                          (let ((json-object-type 'alist)
                                                (json-array-type 'list)
                                                (json-key-type 'symbol))
                                            (json-read))))
                              (http-get "https://melpa.org/archive.json"
                                        (lambda ()
                                          (let ((json-object-type 'hash-table)
                                                (json-array-type 'list)
                                                (json-key-type 'symbol))
                                            (json-read))))
                              (http-get "https://stable.melpa.org/archive.json"
                                        (lambda ()
                                          (let ((json-object-type 'hash-table)
                                                (json-array-type 'list)
                                                (json-key-type 'symbol))
                                            (json-read))))))
                       (lambda (resolved)
                         (message "Finished download")
                         (seq-let [recipes-content archive-content stable-archive-content] resolved
                           ;; The prefetcher is network bound, so 64 seems a good estimate
                           ;; for parallel network connections
                           (promise:make-thread #'emit-json (semaphore-create 64 "prefetch-pool")
                                                recipe-indexp
                                                recipes-content
                                                archive-content
                                                stable-archive-content
                                                (parse-previous-archive "recipes-archive-melpa.json")))))
         (lambda (buf)
           (with-current-buffer buf
             (write-file "recipes-archive-melpa.json")))
         (lambda (err)
           (message "ERROR: %s" err))))

  ;; Shutdown routine
  (make-thread
   (lambda ()
     (promise-finally archivep
                      (lambda ()
                        ;; (message "Joining threads %s" (all-threads))
                        ;; (mapc (lambda (thr)
                        ;;         (when (not (eq thr (current-thread)))
                        ;;           (thread-join thr)))
                        ;;       (all-threads))

                        (kill-emacs 0))))))
