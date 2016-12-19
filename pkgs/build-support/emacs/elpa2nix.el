(require 'package)
(package-initialize)

(defun elpa2nix-install-package ()
  (if (not noninteractive)
      (error "`elpa2nix-install-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,archive ,elpa)
     (progn (setq package-user-dir elpa)
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
