;;; with-packages.el --- Utils and ERT tests for withPackages  -*- lexical-binding: t; -*-

;;; Code:

(require 'ert)

;; Try to make tests cause no side-effects.

;;;; Tests that can be run in a batch Emacs

(ert-deftest with-packages-requested-packages-are-available ()
  (should (require 'dash nil t))
  (should (require 'flx-ido nil t)))

(ert-deftest with-packages-deps-of-requested-packages-are-available ()
  "Test https://github.com/NixOS/nixpkgs/issues/388829."
  (should (require 'flx nil t))
  (should (require 'flx-ido nil t)))

(ert-deftest with-packages-info-manual-of-requested-packages-is-available ()
  "Test https://debbugs.gnu.org/cgi/bugreport.cgi?bug=81105."
  (unless package--activated
    (package-activate-all))
  ;; Also `require' info at compile time
  ;; to suppress the compile warning about unknown function `Info-find-file'.
  (eval-and-compile
    (require 'info))
  (should (Info-find-file "dash" t)))

(provide 'with-packages)

;;; with-packages.el ends here
