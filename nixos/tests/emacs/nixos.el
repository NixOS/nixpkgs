;;; nixos.el --- Emacs tests related to Nix or NixOS  -*- lexical-binding: t; -*-

;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))
;; URL: https://example.com

;;; Commentary:

;; Emacs tests related to Nix or NixOS.

;;; Code:

(require 'ert)
(eval-when-compile (require 'cl-lib))
(require 'woman)
(require 'info)

;;;; Utils

(defun nixos--locate-eln-file (library)
  "Locate the natively-compiled LIBRARY file."
  (declare-function comp-el-to-eln-rel-filename "comp.c")
  (locate-eln-file (comp-el-to-eln-rel-filename (find-library-name library))))

(defun nixos--ancestor-dir-of-file-p (dir file)
  "Return t if DIR is an ancestor of FILE."
  (locate-dominating-file file
                          (lambda (current-dir)
                            (string= current-dir (file-name-as-directory dir)))))

(defun nixos--in-nix-profiles-p (file)
  "Return t if FILE is in nix profiles."
  (declare-function nix--profile-paths "site-start")
  (cl-loop for profile-dir in (nix--profile-paths)
           thereis (nixos--ancestor-dir-of-file-p profile-dir file)))

;;;; Tests

(ert-deftest nixos-packages-in-nix-profiles-are-available ()
  (ert-info ("nix system profile")
    (should (package-installed-p 'orderless)))
  (ert-info ("nix user profile")
    (should (package-installed-p 'dash))))

(ert-deftest nixos-aot-native-comp-eln-files-of-packages-in-nix-profiles-are-available ()
  (skip-unless (native-comp-available-p))
  (ert-info ("nix system profile")
    (should (nixos--in-nix-profiles-p (nixos--locate-eln-file "orderless"))))
  (ert-info ("nix user profile")
    (should (nixos--in-nix-profiles-p (nixos--locate-eln-file "dash")))))

(ert-deftest nixos-woman-can-find-manuals-in-nix-profiles ()
  (ert-info ("nix system profile")
    (should (woman-file-name "cmatrix")))
  (ert-info ("nix user profile")
    (should (woman-file-name "hello"))))

(ert-deftest nixos-info-manuals-of-packages-in-nix-profiles-are-available ()
  "Test https://debbugs.gnu.org/cgi/bugreport.cgi?bug=81105."
  (unless package--activated
    (package-activate-all))
  (ert-info ("nix system profile")
    (should (Info-find-file "orderless" t)))
  (ert-info ("nix user profile")
    (should (Info-find-file "dash" t))))

(ert-deftest nixos-tramp-knows-nix-specific-path ()
  ;; Security wrappers are added to two PATH dirs:
  ;;   /run/wrappers/bin/ and /run/current-system/sw/bin.
  ;; So, in addition to testing if the security wrapper can be found,
  ;; we also test if the found security wrapper is the right one.
  (cl-loop
   for (program program-dir) in '(("sl")
                                  ("sudo" "/run/wrappers/bin"))
   do
   (ert-info ((format "program %s is found remotely" program))
     (let ((found-program (let ((default-directory "/ssh:remote:"))
                            (executable-find program t))))
       (should found-program)
       (when program-dir
         (should (equal found-program
                        (expand-file-name program program-dir))))))))

(provide 'nixos)

;;; nixos.el ends here

;; Local Variables:
;; checkdoc-force-docstrings-flag: nil
;; End:
