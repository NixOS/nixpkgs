;;; package-build.el --- Tools for assembling a package archive

;; Copyright (C) 2011-2013 Donald Ephraim Curtis <dcurtis@milkbox.net>
;; Copyright (C) 2012-2014 Steve Purcell <steve@sanityinc.com>
;; Copyright (C) 2009 Phil Hagelberg <technomancy@gmail.com>

;; Author: Donald Ephraim Curtis <dcurtis@milkbox.net>
;; Created: 2011-09-30
;; Version: 0.1
;; Keywords: tools
;; Package-Requires: ((cl-lib "0.2"))

;; This file is not (yet) part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This file allows a curator to publish an archive of Emacs packages.

;; The archive is generated from a set of recipes which describe elisp
;; projects and repositories from which to get them.  The term
;; "package" here is used to mean a specific version of a project that
;; is prepared for download and installation.

;;; Code:

(require 'cl-lib)

(require 'package)
(require 'lisp-mnt)
(require 'json)

(defconst pb/this-dir (file-name-directory (or load-file-name (buffer-file-name))))

(defgroup package-build nil
  "Facilities for building package.el-compliant packages from upstream source code."
  :group 'development)

(defcustom package-build-working-dir (expand-file-name "working/" pb/this-dir)
  "Directory in which to keep checkouts."
  :group 'package-build
  :type 'string)

(defcustom package-build-archive-dir (expand-file-name "packages/" pb/this-dir)
  "Directory in which to keep compiled archives."
  :group 'package-build
  :type 'string)

(defcustom package-build-recipes-dir (expand-file-name "recipes/" pb/this-dir)
  "Directory containing recipe files."
  :group 'package-build
  :type 'string)

(defcustom package-build-verbose t
  "When non-nil, `package-build' feels free to print information about its progress."
  :group 'package-build
  :type 'boolean)

(defcustom package-build-stable nil
  "When non-nil, `package-build' tries to build packages from versions-tagged code."
  :group 'package-build
  :type 'boolean)

(defcustom package-build-timeout-executable
  (let ((prog (or (executable-find "timeout")
                  (executable-find "gtimeout"))))
    (when (and prog
               (string-match-p "^ *-k" (shell-command-to-string (concat prog " --help"))))
      prog))
  "Path to a GNU coreutils \"timeout\" command if available.
This must be a version which supports the \"-k\" option."
  :group 'package-build
  :type '(file :must-match t))

(defcustom package-build-tar-executable
  (or (executable-find "gtar")
      (executable-find "tar"))
  "Path to a (preferably GNU) tar command.
Certain package names (e.g. \"@\") may not work properly with a BSD tar."
  :group 'package-build
  :type '(file :must-match t))

(defcustom package-build-write-melpa-badge-images nil
  "When non-nil, write MELPA badge images alongside packages, for use on github pages etc."
  :group 'package-build
  :type 'boolean)

;;; Internal Variables

(defvar pb/recipe-alist nil
  "Internal list of package build specs.

Do not use this directly.  Use `package-build-recipe-alist'
function.")

(defvar pb/recipe-alist-initialized nil
  "Determines if `pb/recipe-alist` has been initialized.")

(defvar pb/archive-alist nil
  "Internal list of already-built packages, in the standard package.el format.

Do not use this directly.  Use `package-build-archive-alist'
function for access to this function")

(defvar pb/archive-alist-initialized nil
  "Determines if pb/archive-alist has been initialized.")

(defconst package-build-default-files-spec
  '("*.el" "*.el.in" "dir"
    "*.info" "*.texi" "*.texinfo"
    "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
    (:exclude ".dir-locals.el" "tests.el" "*-test.el" "*-tests.el"))
  "Default value for :files attribute in recipes.")

(defun pb/message (format-string &rest args)
  "Log a message using FORMAT-STRING and ARGS as per `message'."
  (when package-build-verbose
    (apply 'message format-string args)))

(defun pb/slurp-file (file-name)
  "Return the contents of FILE-NAME as a string, or nil if no such file exists."
  (when (file-exists-p file-name)
    (with-temp-buffer
      (insert-file-contents file-name)
      (buffer-substring-no-properties (point-min) (point-max)))))

(defun pb/string-rtrim (str)
  "Remove trailing whitespace from `STR'."
  (replace-regexp-in-string "[ \t\n]*$" "" str))

(defun pb/parse-time (str)
  "Parse STR as a time, and format as a YYYYMMDD.HHMM string."
  ;; We remove zero-padding the HH portion, as it is lost
  ;; when stored in the archive-contents
  (let* ((s (substring-no-properties str))
         (time (date-to-time
                (if (string-match "^\\([0-9]\\{4\\}\\)/\\([0-9]\\{2\\}\\)/\\([0-9]\\{2\\}\\) \\([0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\)$" str)
                    (concat (match-string 1 str) "-" (match-string 2 str) "-"
                            (match-string 3 str) " " (match-string 4 str))
                  str))))
    (concat (format-time-string "%Y%m%d." time)
            (format "%d" (or (string-to-number (format-time-string "%H%M" time)) 0)))))

(defun pb/string-match-all (regex str &rest groups)
  "Find every match for `REGEX' within `STR'.
Return a list containing the full match string and match for
groups `GROUPS'.  The return list is of the form
   ((FULL GROUP1 GROUP2 ...) ...)
where FULL is the complete regexp match and
GROUP1, GROUP2, ... are the regex groups specified by the
`GROUPS' argument.  If `GROUPS' is nil then FULL and GROUP1 will
be identical."
  (let (result
        (pos 0)
        (groups (or groups '(0))))
    (while (string-match regex str pos)
      (push (cons (match-string 0 str) (mapcar
                                        (lambda (group)
                                          (match-string group str))
                                        groups))
            result)
      (setq pos (match-end 0)))
    result))

(defun pb/find-parse-time (regex &optional bound)
  "Find REGEX in current buffer and format as a time version, optionally looking only as far as BOUND."
  (pb/parse-time (progn (re-search-backward regex bound)
                        (match-string-no-properties 1))))

(defun pb/valid-version-string (str)
  "Return true if STR is a valid version, otherwise return nil."
  (ignore-errors (version-to-list str)))

(defun pb/find-tag-version-newest (regex &optional bound &rest additional-groups)
  "Find the newest version matching REGEX, optionally looking only as far as BOUND."
  (let* ((text (buffer-substring-no-properties
                (or bound (point-min)) (point)))
         (tags (cl-remove-if-not
                (lambda (tag-version)
                  (pb/valid-version-string (cadr tag-version)))
                (apply 'pb/string-match-all regex text 1 additional-groups))))
    (car (nreverse (sort tags (lambda (v1 v2)
                                (version< (cadr v1) (cadr v2))))))))

(defun pb/find-parse-time-latest (regex &optional bound)
  "Find the latest timestamp matching REGEX, optionally looking only as far as BOUND."
  (let* ((text (buffer-substring-no-properties
                (or bound (point-min)) (point)))
         (times (mapcar 'pb/parse-time
                        (mapcar 'cadr (pb/string-match-all regex text 1)))))
    (car (nreverse (sort times 'string<)))))

(defun pb/run-process (dir command &rest args)
  "In DIR (or `default-directory' if unset) run COMMAND with ARGS.
Output is written to the current buffer."
  (let* ((default-directory (file-name-as-directory (or dir default-directory)))
         (argv (if package-build-timeout-executable
                   (append (list package-build-timeout-executable "-k" "60" "600" command) args)
                 (cons command args))))
    (unless (file-directory-p default-directory)
      (error "Can't run process in non-existent directory: %s" default-directory))
    (let ((exit-code (apply 'process-file (car argv) nil (current-buffer) t (cdr argv))))
      (or (zerop exit-code)
          (error "Command '%s' exited with non-zero status %d: %s"
                 argv exit-code (buffer-string))))))

(defun pb/run-process-match (regex dir prog &rest args)
  "Find match for REGEX when - in DIR, or `default-directory' if unset - we run PROG with ARGS."
  (with-temp-buffer
    (apply 'pb/run-process dir prog args)
    (goto-char (point-min))
    (re-search-forward regex)
    (match-string-no-properties 1)))

(defun package-build-checkout (package-name config working-dir)
  "Check out source for PACKAGE-NAME with CONFIG under WORKING-DIR.
In turn, this function uses the :fetcher option in the CONFIG to
choose a source-specific fetcher function, which it calls with
the same arguments.

Returns a last-modification timestamp for the :files listed in
CONFIG, if any, or `package-build-default-files-spec' otherwise."
  (let ((repo-type (plist-get config :fetcher)))
    (pb/message "Fetcher: %s" repo-type)
    (unless (eq 'wiki repo-type)
      (pb/message "Source: %s\n" (or (plist-get config :repo) (plist-get config :url))))
    (funcall (intern (format "pb/checkout-%s" repo-type))
             package-name config (file-name-as-directory working-dir))))

(defvar pb/last-wiki-fetch-time 0
  "The time at which an emacswiki URL was last requested.
This is used to avoid exceeding the rate limit of 1 request per 2
seconds; the server cuts off after 10 requests in 20 seconds.")

(defvar pb/wiki-min-request-interval 3
  "The shortest permissible interval between successive requests for Emacswiki URLs.")

(defmacro pb/with-wiki-rate-limit (&rest body)
  "Rate-limit BODY code passed to this macro to match EmacsWiki's rate limiting."
  (let ((now (cl-gensym))
        (elapsed (cl-gensym)))
    `(let* ((,now (float-time))
            (,elapsed (- ,now pb/last-wiki-fetch-time)))
       (when (< ,elapsed pb/wiki-min-request-interval)
         (let ((wait (- pb/wiki-min-request-interval ,elapsed)))
           (pb/message "Waiting %.2f secs before hitting Emacswiki again" wait)
           (sleep-for wait)))
       (unwind-protect
           (progn ,@body)
         (setq pb/last-wiki-fetch-time (float-time))))))

(defun pb/grab-wiki-file (filename)
  "Download FILENAME from emacswiki, returning its last-modified time."
  (let* ((download-url
          (format "http://www.emacswiki.org/emacs/download/%s" filename))
         (wiki-url
          (format "http://www.emacswiki.org/emacs/%s" filename)))
    (pb/with-wiki-rate-limit
     (url-copy-file download-url filename t))
    (when (zerop (nth 7 (file-attributes filename)))
      (error "Wiki file %s was empty - has it been removed?" filename))
    ;; The Last-Modified response header for the download is actually
    ;; correct for the file, but we have no access to that
    ;; header. Instead, we must query the non-raw emacswiki page for
    ;; the file.
    ;; Since those Emacswiki lookups are time-consuming, we maintain a
    ;; foo.el.stamp file containing ("SHA1" . "PARSED_TIME")
    (let* ((new-content-hash (secure-hash 'sha1 (pb/slurp-file filename)))
           (stamp-file (concat filename ".stamp"))
           (stamp-info (pb/read-from-file stamp-file))
           (prev-content-hash (car stamp-info)))
      (if (and prev-content-hash
               (string-equal new-content-hash prev-content-hash))
          ;; File has not changed, so return old timestamp
          (progn
            (pb/message "%s is unchanged" filename)
            (cdr stamp-info))
        (pb/message "%s has changed - checking mod time" filename)
        (let ((new-timestamp
               (with-current-buffer (pb/with-wiki-rate-limit
                                     (url-retrieve-synchronously wiki-url))
                 (unless (= 200 url-http-response-status)
                   (error "HTTP error %s fetching %s" url-http-response-status wiki-url))
                 (goto-char (point-max))
                 (pb/find-parse-time
                  "Last edited \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\} [A-Z]\\{3\\}\\)"
                  url-http-end-of-headers))))
          (pb/dump (cons new-content-hash new-timestamp) stamp-file)
          new-timestamp)))))

(defun pb/checkout-wiki (name config dir)
  "Checkout package NAME with config CONFIG from the EmacsWiki into DIR."
  (unless package-build-stable
    (with-current-buffer (get-buffer-create "*package-build-checkout*")
      (unless (file-exists-p dir)
        (make-directory dir))
      (let ((files (or (plist-get config :files)
                       (list (format "%s.el" name))))
            (default-directory dir))
        (car (nreverse (sort (mapcar 'pb/grab-wiki-file files) 'string-lessp)))))))

(defun pb/darcs-repo (dir)
  "Get the current darcs repo for DIR."
  (pb/run-process-match "Default Remote: \\(.*\\)" dir "darcs" "show" "repo"))

(defun pb/checkout-darcs (name config dir)
  "Check package NAME with config CONFIG out of darcs into DIR."
  (unless package-build-stable
    (let ((repo (plist-get config :url)))
      (with-current-buffer (get-buffer-create "*package-build-checkout*")
        (cond
         ((and (file-exists-p (expand-file-name "_darcs" dir))
               (string-equal (pb/darcs-repo dir) repo))
          (pb/princ-exists dir)
          (pb/run-process dir "darcs" "pull"))
         (t
          (when (file-exists-p dir)
            (delete-directory dir t))
          (pb/princ-checkout repo dir)
          (pb/run-process nil "darcs" "get" repo dir)))
        (apply 'pb/run-process dir "darcs" "changes" "--max-count" "1"
               (pb/expand-source-file-list dir config))
        (pb/find-parse-time
         "\\([a-zA-Z]\\{3\\} [a-zA-Z]\\{3\\} \\( \\|[0-9]\\)[0-9] [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\} [A-Za-z]\\{3\\} [0-9]\\{4\\}\\)")))))

(defun pb/fossil-repo (dir)
  "Get the current fossil repo for DIR."
  (pb/run-process-match "\\(.*\\)" dir "fossil" "remote-url"))

(defun pb/checkout-fossil (name config dir)
  "Check package NAME with config CONFIG out of fossil into DIR."
  (unless package-build-stable
    (let ((repo (plist-get config :url)))
      (with-current-buffer (get-buffer-create "*package-build-checkout*")
        (cond
         ((and (or (file-exists-p (expand-file-name ".fslckout" dir))
                   (file-exists-p (expand-file-name "_FOSSIL_" dir)))
               (string-equal (pb/fossil-repo dir) repo))
          (pb/princ-exists dir)
          (pb/run-process dir "fossil" "update"))
         (t
          (when (file-exists-p dir)
            (delete-directory dir t))
          (pb/princ-checkout repo dir)
          (make-directory dir)
          (pb/run-process dir "fossil" "clone" repo "repo.fossil")
          (pb/run-process dir "fossil" "open" "repo.fossil")))
        (pb/run-process dir "fossil" "timeline" "-n" "1" "-t" "ci")
        (or (pb/find-parse-time
             "=== \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} ===\n[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\) ")
            (error "No valid timestamps found!"))))))

(defun pb/svn-repo (dir)
  "Get the current svn repo for DIR."
  (pb/run-process-match "URL: \\(.*\\)" dir "svn" "info"))

(defun pb/trim (str &optional chr)
  "Return a copy of STR without any trailing CHR (or space if unspecified)."
  (if (equal (elt str (1- (length str))) (or chr ? ))
      (substring str 0 (1- (length str)))
    str))

(defun pb/princ-exists (dir)
  "Print a message that the contents of DIR will be updated."
  (pb/message "Updating %s" dir))

(defun pb/princ-checkout (repo dir)
  "Print a message that REPO will be checked out into DIR."
  (pb/message "Cloning %s to %s" repo dir))

(defun pb/checkout-svn (name config dir)
  "Check package NAME with config CONFIG out of svn into DIR."
  (unless package-build-stable
    (with-current-buffer (get-buffer-create "*package-build-checkout*")
      (let ((repo (pb/trim (plist-get config :url) ?/))
            (bound (goto-char (point-max))))
        (cond
         ((and (file-exists-p (expand-file-name ".svn" dir))
               (string-equal (pb/svn-repo dir) repo))
          (pb/princ-exists dir)
          (pb/run-process dir "svn" "up"))
         (t
          (when (file-exists-p dir)
            (delete-directory dir t))
          (pb/princ-checkout repo dir)
          (pb/run-process nil "svn" "checkout" repo dir)))
        (apply 'pb/run-process dir "svn" "info"
               (pb/expand-source-file-list dir config))
        (or (pb/find-parse-time-latest "Last Changed Date: \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)" bound)
            (error "No valid timestamps found!"))))))


(defun pb/cvs-repo (dir)
  "Get the current CVS root and repository for DIR.

Return a cons cell whose `car' is the root and whose `cdr' is the repository."
  (apply 'cons
         (mapcar (lambda (file)
                   (pb/string-rtrim (pb/slurp-file (expand-file-name file dir))))
                 '("CVS/Root" "CVS/Repository"))))

(defun pb/checkout-cvs (name config dir)
  "Check package NAME with config CONFIG out of cvs into DIR."
  (unless package-build-stable
    (with-current-buffer (get-buffer-create "*package-build-checkout*")
      (let ((root (pb/trim (plist-get config :url) ?/))
            (repo (or (plist-get config :module) (symbol-name name)))
            (bound (goto-char (point-max))))
        (cond
         ((and (file-exists-p (expand-file-name "CVS" dir))
               (equal (pb/cvs-repo dir) (cons root repo)))
          (pb/princ-exists dir)
          (pb/run-process dir "cvs" "update" "-dP"))
         (t
          (when (file-exists-p dir)
            (delete-directory dir t))
          (pb/princ-checkout (format "%s from %s" repo root) dir)
          ;; CVS insists on relative paths as target directory for checkout (for
          ;; whatever reason), and puts "CVS" directories into every subdirectory
          ;; of the current working directory given in the target path. To get CVS
          ;; to just write to DIR, we need to execute CVS from the parent
          ;; directory of DIR, and specific DIR as relative path.  Hence all the
          ;; following mucking around with paths.  CVS is really horrid.
          (let* ((dir (directory-file-name dir))
                 (working-dir (file-name-directory dir))
                 (target-dir (file-name-nondirectory dir)))
            (pb/run-process working-dir "env" "TZ=UTC" "cvs" "-z3" "-d" root "checkout"
                            "-d" target-dir repo))))
        (apply 'pb/run-process dir "cvs" "log"
               (pb/expand-source-file-list dir config))
        (or (pb/find-parse-time-latest "date: \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)" bound)
            (pb/find-parse-time-latest "date: \\([0-9]\\{4\\}/[0-9]\\{2\\}/[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\);" bound)
            (error "No valid timestamps found!"))
        ))))


(defun pb/git-repo (dir)
  "Get the current git repo for DIR."
  (pb/run-process-match
   "Fetch URL: \\(.*\\)" dir "git" "remote" "show" "-n" "origin"))

(defun pb/git-head-branch (dir)
  "Get the current git repo for DIR."
  (or (ignore-errors
        (pb/run-process-match
         "HEAD branch: \\(.*\\)" dir "git" "remote" "show" "origin"))
      "master"))

(defun pb/checkout-git (name config dir)
  "Check package NAME with config CONFIG out of git into DIR."
  (let ((repo (plist-get config :url))
        (commit (or (plist-get config :commit)
                    (let ((branch (plist-get config :branch)))
                      (when branch
                        (concat "origin/" branch))))))
    (with-current-buffer (get-buffer-create "*package-build-checkout*")
      (goto-char (point-max))
      (cond
       ((and (file-exists-p (expand-file-name ".git" dir))
             (string-equal (pb/git-repo dir) repo))
        (pb/princ-exists dir)
        (pb/run-process dir "git" "remote" "update"))
       (t
        (when (file-exists-p dir)
          (delete-directory dir t))
        (pb/princ-checkout repo dir)
        (pb/run-process nil "git" "clone" repo dir)))
      (if package-build-stable
          (let* ((bound (goto-char (point-max)))
                 (tag-version (and (pb/run-process dir "git" "tag")
                                   (or (pb/find-tag-version-newest
                                        "^\\(?:v[.-]?\\)?\\([0-9]+[^ \t\n]*\\)$" bound)
                                       (error
                                        "No valid stable versions found for %s"
                                        name)))))
            ;; Using reset --hard here to comply with what's used for
            ;; unstable, but maybe this should be a checkout?
            (pb/run-process dir "git" "reset" "--hard" (concat "tags/" (car tag-version)))
            (pb/run-process dir "git" "submodule" "update" "--init" "--recursive")
            (cadr tag-version))
        (pb/run-process dir "git" "reset" "--hard"
                        (or commit (concat "origin/" (pb/git-head-branch dir))))
        (pb/run-process dir "git" "submodule" "update" "--init" "--recursive")
        (apply 'pb/run-process dir "git" "log" "--first-parent" "-n1" "--pretty=format:'\%ci'"
               (pb/expand-source-file-list dir config))
        (pb/find-parse-time
         "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))))

(defun pb/checkout-github (name config dir)
  "Check package NAME with config CONFIG out of github into DIR."
  (let* ((url (format "git://github.com/%s.git" (plist-get config :repo))))
    (pb/checkout-git name (plist-put (copy-sequence config) :url url) dir)))

(defun pb/bzr-expand-repo (repo)
  "Get REPO expanded name."
  (pb/run-process-match "\\(?:branch root\\|repository branch\\): \\(.*\\)" nil "bzr" "info" repo))

(defun pb/bzr-repo (dir)
  "Get the current bzr repo for DIR."
  (pb/run-process-match "parent branch: \\(.*\\)" dir "bzr" "info"))

(defun pb/checkout-bzr (name config dir)
  "Check package NAME with config CONFIG out of bzr into DIR."
  (unless package-build-stable
    (let ((repo (pb/bzr-expand-repo (plist-get config :url))))
      (with-current-buffer (get-buffer-create "*package-build-checkout*")
        (goto-char (point-max))
        (cond
         ((and (file-exists-p (expand-file-name ".bzr" dir))
               (string-equal (pb/bzr-repo dir) repo))
          (pb/princ-exists dir)
          (pb/run-process dir "bzr" "merge"))
         (t
          (when (file-exists-p dir)
            (delete-directory dir t))
          (pb/princ-checkout repo dir)
          (pb/run-process nil "bzr" "branch" repo dir)))
        (apply 'pb/run-process dir "bzr" "log" "-l1"
               (pb/expand-source-file-list dir config))
        (pb/find-parse-time
         "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))))

(defun pb/hg-repo (dir)
  "Get the current hg repo for DIR."
  (pb/run-process-match "default = \\(.*\\)" dir "hg" "paths"))

(defun pb/checkout-hg (name config dir)
  "Check package NAME with config CONFIG out of hg into DIR."
  (let ((repo (plist-get config :url)))
    (with-current-buffer (get-buffer-create "*package-build-checkout*")
      (goto-char (point-max))
      (cond
       ((and (file-exists-p (expand-file-name ".hg" dir))
             (string-equal (pb/hg-repo dir) repo))
        (pb/princ-exists dir)
        (pb/run-process dir "hg" "pull")
        (pb/run-process dir "hg" "update"))
       (t
        (when (file-exists-p dir)
          (delete-directory dir t))
        (pb/princ-checkout repo dir)
        (pb/run-process nil "hg" "clone" repo dir)))
      (if package-build-stable
          (let* ((bound (goto-char (point-max)))
                 (tag-version (and (pb/run-process dir "hg" "tags")
                                   (or (pb/find-tag-version-newest
                                        "^\\(?:v[.-]?\\)?\\([0-9]+[^ \t\n]*\\)[ \t]*[0-9]+:\\([[:xdigit:]]+\\)$"
                                        bound
                                        2)
                                       (error
                                        "No valid stable versions found for %s"
                                        name)))))
            (pb/run-process dir "hg" "update" (nth 2 tag-version))
            (cadr tag-version))
        (apply 'pb/run-process dir "hg" "log" "--style" "compact" "-l1"
               (pb/expand-source-file-list dir config))
        (pb/find-parse-time
         "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))))

(defun pb/dump (data file &optional pretty-print)
  "Write DATA to FILE as a Lisp sexp.
Optionally PRETTY-PRINT the data."
  (with-temp-file file
    (pb/message "File: %s" file)
    (if pretty-print
        (pp data (current-buffer))
      (print data (current-buffer)))))

(defun pb/write-pkg-file (pkg-file pkg-info)
  "Write PKG-FILE containing PKG-INFO."
  (with-temp-file pkg-file
    (pp
     `(define-package
        ,(aref pkg-info 0)
        ,(aref pkg-info 3)
        ,(aref pkg-info 2)
        ',(mapcar
           (lambda (elt)
             (list (car elt)
                   (package-version-join (cadr elt))))
           (aref pkg-info 1))
        ;; Append our extra information
        ,@(apply #'append (mapcar (lambda (entry)
                                    (let ((value (cdr entry)))
                                      (when (or (symbolp value) (listp value))
                                        ;; We must quote lists and symbols,
                                        ;; because Emacs 24.3 and earlier evaluate
                                        ;; the package information, which would
                                        ;; break for unquoted symbols or lists
                                        (setq value (list 'quote value)))
                                      (list (car entry) value)))
                                  (when (> (length pkg-info) 4)
                                    (aref pkg-info 4)))))
     (current-buffer))
    (princ ";; Local Variables:\n;; no-byte-compile: t\n;; End:\n" (current-buffer))))

(defun pb/read-from-file (file-name)
  "Read and return the Lisp data stored in FILE-NAME, or nil if no such file exists."
  (when (file-exists-p file-name)
    (car (read-from-string (pb/slurp-file file-name)))))

(defun pb/create-tar (file dir &optional files)
  "Create a tar FILE containing the contents of DIR, or just FILES if non-nil."
  (apply 'process-file
         package-build-tar-executable nil
         (get-buffer-create "*package-build-checkout*")
         nil "-cvf"
         file
         "--exclude=.svn"
         "--exclude=CVS"
         "--exclude=.git*"
         "--exclude=_darcs"
         "--exclude=.fslckout"
         "--exclude=_FOSSIL_"
         "--exclude=.bzr"
         "--exclude=.hg"
         (or (mapcar (lambda (fn) (concat dir "/" fn)) files) (list dir))))


(defun pb/find-package-commentary (file-path)
  "Get commentary section from FILE-PATH."
  (when (file-exists-p file-path)
    (with-temp-buffer
      (insert-file-contents file-path)
      (lm-commentary))))

(defun pb/write-pkg-readme (target-dir commentary file-name)
  "In TARGET-DIR, write COMMENTARY to a -readme.txt file prefixed with FILE-NAME."
  (when commentary
    (with-temp-buffer
      (insert commentary)
      ;; Adapted from `describe-package-1'.
      (goto-char (point-min))
      (save-excursion
        (when (re-search-forward "^;;; Commentary:\n" nil t)
          (replace-match ""))
        (while (re-search-forward "^\\(;+ ?\\)" nil t)
          (replace-match ""))
        (goto-char (point-min))
        (when (re-search-forward "\\`\\( *\n\\)+" nil t)
          (replace-match "")))
      (delete-trailing-whitespace)
      (let ((coding-system-for-write buffer-file-coding-system))
        (write-region nil nil
                      (pb/readme-file-name target-dir file-name))))))

(defun pb/readme-file-name (target-dir file-name)
  "Name of the readme file in TARGET-DIR for the package FILE-NAME."
  (expand-file-name (concat file-name "-readme.txt")
                    target-dir))

(defun pb/update-or-insert-version (version)
  "Ensure current buffer has a \"Version: VERSION\" header."
  (goto-char (point-min))
  (if (re-search-forward "^;;;* *Version: *" nil t)
      (progn
        (move-beginning-of-line nil)
        (search-forward "V" nil t)
        (backward-char)
        (insert "X-Original-")
        (move-beginning-of-line nil))
    (forward-line))
  (insert (format ";; Version: %s" version))
  (newline))

(defun pb/ensure-ends-here-line (file-path)
  "Add a 'FILE-PATH ends here' trailing line if missing."
  (save-excursion
    (goto-char (point-min))
    (let* ((fname (file-name-nondirectory file-path))
           (trailer (concat ";;; " fname " ends here")))
      (unless (search-forward trailer nil t)
        (goto-char (point-max))
        (newline)
        (insert trailer)
        (newline)))))

(defun pb/get-package-info (file-path)
  "Get a vector of package info from the docstrings in FILE-PATH."
  (when (file-exists-p file-path)
    (ignore-errors
      (with-temp-buffer
        (insert-file-contents file-path)
        ;; next few lines are a hack for some packages that aren't
        ;; commented properly.
        (pb/update-or-insert-version "0")
        (pb/ensure-ends-here-line file-path)
        (cl-flet ((package-strip-rcs-id (str) "0"))
          (pb/package-buffer-info-vec))))))

(defun pb/get-pkg-file-info (file-path)
  "Get a vector of package info from \"-pkg.el\" file FILE-PATH."
  (when (file-exists-p file-path)
    (let ((package-def (pb/read-from-file file-path)))
      (if (eq 'define-package (car package-def))
          (let ((pkgfile-info (cdr package-def)))
            (vector
             (nth 0 pkgfile-info)
             (mapcar
              (lambda (elt)
                (list (car elt) (version-to-list (cadr elt))))
              (eval (nth 3 pkgfile-info)))
             (nth 2 pkgfile-info)
             (nth 1 pkgfile-info)))
        (error "No define-package found in %s" file-path)))))

(defun pb/merge-package-info (pkg-info name version)
  "Return a version of PKG-INFO updated with NAME, VERSION and info from CONFIG.
If PKG-INFO is nil, an empty one is created."
  (let* ((merged (or (copy-sequence pkg-info)
                     (vector name nil "No description available." version))))
    (aset merged 0 name)
    (aset merged 3 version)
    merged))

(defun pb/archive-entry (pkg-info type)
  "Return the archive-contents cons cell for PKG-INFO and TYPE."
  (let* ((name (intern (aref pkg-info 0)))
         (requires (aref pkg-info 1))
         (desc (or (aref pkg-info 2) "No description available."))
         (version (aref pkg-info 3))
         (extras (when (> (length pkg-info) 4)
                   (aref pkg-info 4))))
    (cons name
          (vector (version-to-list version)
                  requires
                  desc
                  type
                  extras))))

(defun pb/archive-file-name (archive-entry)
  "Return the path of the file in which the package for ARCHIVE-ENTRY is stored."
  (let* ((name (car archive-entry))
         (pkg-info (cdr archive-entry))
         (version (package-version-join (aref pkg-info 0)))
         (flavour (aref pkg-info 3)))
    (expand-file-name
     (format "%s-%s.%s" name version (if (eq flavour 'single) "el" "tar"))
     package-build-archive-dir)))

(defun pb/entry-file-name (archive-entry)
  "Return the path of the file in which the package for ARCHIVE-ENTRY is stored."
  (let* ((name (car archive-entry))
         (pkg-info (cdr archive-entry))
         (version (package-version-join (aref pkg-info 0))))
    (expand-file-name
     (format "%s-%s.entry" name version)
     package-build-archive-dir)))

(defun pb/delete-file-if-exists (file)
  "Delete FILE if it exists."
  (when (file-exists-p file)
    (delete-file file)))

(defun pb/remove-archive-files (archive-entry)
  "Remove ARCHIVE-ENTRY from archive-contents, and delete associated file.
Note that the working directory (if present) is not deleted by
this function, since the archive list may contain another version
of the same-named package which is to be kept."
  (pb/message "Removing archive: %s" archive-entry)
  (mapcar 'pb/delete-file-if-exists
          (list  (pb/archive-file-name archive-entry)
                 (pb/entry-file-name archive-entry))))

(defun pb/read-recipe (file-name)
  "Return the plist of recipe info for the package called FILE-NAME."
  (let ((pkg-info (pb/read-from-file file-name)))
    (if (string= (symbol-name (car pkg-info))
                 (file-name-nondirectory file-name))
        pkg-info
      (error "Recipe '%s' contains mismatched package name '%s'"
             (file-name-nondirectory file-name)
             (car pkg-info)))))

(defun pb/read-recipes ()
  "Return a list of data structures for all recipes in `package-build-recipes-dir'."
  (cl-loop for file-name in (directory-files  package-build-recipes-dir t "^[^.]")
           collect (pb/read-recipe file-name)))

(defun pb/read-recipes-ignore-errors ()
  "Return a list of data structures for all recipes in `package-build-recipes-dir'."
  (cl-loop for file-name in (directory-files  package-build-recipes-dir t "^[^.]")
           for pkg-info = (condition-case err (pb/read-recipe file-name)
                            (error (pb/message "Error reading recipe %s: %s"
                                               file-name
                                               (error-message-string err))
                                   nil))
           when pkg-info
           collect pkg-info))


(defun package-build-expand-file-specs (dir specs &optional subdir allow-empty)
  "In DIR, expand SPECS, optionally under SUBDIR.
The result is a list of (SOURCE . DEST), where SOURCE is a source
file path and DEST is the relative path to which it should be copied.

If the resulting list is empty, an error will be reported.  Pass t
for ALLOW-EMPTY to prevent this error."
  (let ((default-directory dir)
        (prefix (if subdir (format "%s/" subdir) ""))
        (lst))
    (dolist (entry specs lst)
      (setq lst
            (if (consp entry)
                (if (eq :exclude (car entry))
                    (cl-nset-difference lst
                                        (package-build-expand-file-specs dir (cdr entry) nil t)
                                        :key 'car
                                        :test 'equal)
                  (nconc lst
                         (package-build-expand-file-specs
                          dir
                          (cdr entry)
                          (concat prefix (car entry))
                          t)))
              (nconc
               lst (mapcar (lambda (f)
                             (let ((destname)))
                             (cons f
                                   (concat prefix
                                           (replace-regexp-in-string
                                            "\\.in\\'"
                                            ""
                                            (file-name-nondirectory f)))))
                           (file-expand-wildcards entry))))))
    (when (and (null lst) (not allow-empty))
      (error "No matching file(s) found in %s: %s" dir specs))
    lst))


(defun pb/config-file-list (config)
  "Get the :files spec from CONFIG, or return `package-build-default-files-spec'."
  (or (plist-get config :files) package-build-default-files-spec))

(defun pb/expand-source-file-list (dir config)
  "Shorthand way to expand paths in DIR for source files listed in CONFIG."
  (mapcar 'car (package-build-expand-file-specs dir (pb/config-file-list config))))

(defun pb/generate-info-files (files source-dir target-dir)
  "Create .info files from any .texi files listed in FILES.

The source and destination file paths are expanded in SOURCE-DIR
and TARGET-DIR respectively.

Any of the original .texi(nfo) files found in TARGET-DIR are
deleted."
  (dolist (spec files)
    (let* ((source-file (car spec))
           (source-path (expand-file-name source-file source-dir))
           (dest-file (cdr spec))
           (info-path (expand-file-name
                       (concat (file-name-sans-extension dest-file) ".info")
                       target-dir)))
      (when (string-match ".texi\\(nfo\\)?$" source-file)
        (when (not (file-exists-p info-path))
          (with-current-buffer (get-buffer-create "*package-build-info*")
            (ignore-errors
              (pb/run-process
               (file-name-directory source-path)
               "makeinfo"
               source-path
               "-o"
               info-path)
              (pb/message "Created %s" info-path))))
        (pb/message "Removing %s" (expand-file-name dest-file target-dir))
        (delete-file (expand-file-name dest-file target-dir))))))

(defun pb/generate-dir-file (files target-dir)
  "Create dir file from any .info files listed in FILES in TARGET-DIR."
  (dolist (spec files)
    (let* ((source-file (car spec))
           (dest-file (cdr spec))
           (info-path (expand-file-name
                       (concat (file-name-sans-extension dest-file) ".info")
                       target-dir)))
      (when (and (or (string-match ".info$" source-file)
                     (string-match ".texi\\(nfo\\)?$" source-file))
                 (file-exists-p info-path))
        (with-current-buffer (get-buffer-create "*package-build-info*")
          (ignore-errors
            (pb/run-process
             nil
             "install-info"
             (concat "--dir=" (expand-file-name "dir" target-dir))
             info-path)))))))

(defun pb/copy-package-files (files source-dir target-dir)
  "Copy FILES from SOURCE-DIR to TARGET-DIR.
FILES is a list of (SOURCE . DEST) relative filepath pairs."
  (cl-loop for (source-file . dest-file) in files
           do (pb/copy-file
               (expand-file-name source-file source-dir)
               (expand-file-name dest-file target-dir))))

(defun pb/copy-file (file newname)
  "Copy FILE to NEWNAME and create parent directories for NEWNAME if they don't exist."
  (let ((newdir (file-name-directory newname)))
    (unless (file-exists-p newdir)
      (make-directory newdir t)))
  (cond
   ((file-regular-p file)
    (pb/message "%s -> %s" file newname)
    (copy-file file newname))
   ((file-directory-p file)
    (pb/message "%s => %s" file newname)
    (copy-directory file newname))))


(defun pb/package-name-completing-read ()
  "Prompt for a package name, returning a symbol."
  (intern (completing-read "Package: " (package-build-recipe-alist))))

(defun pb/find-source-file (target files)
  "Search for source of TARGET in FILES."
  (let* ((entry (rassoc target files)))
    (when entry (car entry))))

(defun pb/find-package-file (name)
  "Return the filename of the most recently built package of NAME."
  (pb/archive-file-name (assoc name (package-build-archive-alist))))

(defun pb/package-buffer-info-vec ()
  "Return a vector of package info.
`package-buffer-info' returns a vector in older Emacs versions,
and a cl struct in Emacs HEAD.  This wrapper normalises the results."
  (let ((desc (package-buffer-info))
        (keywords (lm-keywords-list)))
    (if (fboundp 'package-desc-create)
        (let ((extras (package-desc-extras desc)))
          (when (and keywords (not (assq :keywords extras)))
            ;; Add keywords to package properties, if not already present
            (push (cons :keywords keywords) extras))
          (vector (package-desc-name desc)
                  (package-desc-reqs desc)
                  (package-desc-summary desc)
                  (package-desc-version desc)
                  extras))
      ;; The regexp and the processing is taken from `lm-homepage' in Emacs 24.4
      (let* ((page (lm-header "\\(?:x-\\)?\\(?:homepage\\|url\\)"))
             (homepage (if (and page (string-match "^<.+>$" page))
                           (substring page 1 -1)
                         page))
             extras)
        (when keywords (push (cons :keywords keywords) extras))
        (when homepage (push (cons :url homepage) extras))
        (vector  (aref desc 0)
                 (aref desc 1)
                 (aref desc 2)
                 (aref desc 3)
                 extras)))))


;;; Public interface
;;;###autoload
(defun package-build-archive (name)
  "Build a package archive for package NAME."
  (interactive (list (pb/package-name-completing-read)))
  (let* ((file-name (symbol-name name))
         (rcp (or (cdr (assoc name (package-build-recipe-alist)))
                  (error "Cannot find package %s" file-name)))
         (pkg-working-dir
          (file-name-as-directory
           (expand-file-name file-name package-build-working-dir))))

    (unless (file-exists-p package-build-archive-dir)
      (pb/message "Creating directory %s" package-build-archive-dir)
      (make-directory package-build-archive-dir))

    (pb/message "\n;;; %s\n" file-name)
    (let* ((version (package-version-join
                     (version-to-list
                      (or (package-build-checkout name rcp pkg-working-dir)
                          (error "No valid package version found!")))))
           (default-directory package-build-working-dir)
           (start-time (current-time))
           (archive-entry (package-build-package (symbol-name name)
                                                 version
                                                 (pb/config-file-list rcp)
                                                 pkg-working-dir
                                                 package-build-archive-dir)))
      (pb/dump archive-entry (pb/entry-file-name archive-entry))
      (when package-build-write-melpa-badge-images
        (pb/write-melpa-badge-image (symbol-name name) version package-build-archive-dir))
      (pb/message "Built in %.3fs, finished at %s"
                  (time-to-seconds (time-since start-time))
                  (current-time-string))
      file-name)))

;;;###autoload
(defun package-build-package (package-name version file-specs source-dir target-dir)
  "Create PACKAGE-NAME with VERSION.

The information in FILE-SPECS is used to gather files from
SOURCE-DIR.

The resulting package will be stored as a .el or .tar file in
TARGET-DIR, depending on whether there are multiple files.

Argument FILE-SPECS is a list of specs for source files, which
should be relative to SOURCE-DIR.  The specs can be wildcards,
and optionally specify different target paths.  They extended
syntax is currently only documented in the MELPA README.  You can
simply pass `package-build-default-files-spec' in most cases.

Returns the archive entry for the package."
  (when (symbolp package-name)
    (setq package-name (symbol-name package-name)))
  (let ((files (package-build-expand-file-specs source-dir file-specs)))
    (unless (equal file-specs package-build-default-files-spec)
      (when (equal files (package-build-expand-file-specs
                          source-dir package-build-default-files-spec nil t))
        (pb/message "Note: this :files spec is equivalent to the default.")))
    (cond
     ((not version)
      (error "Unable to check out repository for %s" package-name))
     ((= 1 (length files))
      (pb/build-single-file-package package-name version (caar files) source-dir target-dir))
     ((< 1 (length  files))
      (pb/build-multi-file-package package-name version files source-dir target-dir))
     (t (error "Unable to find files matching recipe patterns")))))

(defun pb/build-single-file-package (package-name version file source-dir target-dir)
  (let* ((pkg-source (expand-file-name file source-dir))
         (pkg-target (expand-file-name
                      (concat package-name "-" version ".el")
                      target-dir))
         (pkg-info (pb/merge-package-info
                    (pb/get-package-info pkg-source)
                    package-name
                    version)))
    (unless (string-equal (downcase (concat package-name ".el"))
                          (downcase (file-name-nondirectory pkg-source)))
      (error "Single file %s does not match package name %s"
             (file-name-nondirectory pkg-source) package-name))
    (when (file-exists-p pkg-target)
      (delete-file pkg-target))
    (copy-file pkg-source pkg-target)
    (let ((enable-local-variables nil)
          (make-backup-files nil))
      (with-current-buffer (find-file pkg-target)
        (pb/update-or-insert-version version)
        (pb/ensure-ends-here-line pkg-source)
        (write-file pkg-target nil)
        (condition-case err
            (pb/package-buffer-info-vec)
          (error
           (pb/message "Warning: %S" err)))
        (kill-buffer)))

    (pb/write-pkg-readme target-dir
                         (pb/find-package-commentary pkg-source)
                         package-name)
    (pb/archive-entry pkg-info 'single)))

(defun pb/build-multi-file-package (package-name version files source-dir target-dir)
  (let* ((tmp-dir (file-name-as-directory (make-temp-file package-name t)))
         (pkg-dir-name (concat package-name "-" version))
         (pkg-tmp-dir (expand-file-name pkg-dir-name tmp-dir))
         (pkg-file (concat package-name "-pkg.el"))
         (pkg-file-source (or (pb/find-source-file pkg-file files)
                              pkg-file))
         (file-source (concat package-name ".el"))
         (pkg-source (or (pb/find-source-file file-source files)
                         file-source))
         (pkg-info (pb/merge-package-info
                    (let ((default-directory source-dir))
                      (or (pb/get-pkg-file-info pkg-file-source)
                          ;; some packages (like magit) provide name-pkg.el.in
                          (pb/get-pkg-file-info
                           (expand-file-name (concat pkg-file ".in")
                                             (file-name-directory pkg-source)))
                          (pb/get-package-info pkg-source)))
                    package-name
                    version)))
    (pb/copy-package-files files source-dir pkg-tmp-dir)
    (pb/write-pkg-file (expand-file-name pkg-file
                                         (file-name-as-directory pkg-tmp-dir))
                       pkg-info)

    (pb/generate-info-files files source-dir pkg-tmp-dir)
    (pb/generate-dir-file files pkg-tmp-dir)

    (let ((default-directory tmp-dir))
      (pb/create-tar (expand-file-name (concat package-name "-" version ".tar")
                                       target-dir)
                     pkg-dir-name))

    (let ((default-directory source-dir))
      (pb/write-pkg-readme target-dir
                           (pb/find-package-commentary pkg-source)
                           package-name))

    (delete-directory pkg-tmp-dir t nil)
    (pb/archive-entry pkg-info 'tar)))


;; In future we should provide a hook, and perform this step in a separate package.
;; Note also that it would be straightforward to generate the SVG ourselves, which would
;; save the network overhead.
(defun pb/write-melpa-badge-image (package-name version target-dir)
  (url-copy-file
   (concat "http://img.shields.io/badge/"
           (if package-build-stable "melpa stable" "melpa")
           "-"
           (url-hexify-string version)
           "-"
           (if package-build-stable "3e999f" "922793")
           ".svg")
   (expand-file-name (concat package-name "-badge.svg") target-dir)
   t))


;;; Helpers for recipe authors

(defvar package-build-minor-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-c C-c") 'package-build-current-recipe)
    m)
  "Keymap for `package-build-minor-mode'.")

(define-minor-mode package-build-minor-mode
  "Helpful functionality for building packages."
  nil
  " PBuild"
  package-build-minor-mode-map)

;;;###autoload
(defun package-build-create-recipe (name fetcher)
  "Create a new recipe for package NAME using FETCHER."
  (interactive
   (list (intern (read-string "Package name: "))
         (intern
          (let ((fetcher-types (mapcar #'symbol-name '(github git wiki bzr hg cvs svn))))
            (completing-read
             "Fetcher: "
             fetcher-types
             nil t nil nil (car fetcher-types))))))
  (let ((recipe-file (expand-file-name (symbol-name name) package-build-recipes-dir)))
    (when (file-exists-p recipe-file)
      (error "Recipe already exists"))
    (find-file recipe-file)
    (let* ((extra-params
            (cond
             ((eq 'github fetcher) '(:repo "USER/REPO"))
             ((eq 'wiki fetcher) '())
             (t '(:url "SCM_URL_HERE"))))
           (template `(,name :fetcher ,fetcher ,@extra-params)))
      (insert (pp-to-string template))
      (emacs-lisp-mode)
      (package-build-minor-mode)
      (goto-char (point-min)))))

;;;###autoload
(defun package-build-current-recipe ()
  "Build archive for the recipe defined in the current buffer."
  (interactive)
  (unless (and (buffer-file-name)
               (file-equal-p (file-name-directory (buffer-file-name))
                             package-build-recipes-dir))
    (error "Buffer is not visiting a recipe"))
  (when (buffer-modified-p)
    (if (y-or-n-p (format "Save file %s? " buffer-file-name))
        (save-buffer)
      (error "Aborting")))
  (check-parens)
  (package-build-reinitialize)
  (let ((pkg-name (intern (file-name-nondirectory (buffer-file-name)))))
    (package-build-archive pkg-name)
    (package-build-dump-archive-contents)
    (let ((output-buffer-name "*package-build-result*"))
      (with-output-to-temp-buffer output-buffer-name
        (princ ";; Please check the following package descriptor.\n")
        (princ ";; If the correct package description or dependencies are missing,\n")
        (princ ";; then the source .el file is likely malformed, and should be fixed.\n")
        (pp (assoc pkg-name (package-build-archive-alist))))
      (with-current-buffer output-buffer-name
        (emacs-lisp-mode)
        (view-mode)))
    (when (yes-or-no-p "Install new package? ")
      (package-install-file (pb/find-package-file pkg-name)))))

(defun package-build-archive-ignore-errors (pkg)
  "Build archive for package PKG, ignoring any errors."
  (interactive (list (pb/package-name-completing-read)))
  (let* ((debug-on-error t)
         (debug-on-signal t)
         (pb/debugger-return nil)
         (debugger (lambda (&rest args)
                     (setq pb/debugger-return (with-output-to-string
                                                (backtrace))))))
    (condition-case err
        (package-build-archive pkg)
      (error
       (pb/message "%s" (error-message-string err))
       nil))))



;;;###autoload
(defun package-build-all ()
  "Build all packages in the `package-build-recipe-alist'."
  (interactive)
  (let ((failed (cl-loop for pkg in (mapcar 'car (package-build-recipe-alist))
                         when (not (package-build-archive-ignore-errors pkg))
                         collect pkg)))
    (if (not failed)
        (princ "\nSuccessfully Compiled All Packages\n")
      (princ "\nFailed to Build the Following Packages\n")
      (princ (mapconcat 'symbol-name failed "\n"))
      (princ "\n")))
  (package-build-cleanup))

(defun package-build-cleanup ()
  "Remove previously-built packages that no longer have recipes."
  (interactive)
  (let* ((known-package-names (mapcar 'car (package-build-recipe-alist)))
         (stale-archives (cl-loop for built in (pb/archive-entries)
                                  when (not (memq (car built) known-package-names))
                                  collect built)))
    (mapc 'pb/remove-archive-files stale-archives)
    (package-build-dump-archive-contents)))

(defun package-build-recipe-alist ()
  "Retun the list of avalailable packages."
  (unless pb/recipe-alist-initialized
    (setq pb/recipe-alist (pb/read-recipes-ignore-errors)
          pb/recipe-alist-initialized t))
  pb/recipe-alist)

(defun package-build-archive-alist ()
  "Return the archive list."
  (cdr (pb/read-from-file
        (expand-file-name "archive-contents"
                          package-build-archive-dir))))

(defun package-build-reinitialize ()
  "Forget any information about packages which have already been built."
  (interactive)
  (setq pb/recipe-alist-initialized nil))

(defun package-build-dump-archive-contents (&optional file-name)
  "Dump the list of built packages to FILE-NAME.

If FILE-NAME is not specified, the default archive-contents file is used."
  (pb/dump (cons 1 (pb/archive-entries))
           (or file-name
               (expand-file-name "archive-contents" package-build-archive-dir))))

(defun pb/archive-entries ()
  "Read all .entry files from the archive directory and return a list of all entries."
  (let ((entries '()))
    (dolist (new (mapcar 'pb/read-from-file
                         (directory-files package-build-archive-dir t
                                          ".*\.entry$"))
                 entries)
      (let ((old (assq (car new) entries)))
        (when old
          (when (version-list-< (elt (cdr new) 0)
                                (elt (cdr old) 0))
            ;; swap old and new
            (cl-rotatef old new))
          (pb/remove-archive-files old)
          (setq entries (remove old entries)))
        (add-to-list 'entries new)))))



;;; Exporting data as json

(defun package-build-recipe-alist-as-json (file-name)
  "Dump the recipe list to FILE-NAME as json."
  (interactive)
  (with-temp-file file-name
    (insert (json-encode (package-build-recipe-alist)))))

(defun pb/sym-to-keyword (s)
  "Return a version of symbol S as a :keyword."
  (intern (concat ":" (symbol-name s))))

(defun pb/pkg-info-for-json (info)
  "Convert INFO into a data structure which will serialize to JSON in the desired shape."
  (let* ((ver (elt info 0))
         (deps (elt info 1))
         (desc (elt info 2))
         (type (elt info 3))
         (props (when (> (length info) 4) (elt info 4))))
    (list :ver ver
          :deps (apply 'append
                       (mapcar (lambda (dep)
                                 (list (pb/sym-to-keyword (car dep))
                                       (cadr dep)))
                               deps))
          :desc desc
          :type type
          :props props)))

(defun pb/archive-alist-for-json ()
  "Return the archive alist in a form suitable for JSON encoding."
  (apply 'append
         (mapcar (lambda (entry)
                   (list (pb/sym-to-keyword (car entry))
                         (pb/pkg-info-for-json (cdr entry))))
                 (package-build-archive-alist))))

(defun package-build-archive-alist-as-json (file-name)
  "Dump the build packages list to FILE-NAME as json."
  (interactive)
  (with-temp-file file-name
    (insert (json-encode (pb/archive-alist-for-json)))))

(provide 'package-build)

;; Local Variables:
;; coding: utf-8
;; eval: (checkdoc-minor-mode 1)
;; End:

;;; package-build.el ends here
