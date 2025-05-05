#lang racket/base
(require
 racket/function
 racket/list
 racket/pretty
 racket/string
 setup/dirs
 )

(define config-file (build-path (find-config-dir) "config.rktd"))

(define lib-paths
  ((compose remove-duplicates
            (curry map (curryr string-trim "-L" #:right? #f))
            (curry filter (curryr string-prefix? "-L"))
            string-split)
   (getenv "NIX_LDFLAGS")))

(define config
  (let* ([prev-config (read-installation-configuration-table)]
         [prev-lib-search-dirs (hash-ref prev-config 'lib-search-dirs '(#f))]
         [lib-search-dirs (remove-duplicates (append lib-paths prev-lib-search-dirs))])
    (hash-set prev-config 'lib-search-dirs lib-search-dirs)))

(call-with-output-file config-file
  #:exists 'replace
  (curry pretty-write config))
