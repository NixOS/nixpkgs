(require 'package-recipe)
(require 'package-build)

(setq package-build-working-dir (expand-file-name "working/"))
(setq package-build-archive-dir (expand-file-name "packages/"))
(setq package-build-recipes-dir (expand-file-name "recipes/"))

;; Allow installing package tarfiles larger than 10MB
(setq large-file-warning-threshold nil)

(defun melpa2nix-build-package-1 (rcp)
  (let* ((default-directory (package-recipe--working-tree rcp)))
    (unwind-protect
        (let ((files (package-build-expand-files-spec rcp t)))
          (unless files
            (error "Unable to find files matching recipe patterns"))
          (if (> (length files) 1)
              (package-build--build-multi-file-package rcp files)
            (package-build--build-single-file-package rcp files))))))

(defun melpa2nix-build-package ()
  (unless noninteractive
    (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,package ,version ,commit)
     (let ((recipe (package-recipe-lookup package)))
       (setf (oref recipe commit) commit)
       (setf (oref recipe version) version)
       (melpa2nix-build-package-1 recipe)))))
