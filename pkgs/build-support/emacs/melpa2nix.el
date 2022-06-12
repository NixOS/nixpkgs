(require 'package)
(package-initialize)

(require 'package-recipe)
(require 'package-build)

(setq package-build-working-dir (expand-file-name "working/"))
(setq package-build-archive-dir (expand-file-name "packages/"))
(setq package-build-recipes-dir (expand-file-name "recipes/"))

;; Allow installing package tarfiles larger than 10MB
(setq large-file-warning-threshold nil)

(defun melpa2nix-build-package-1 (rcp version commit)
  (let ((source-dir (package-recipe--working-tree rcp)))
    (unwind-protect
        (let ((files (package-build-expand-files-spec rcp t)))
          (cond
           ((= (length files) 1)
            (package-build--build-single-file-package
             rcp version commit files source-dir))
           ((> (length files) 1)
            (package-build--build-multi-file-package
             rcp version commit files source-dir))
           (t (error "Unable to find files matching recipe patterns")))))))

(defun melpa2nix-build-package ()
  (if (not noninteractive)
      (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,package ,version ,commit)
     (melpa2nix-build-package-1 (package-recipe-lookup package) version commit))))
