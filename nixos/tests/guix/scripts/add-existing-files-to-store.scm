;; A simple script that adds each file given from the command-line into the
;; store and checks them if it's the same.
(use-modules (guix)
             (srfi srfi-1)
             (ice-9 ftw)
             (rnrs io ports))

;; This is based from tests/derivations.scm from Guix source code.
(define* (directory-contents dir #:optional (slurp get-bytevector-all))
         "Return an alist representing the contents of DIR"
         (define prefix-len (string-length dir))
         (sort (file-system-fold (const #t)
                                 (lambda (path stat result)
                                   (alist-cons (string-drop path prefix-len)
                                               (call-with-input-file path slurp)
                                               result))
                                 (lambda (path stat result) result)
                                 (lambda (path stat result) result)
                                 (lambda (path stat result) result)
                                 (lambda (path stat errno result) result)
                                 '()
                                 dir)
               (lambda (e1 e2)
                 (string<? (car e1) (car e2)))))

(define* (check-if-same store drv path)
         "Check if the given path and its store item are the same"
         (let* ((filetype (stat:type (stat drv))))
           (case filetype
             ((regular)
              (and (valid-path? store drv)
                   (equal? (call-with-input-file path get-bytevector-all)
                           (call-with-input-file drv get-bytevector-all))))
             ((directory)
              (and (valid-path? store drv)
                   (equal? (directory-contents path)
                           (directory-contents drv))))
             (else #f))))

(define* (add-and-check-item-to-store store path)
         "Add PATH to STORE and check if the contents are the same"
         (let* ((store-item (add-to-store store
                                          (basename path)
                                          #t "sha256" path))
                (is-same (check-if-same store store-item path)))
           (if (not is-same)
             (exit 1))))

(with-store store
            (map (lambda (path)
                   (add-and-check-item-to-store store (readlink* path)))
                 (cdr (command-line))))
