#lang racket/base
(require
 racket/list

 "./hash-shortcuts.rkt"
 )
(provide
 expand-config
 config-cascade
 )

(define search~main
  (hash
   'bin-search-dirs 'bin-dir
   'doc-search-dirs 'doc-dir
   'gui-bin-search-dirs 'gui-bin-dir
   'include-search-dirs 'include-dir
   'lib-search-dirs 'lib-dir
   'links-search-files 'links-file
   'man-search-dirs 'man-dir
   'pkgs-search-dirs 'pkgs-dir
   'share-search-dirs 'share-dir
   ))

(define main~search
  (hash-map/copy search~main
                 (lambda (k v) (values v k))))

(define expand-config
  (lambda (config)
    (for/fold ([acc config])
              ([key (in-hash-keys search~main)])
      (let ([val (/. config key '(#f))])
        (if (not (member #f val)) acc
            (/: acc
                key
                (let* ([main-key (/. search~main key)]
                       [main-val (/. config main-key)])
                  (if main-val
                      (map (lambda (p) (if p p main-val)) val)
                      (remove #f val)))))))))

(define config-cascade
  (let ([cascade-two
         #|
         | It is assumed that `prev-config` has been fully expanded before being
         | covered.
         |#
         (lambda (new-config prev-config)
           (for/fold ([acc prev-config])
                     ([(key val) (in-hash new-config)])
             (cond
               [(or (/? search~main key)
                    (memq key '(base-documentation-packages
                                catalogs
                                collects-search-dirs
                                compiled-file-roots
                                distribution-documentation-packages)))
                (/: acc key (append val (/. prev-config key '())))]
               #|
               | Append the default value (i.e. `(#f)`) if the search entry is
               | not set explicitly while its corresponding "main" entry is.
               |#
               [(and (/? main~search key)
                     (not (/? new-config (/. main~search key))))
                (let* ([search-key (/. main~search key)]
                       [search-val (append '(#f) (/. prev-config search-key '()))])
                  (/:& acc
                       key val
                       search-key search-val))]
               [else
                (/: acc key val)])))])
    (lambda (config0 . configs)
      (hash-map/copy
       (foldl cascade-two config0 configs)
       (lambda (k v)
         (values
          k
          (if (list? v) (remove-duplicates v) v)))))))
