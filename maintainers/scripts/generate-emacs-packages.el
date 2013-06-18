(require 'package)
(require 'cl-lib)

(defconst nix-emacs-included-packages '(emacs cl erc)
  "Packages which are included in Emacs and shouldn't be listed
  in the deps argument.")

(defconst nix-emacs-disabled-packages '(emms-mark-ext ;emms is not packaged
                                        ))

(defun nix-make-package-url (base-url name package-spec)
  (concat base-url
          (symbol-name name) "-" (package-version-join (package-desc-vers package-spec))
          (cl-case (package-desc-kind package-spec) (tar ".tar")  (single ".el"))))

(defun nix-normalize-package-name (package-name)
  (intern (replace-regexp-in-string "+" "-plus" (symbol-name package-name))))

(defun nix-make-deps-string (deps)
  (concat "[ " (if deps (cl-reduce (lambda (a b)
                                     (concat a " " b))
                                   (mapcar (lambda (d)
                                             (unless (memq (car d) nix-emacs-included-packages)
                                               (symbol-name
                                                (nix-normalize-package-name
                                                 (car d)))))
                                           deps))
                 "")
          " ]"))

(defun nix-prefetch-packages (base-url filenames)
  (let ((tmpdir "/tmp/nix-emacs-packages/"))
    (ignore-errors (mkdir tmpdir))
    (list tmpdir
          (mapcar (lambda (filename)
                    (let ((out (concat tmpdir filename)))
                      (if (file-regular-p out)
                          out
                        (when (url-copy-file (concat base-url "/" filename) out)
                          (message "Prefetching package %s" filename)
                          filename))))
                  filenames))))

(nix-prefetch-packages "http://orgmode.org/elpa/" '("nhexl-mode-0.1.el"))

(defun nix-get-sha256 (url)
  (message "Getting sha256 of %s" url)
  (let* ((output (shell-command-to-string (concat "nix-prefetch-url " url)))
         (sha256 (car (last (butlast (split-string output "\n"))))))
    ;; Make sure `sha256' is 52 chars long. If it's not, treat as
    ;; error and return nil.
    (when (= (length sha256) 52)
      sha256)))

;; (nix-generate-package-expression 'ob-sml
;;                                  '[(0 2)
;;                                    ((sml-mode
;;                                      (6 4)))
;;                                    "org-babel functions for template evaluation" single]
;;                                  "http://elpa.gnu.org/packages/")

(defun nix-generate-package-expression (name package-spec base-url)
  (let* ((url (nix-make-package-url base-url name package-spec))
         (sha256 (nix-get-sha256 (nix-make-package-url "file:///tmp/nix-emacs-packages/" name package-spec))))
    (format
     "
  # %s
  %s = buildEmacsPackage {
    name = \"%s-%s\";
    src = fetchurl {
      url = \"%s\";
      sha256 = \"%s\";
    };
  
    deps = %s;
  };
"

     (package-desc-doc package-spec)
     (symbol-name (nix-normalize-package-name name))
     (symbol-name (nix-normalize-package-name name))
     (package-version-join (package-desc-vers package-spec))
     url
     sha256
     (nix-make-deps-string (package-desc-reqs package-spec)))))

;; (nix-get-sha256 "http://marmalade-repo.org/packages/php-extras-0.4.4.20130612.tar")
;; (nix-get-sha256 "http://marmalade-repo.org/packages/php-extras-0.4.4.20130612.tarbdd")

(defun nix-remove-duplicate-packages (package-list)
  "Removes duplicate and older packages."
  (let (lst)
    (cl-dolist (p package-list)
      (when (and (not (cl-find-if (lambda (x) (eq (car x) (car p))) lst))
                 (not (cl-find-if (lambda (x) (eq x (car p))) nix-emacs-disabled-packages))
                 (cl-every (lambda (op) (if (eq (car op) (car p))
                                            (version-list-<= (aref (cdr op) 0) (aref (cdr p) 0))
                                          t))
                           package-list))
        (setq lst (cons p lst))))
    lst))

;; (nix-remove-duplicate-packages '((ack .
;;                                       [(1 2)
;;                                        nil "Interface to ack-like source code search tools" tar])
;;                                  (ack . [(1 4)
;;                                          nil "Interface to ack-like source code search tools" tar])))

(defun nix-generate-emacs-packages (&optional write-files)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ;; ("org" . "http://orgmode.org/elpa/")
                           ))

  (let ((out-buffer (get-buffer-create "generated-emacs-packages.nix")))
    (with-current-buffer out-buffer
      (insert "{ buildEmacsPackage, fetchurl }:\nrec {")
      ;; Add all packages to a list
      (let ((packages
             (nix-remove-duplicate-packages
              (apply 'append
                     (mapcar (lambda (archive)
                               (package--with-work-buffer
                                (cdr archive) "archive-contents"
                                (mapcar (lambda (p) (cons (car p) (vconcat (cdr p) (list (cdr archive)))))
                                        (cdr (read (current-buffer))))))
                             package-archives)))))

        (cl-dolist (p packages)
          (nix-prefetch-packages (aref (cdr p) 4)
                                 (list (nix-make-package-url "" (car p) (cdr p)))))
        (cl-dolist (p packages)
          (with-current-buffer out-buffer
            (insert (nix-generate-package-expression
                     (car p) (cdr p)
                     (aref (cdr p) 4)))))
        (insert "}")
        (let ((coding-system-for-write 'utf-8-emacs))
         (write-file "../../pkgs/top-level/emacs-packages-generated.nix"))))))
