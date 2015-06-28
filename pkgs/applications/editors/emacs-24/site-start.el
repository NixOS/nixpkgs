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

;; Make tramp work for remote NixOS machines
;;; NOTE: You might want to add 
(eval-after-load 'tramp
  '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))
