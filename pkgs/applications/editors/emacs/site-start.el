;; -*- lexical-binding: t; -*-
(defun nix--profile-paths ()
  "Return a list of all paths in NIX_PROFILES.
The list is ordered from more-specific (the user profile) to the
least specific (the system profile)"
  (reverse (split-string (or (getenv "NIX_PROFILES") ""))))

;;; Extend `load-path' to search for elisp files in subdirectories of all folders in `NIX_PROFILES'.
;;; Non-Nix distros have similar logic in /usr/share/emacs/site-lisp/subdirs.el.
;;; See https://www.gnu.org/software/emacs/manual/html_node/elisp/Library-Search.html
(dolist (profile (nix--profile-paths))
  (let ((default-directory (expand-file-name "share/emacs/site-lisp/" profile)))
    (when (file-exists-p default-directory)
      (setq load-path (cons default-directory load-path))
      (normal-top-level-add-subdirs-to-load-path))))

;;; Remove wrapper site-lisp from EMACSLOADPATH so it's not propagated
;;; to any other Emacsen that might be started as subprocesses.
(let ((wrapper-site-lisp (getenv "emacsWithPackages_siteLisp"))
      (env-load-path (getenv "EMACSLOADPATH")))
  (when wrapper-site-lisp
    (setenv "emacsWithPackages_siteLisp" nil))
  (when (and wrapper-site-lisp env-load-path)
    (let* ((env-list (split-string env-load-path ":"))
           (new-env-list (delete wrapper-site-lisp env-list)))
      (setenv "EMACSLOADPATH" (when new-env-list
                                (mapconcat 'identity new-env-list ":"))))))

(let ((wrapper-site-lisp (getenv "emacsWithPackages_siteLispNative"))
      (env-load-path (getenv "EMACSNATIVELOADPATH")))
  (when wrapper-site-lisp
    (setenv "emacsWithPackages_siteLispNative" nil))
  (when (and wrapper-site-lisp env-load-path)
    (let* ((env-list (split-string env-load-path ":"))
           (new-env-list (delete wrapper-site-lisp env-list)))
      (setenv "EMACSNATIVELOADPATH" (when new-env-list
                                (mapconcat 'identity new-env-list ":"))))))

;;; Set up native-comp load path.
(when (featurep 'comp)
  ;; Append native-comp subdirectories from `NIX_PROFILES'.
  (setq native-comp-eln-load-path
        (append (mapcar (lambda (profile-dir)
                          (concat profile-dir "/share/emacs/native-lisp/"))
                        (nix--profile-paths))
                native-comp-eln-load-path)))

;;; Make `woman' find the man pages
(defvar woman-manpath)
(eval-after-load 'woman
  '(setq woman-manpath
         (append (mapcar (lambda (x) (concat x "/share/man/"))
                         (nix--profile-paths))
                 woman-manpath)))

;;; Make tramp work for remote NixOS machines
(defvar tramp-remote-path)
(eval-after-load 'tramp-sh
  ;; TODO: We should also add the other `NIX_PROFILES' to this path.
  ;; However, these are user-specific, so we would need to discover
  ;; them dynamically after connecting via `tramp'
  '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))

;;; C source directory
;;;
;;; Computes the location of the C source directory from the path of
;;; the current file:
;;; from: /nix/store/<hash>-emacs-<version>/share/emacs/site-lisp/site-start.el
;;; to:   /nix/store/<hash>-emacs-<version>/share/emacs/<version>/src/
(defvar find-function-C-source-directory)
(let ((emacs
       (file-name-directory                      ; .../emacs/
        (directory-file-name                     ; .../emacs/site-lisp
         (file-name-directory load-file-name)))) ; .../emacs/site-lisp/
      (version
       (file-name-as-directory
        emacs-version))
      (src (file-name-as-directory "src")))
  (setq find-function-C-source-directory (concat emacs version src)))
