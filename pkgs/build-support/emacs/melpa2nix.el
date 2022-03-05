(require 'package)
(package-initialize)

(require 'package-recipe)
(require 'package-build)

(setq package-build-working-dir (expand-file-name "working/"))
(setq package-build-archive-dir (expand-file-name "packages/"))
(setq package-build-recipes-dir (expand-file-name "recipes/"))

;; Allow installing package tarfiles larger than 10MB
(setq large-file-warning-threshold nil)

(defun melpa2nix-build-package ()
  (if (not noninteractive)
      (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,package ,version ,commit)
     ;; Monkey-patch package-build so it doesn't shell out to git/hg.
     (defun package-build--get-commit (&rest _)
       commit)
     (package-build--package (package-recipe-lookup package) version))))
