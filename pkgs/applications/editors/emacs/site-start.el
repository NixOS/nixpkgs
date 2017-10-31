;;; NixOS specific load-path
(setq load-path
      (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                               (split-string (or (getenv "NIX_PROFILES") ""))))
              load-path))

;;; Make `woman' find the man pages
(eval-after-load 'woman
  '(setq woman-manpath
         (append (reverse (mapcar (lambda (x) (concat x "/share/man/"))
                                  (split-string (or (getenv "NIX_PROFILES") ""))))
                 woman-manpath)))

;;; Make tramp work for remote NixOS machines
(eval-after-load 'tramp
  '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))

;;; C source directory
;;;
;;; Computes the location of the C source directory from the path of
;;; the current file:
;;; from: /nix/store/<hash>-emacs-<version>/share/emacs/site-lisp/site-start.el
;;; to:   /nix/store/<hash>-emacs-<version>/share/emacs/<version>/src/
(let ((emacs
       (file-name-directory                      ;; .../emacs/
        (directory-file-name                     ;; .../emacs/site-lisp
         (file-name-directory load-file-name)))) ;; .../emacs/site-lisp/
      (version
       (file-name-as-directory
        (concat
         (number-to-string emacs-major-version)
         "."
         (number-to-string emacs-minor-version))))
      (src (file-name-as-directory "src")))
  (setq find-function-C-source-directory (concat emacs version src)))
