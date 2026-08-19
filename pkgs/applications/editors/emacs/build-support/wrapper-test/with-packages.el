;;; with-packages.el --- Utils and ERT tests for withPackages  -*- lexical-binding: t; -*-

;;; Code:

(require 'ert)
(eval-when-compile (require 'cl-lib))
(require 'server)

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

(defun with-packages-unwrapped-site-start-is-loaded ()
  (fboundp 'nix--profile-paths))

(ert-deftest with-packages-unwrapped-site-start-is-loaded ()
  (should (with-packages-unwrapped-site-start-is-loaded)))

(ert-deftest with-packages-bin-dirs-of-requested-packages-are-added-to-exec-path ()
  (should (executable-find "cowsay")))

(ert-deftest with-packages-tree-sitter-dir-is-added-to-treesit-extra-load-path ()
  (skip-unless (treesit-available-p))
  (should (treesit-language-available-p 'nix)))

;;;; Utils for non-batch tests

(defmacro define-with-packages-non-batch-test-via-bound-and-true-p (test-name)
  (declare (indent 1) (debug (symbolp)))
  (cl-check-type test-name symbol)
  `(defun ,test-name ()
     (list (bound-and-true-p ,test-name))))

(defmacro define-with-packages-non-batch-tests-via-bound-and-true-p (&rest test-names)
  "See also `define-with-packages-non-batch-test-via-bound-and-true-p'."
  (declare (indent 0) (debug (&rest symbolp)))
  `(progn
     ,@(cl-loop
        for test-name in test-names
        collect `(define-with-packages-non-batch-test-via-bound-and-true-p ,test-name))))

(defvar with-packages-non-batch-emacs-socket nil
  "The server socket of a non-batch Emacs to run non-batch tests on.
Set this variable before running non-batch tests.

Emacs in batch mode has a special startup process.  To test things like the
loading of early-default.el and default.el files, we launch a non-batch Emacs,
run non-batch tests on it and collect test results from it.")

(defun with-packages--run-non-batch-test (test-name)
  "Run non-batch test named TEST-NAME, a symbol.
Return test result, a list of values.  Each is non-nil if the test passes."
  (cl-check-type test-name symbol)
  (cl-flet ((eval-in-non-batch-emacs (form)
              (server-eval-at with-packages-non-batch-emacs-socket form)))
    (and
     ;; Test test-name is defined in with-packages so we load it in the non-batch Emacs.
     (eval-in-non-batch-emacs '(require 'with-packages))
     ;; Run the non-batch test and return test result.
     (eval-in-non-batch-emacs `(,test-name)))))

(defmacro define-with-packages-non-batch-ert-test (test-name)
  "See `with-packages--run-non-batch-test' for how the test is run."
  (declare (indent 1) (debug (symbolp)))
  (cl-check-type test-name symbol)
  `(ert-deftest ,test-name ()
     (should (stringp with-packages-non-batch-emacs-socket))
     (should (file-readable-p with-packages-non-batch-emacs-socket))
     (let ((test-result (with-packages--run-non-batch-test (quote ,test-name))))
       (should (consp test-result))
       ;; Make it easier to find out which condition fails in non-batch tests.
       (should (equal test-result
                      (cl-loop for item in test-result
                               collect (if item item t)))))))

(defmacro define-with-packages-non-batch-ert-tests (&rest test-names)
  "See also `define-with-packages-non-batch-ert-test'."
  (declare (indent 0) (debug (&rest symbolp)))
  `(progn
     ,@(cl-loop for test-name in test-names
                collect `(define-with-packages-non-batch-ert-test ,test-name))))

;;;; Non-batch tests

(define-with-packages-non-batch-tests-via-bound-and-true-p
  with-packages-early-default-is-loaded
  with-packages-default-is-loaded
  with-packages-early-default-is-loaded-before-default)

(defun with-packages-unwrapped-site-start-is-loaded-quietly ()
  (list (with-packages-unwrapped-site-start-is-loaded)
        (not (save-excursion
               (with-current-buffer "*Messages*"
                 (goto-char (point-min))
                 (save-match-data
                   (re-search-forward (rx line-start
                                          "Loading"
                                          (zero-or-more not-newline)
                                          "site-start")
                                      nil
                                      t)))))))

(defun with-packages-no-jit-native-comp ()
  "Test no JIT native-comp is triggered during non-batch tests.
This is a regression test for URL `https://github.com/NixOS/nixpkgs/pull/538964'."
  ;; Give Emacs some time to generate JIT native-comp results.
  (sleep-for 2.5)
  (list (not (cl-loop for buffer being each buffer
                      thereis (string= (buffer-name buffer)
                                       "*Async-native-compile-log*")))
        (let ((eln-dir (car native-comp-eln-load-path)))
          (or (directory-empty-p eln-dir)
              (and (not (file-exists-p eln-dir))
                   (file-exists-p (file-name-parent-directory eln-dir)))))))

(define-with-packages-non-batch-ert-tests
  with-packages-early-default-is-loaded
  with-packages-default-is-loaded
  with-packages-early-default-is-loaded-before-default
  with-packages-unwrapped-site-start-is-loaded-quietly
  with-packages-no-jit-native-comp)

(provide 'with-packages)

;;; with-packages.el ends here
