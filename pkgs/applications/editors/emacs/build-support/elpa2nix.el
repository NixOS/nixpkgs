(require 'package)
(package-initialize)

;; TODO remove this patch when Emacs bug#77143 is fixed
;; see that bug for more info
(defun package--description-file (dir)
  "Return package description file name for package DIR."
  (concat (let ((subdir (file-name-nondirectory
                         (directory-file-name dir))))
            (if (string-match "\\([^.].*?\\)-\\([0-9]+\\(?:[.][0-9]+\\|\\(?:pre\\|beta\\|alpha\\|snapshot\\)[0-9]+\\)*\\)\\'" subdir)
                (match-string 1 subdir) subdir))
          "-pkg.el"))

(defun elpa2nix-install-package ()
  (if (not noninteractive)
      (error "`elpa2nix-install-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,archive ,elpa ,turn-compilation-warning-to-error ,ignore-compilation-error)
     (progn (setq byte-compile-error-on-warn (string= turn-compilation-warning-to-error "t"))
            (setq byte-compile-debug (string= ignore-compilation-error "nil"))
            (setq package-user-dir elpa)
            (elpa2nix-install-file archive)))))

(defun elpa2nix-install-from-buffer ()
  "Install a package from the current buffer."
  (let ((pkg-desc (if (derived-mode-p 'tar-mode)
                      (package-tar-file-info)
                    (package-buffer-info))))
    ;; Install the package itself.
    (package-unpack pkg-desc)
    pkg-desc))

(defun elpa2nix-install-file (file)
  "Install a package from a file.
The file can either be a tar file or an Emacs Lisp file."
  (let ((is-tar (string-match "\\.tar\\'" file)))
    (with-temp-buffer
      (if is-tar
          (insert-file-contents-literally file)
        (insert-file-contents file))
      (when is-tar (tar-mode))
      (elpa2nix-install-from-buffer))))

;; Allow installing package tarfiles larger than 10MB
(setq large-file-warning-threshold nil)
