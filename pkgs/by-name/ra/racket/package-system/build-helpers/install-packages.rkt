#lang racket/base
(require
 racket/file
 racket/function
 racket/list
 racket/path
 racket/string
 pkg/lib
 setup/setup

 "./stdenv.rkt"
 )

(define to-list
  (lambda (x)
    (if (list? x)
        x
        (list x))))

(current-pkg-scope 'installation)

(let* ([pkg-dirs
        ((compose
          (curry map some-system-path->string)
          (curry filter directory-exists?)
          flatten
          (curry map (curry directory-list #:build? #t)))
         (common-subpath (get-dep-paths) "share/racket-packages-archive"))]
       [pkgs
        (for/fold ([acc '()])
                  ([pkg-dir (in-list pkg-dirs)])
          (let* ([checksum
                  (let ([checksum-file (build-path pkg-dir ".CHECKSUM")])
                    (and (file-exists? checksum-file)
                         (string-trim (file->string checksum-file))))]
                 [pkg (pkg-desc pkg-dir 'dir #f checksum #f)])
            (cons pkg acc)))]
       [install-result
        (with-pkg-lock
          (pkg-install
           pkgs
           #:dep-behavior 'force
           #:force? #t
           #:ignore-checksums? #t
           #:use-cache? #f
           ))])
  (when (not (eq? install-result 'skip))
    (let [(setup-result
           (setup
            #:collections (and install-result (map to-list install-result))
            #:make-user? #f
            #:fail-fast? #t
            ))]
      (when (and (not setup-result) (env-set? "nix_racket_pkgs_strict_setup"))
        (error 'install-packages.rkt "fail to setup installation")))))
