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
  (oset rcp version version)
  (oset rcp commit commit)
  (oset rcp time 0)
  (let ((package-build-checkout-function #'ignore)
        (package-build-cleanup-function #'ignore))
    (package-build--package rcp)))

(defun melpa2nix-build-package ()
  (if (not noninteractive)
      (error "`melpa2nix-build-package' is to be used only with -batch"))
  (pcase command-line-args-left
    (`(,package ,version ,commit)
     (melpa2nix-build-package-1 (package-recipe-lookup package) version commit))))
