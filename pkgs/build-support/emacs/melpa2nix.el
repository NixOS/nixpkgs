(require 'package)
(package-initialize)

(require 'package-build)

(setq package-build-working-dir (expand-file-name ".")
      package-build-archive-dir (expand-file-name "."))

(defun melpa2nix-install-package ()
  (if (not noninteractive)
      (error "`melpa2nix-install-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,archive ,elpa)
     (progn (setq package-user-dir elpa)
            (melpa2nix-install-file archive)))))

(defun melpa2nix-build-package ()
  (if (not noninteractive)
      (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,package ,version . ,files)
     (melpa2nix-package-build-archive package version files))))

(defun melpa2nix-build-package-from-recipe ()
  (if (not noninteractive)
      (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,recipe-file ,version)
     (let* ((recipe (package-build--read-from-file recipe-file))
            (rcp (cdr recipe))
            (package (car recipe))
            (files (package-build--config-file-list rcp)))
       (melpa2nix-package-build-archive package version files)))))

(defun melpa2nix-package-build-archive (name version files)
  "Build a package archive for package NAME."
  (package-build--message "\n;;; %s\n" name)
  (let* ((start-time (current-time))
         (archive-entry (package-build-package name
                                               version
                                               files
                                               package-build-working-dir
                                               package-build-archive-dir))
         (archive-file (package-build--archive-file-name archive-entry)))

    (progn
      (package-build--message "Built in %.3fs, finished at %s"
                            (time-to-seconds (time-since start-time))
                            (current-time-string))
      (princ (format "%s\n" archive-file)))))

(defun melpa2nix-install-from-buffer ()
  "Install a package from the current buffer."
  (let ((pkg-desc (if (derived-mode-p 'tar-mode)
                      (package-tar-file-info)
                    (package-buffer-info))))
    ;; Install the package itself.
    (package-unpack pkg-desc)
    pkg-desc))

(defun melpa2nix-install-file (file)
  "Install a package from a file.
The file can either be a tar file or an Emacs Lisp file."
  (with-temp-buffer
    (insert-file-contents-literally file)
    (when (string-match "\\.tar\\'" file) (tar-mode))
    (melpa2nix-install-from-buffer)))
