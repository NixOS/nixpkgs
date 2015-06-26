;; NixOS specific load-path
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

;;; Generate a global 'dir' file out of the paths in INFOPATH. This is
;;; equivalent to what is done in
;;; <nixpkgs>/nixos/modules/programs/info.nix.
(eval-after-load 'info
  '(progn
     ;; Emacs relies on the INFOPATH ending in `path-separator' to add
     ;; `Info-default-directory-list' to the list of info paths.
     (unless (string-match ":$" (getenv "INFOPATH"))
       (setenv "INFOPATH" (concat (getenv "INFOPATH") ":")))
     (info-initialize)
     (let* ((tmp-directory (make-temp-file "emacs-info-dir" t))
            (dir-file (expand-file-name "dir" tmp-directory)))
       (dolist (path Info-directory-list)
         (dolist (info-file (directory-files path t "\.info$" t))
           (call-process "install-info" nil nil nil info-file dir-file)))
       (add-to-list 'Info-directory-list tmp-directory))))

;; Make tramp work for remote NixOS machines
;;; NOTE: You might want to add 
(eval-after-load 'tramp
  '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))
