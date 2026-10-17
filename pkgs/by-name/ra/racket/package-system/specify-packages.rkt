#lang racket/base
(require racket/function
         racket/hash
         racket/list
         racket/match
         racket/port
         racket/set
         racket/string
         racket/system
         json
         pkg/name
         net/url
         "./build-helpers/hash-shortcuts.rkt")
(provide specify-source
         format-license-string
         format-dependencies
         specify-package
         close-dependencies
         clean-dependencies
         clean-name
         correct-and-clean-rev
         specify-closure)

(define p:pkgs-all-url
  (make-parameter (string->url "https://pkgs.racket-lang.org/pkgs-all")))

(define hash-remove-false
  (curryr hash-filter-values identity))

(define opl
  (lambda (condition . xs)
    (if condition xs '())))

(define unsafe-find
  (lambda args
    (let ([p (apply assoc args)])
      (if p (cdr p) p))))

(define fetch
  (lambda (locator)
    (let*-values ([(the-url) (if (url? locator) locator (string->url locator))]
                  [(status _ body) (http-sendrecv/url the-url)])
      (unless (string=? "200" (cadr (string-split (bytes->string/utf-8 status))))
        (error 'fetch "fail to fetch content from URL ~s, status: ~s"
               locator status))
      (port->string body #:close? #t))))

(define invoke
  (lambda (command . args)
    (string-trim
     (with-output-to-string
       (thunk
        (let ([exit-code
               (apply system*/exit-code (find-executable-path command) args)])
          (or (= exit-code 0)
              (error 'invoke "process ~s exits with code ~s"
                     (cons command args) exit-code)))))
     "\n"
     #:left? #f)))

(define close
  (lambda (roots proc)
    (if (set-empty? roots) roots
        (let ([ext (apply set-union (set-map roots proc))])
          (if (subset? ext roots)
              roots
              (close (set-union ext roots) proc))))))

(define specify-source
  (lambda (source)
    (let-values ([(name type)
                  (package-source->name+type source #f #:link-dirs? #f)])
      (unless name
        (log-warning "~s: fail to infer name from source ~s"
                     'specify-source source))
      (case type
        [(file-url dir-url)
         (hash-remove-false
          (hash
           'name name
           'method "url"
           'args (hash
                  'url source
                  'sha256 (invoke "nix-prefetch-url" source))
           ))]
        [(file dir)
         ((compose specify-source
                   url->string
                   (curry combine-url/relative (p:pkgs-all-url)))
          source)]
        [(git git-url)
         (let* ([source-url
                 (string->url source)]
                [real-url-str
                 (string-append
                  (case (url-scheme source-url)
                    [("git") "git://"]
                    [("git+http" "http") "http://"]
                    [else "https://"])
                  (string-join
                   (cons (url-host source-url)
                         (map path/param-path (url-path source-url)))
                   "/"))]
                [rev
                 (url-fragment source-url)]
                [path
                 (unsafe-find 'path (url-query source-url))])
           (hash-remove-false
            (hash
             'name name
             'method "git"
             'path path
             'args (hash-filter-keys
                    (string->jsexpr
                     (apply invoke "nix-prefetch-git"
                            "--quiet"
                            "--url" real-url-str
                            (append (opl rev "--rev" rev)
                                    (opl path "--sparse-checkout" path))))
                    (curryr memq '(url rev hash)))
             )))]
        [(github)
         (match-let* ([source-url
                       (string->url source)]
                      [(list owner repo _ ...)
                       (map path/param-path (url-path source-url))]
                      [rev
                       (url-fragment source-url)]
                      [path
                       (unsafe-find 'path (url-query source-url))])
           (hash-remove-false
            (hash
             'name name
             'method "github"
             'path path
             'args (string->jsexpr
                    (apply invoke "nix-prefetch-github"
                           owner repo
                           (opl rev "--rev" rev)))
             )))]
        [(name)
         source]
        [(#f)
         (error 'specify-source "fail to infer type from source ~s" source)]
        [else
         (error 'specify-source "unsupported type ~s of source ~s" type source)]))))

(define format-license-string
  (lambda (license-string)
    (letrec ([license
              (with-input-from-string license-string read)]
             [parse
              (match-lambda
                [(? symbol? id)
                 (symbol->string id)]
                [(list (? symbol? id) 'WITH (? symbol? ex))
                 (format "~s WITH ~s" id ex)]
                [(list l0 'AND l1)
                 (flatten (list (parse l0) (parse l1)))]
                [(list l0 'OR _)
                 (parse l0)])])
      (parse license))))

(define format-dependencies
  (lambda (domain name)
    (filter
     identity
     (map
      (match-lambda
        [(? string? source)
         (package-source->name source)]
        [(list (? string? source) _ ... '#:platform platform _ ...)
         (log-warning "~s: dependency ~s of package ~s applies only for platform ~s, and is thus stripped from the list"
                      'convert-dependencies source name platform)
         #f]
        [(list (? string? source) _ ...)
         (package-source->name source)])
      (/. (/. domain name) 'dependencies '())))))

(define specify-package
  (lambda (domain names)
    (for/hash ([name (in-list names)])
      (values
       (string->symbol
        (if (regexp-match? #px"^\\d" name)
            (string-append "_" name)
            name))
       (let ([pkg (/. domain name)])
         (hash-remove-false
          (hash
           'name (/. pkg 'name #f)
           'version (/. pkg 'version #f)
           'source (specify-source (/. pkg 'source))
           'checksum (/. pkg 'checksum)
           'dependencies (let ([deps (format-dependencies domain name)])
                           (if (null? deps) #f deps))
           'description (/. pkg 'description #f)
           'license (let ([lcs (/. pkg 'license #f)])
                      (if lcs (format-license-string lcs) #f))
           )))))))

(define close-dependencies
  (lambda (domain names)
    (close names
           (compose
            (curry filter (curry /? domain))
            (curry format-dependencies domain)))))

(define clean-dependencies
  (lambda (spec exceptions)
    (if (/? spec 'dependencies)
        (let ([cleaned (remove* exceptions (/. spec 'dependencies))])
          (if (null? cleaned)
              (/_ spec 'dependencies)
              (/: spec 'dependencies cleaned)))
        spec)))

(define clean-name
  (lambda (spec)
    (if (and (/? spec 'name)
             (/? spec 'source 'name)
             (equal? (/. spec 'name) (/.* spec 'source 'name)))
        (/_ spec 'source 'name)
        spec)))

(define correct-and-clean-rev
  (lambda (spec)
    (if (and (member (/.* spec 'source 'method) '("git" "github"))
             (/? spec 'source 'args 'rev))
        (let ([real-checksum (/.* spec 'source 'args 'rev)])
          ((compose (lambda (ht) (/_ ht 'source 'args 'rev))
                    (lambda (ht) (/: ht 'checksum real-checksum)))
           spec))
        spec)))

(define specify-closure
  (lambda (universe
           roots
           [exception-roots '()]
           #:clean-deps? [clean-deps #f])
    (let* ([exceptions
            (close-dependencies universe exception-roots)]
           [domain
            (hash-filter-keys
             universe
             (curryr (negate member) exceptions))]
           [names
            (close-dependencies domain roots)]
           [clean
            (compose correct-and-clean-rev
                     clean-name
                     (if clean-deps
                         (curryr clean-dependencies exceptions)
                         identity))])
      (hash-map/copy
       (specify-package domain names)
       (lambda (k v) (values k (clean v)))))))

(module+ main
  (require racket/cmdline
           racket/file)

  (define release-template "https://download.racket-lang.org/releases/~a/catalog/pkgs-all")

  (define p:catalog-file (make-parameter #f))
  (define p:catalog-stdin? (make-parameter #f))
  (define p:output-file (make-parameter #f))
  (define p:exception-roots (make-parameter '("racket-lib" "base")))
  (define p:clean-deps? (make-parameter #f))

  (define roots
    (command-line
     #:program "packages specifier"
     #:once-any
     [("-f" "--catalog-file")
      f
      "Read the package catalog from a file instead of pkgs.racket-lang.org"
      (p:catalog-file f)
      (p:pkgs-all-url (path->url f))]
     [("-s" "--stdin")
      "Read the catalog from standard input"
      (p:catalog-stdin? #t)
      (p:pkgs-all-url (path->url (find-system-path 'run-file)))]
     [("-r" "--release")
      r
      "Use the catalog of a Racket release."
      (p:pkgs-all-url (string->url (format release-template r)))]
     [("-u" "--url")
      u
      "Read the catalog from a custom URL."
      (let ([u. (if (regexp-match? #rx"/$" u) u (string-append u "/"))])
        (p:pkgs-all-url (combine-url/relative (string->url u.) "pkgs-all")))]
     #:once-each
     [("-o" "--output-file")
      o
      "Write the specification to a file instead of standard output."
      (p:output-file o)]
     [("-x" "--exception-root")
      x
      ("Exclude the package together with its closure."
       "Multiple packages are separated with commas."
       "`base' and `racket-lib' are always excluded.")
      (p:exception-roots (set-union (remove-duplicates (string-split x ","))
                                    (p:exception-roots)))]
     [("-c" "--clean-deps")
      "Remove exceptions from the dependency list."
      (p:clean-deps? #t)]
     #:args
     rs rs))

  (define universe
    (cond
      [(p:catalog-file)
       (file->value (p:catalog-file))]
      [(p:catalog-stdin?)
       (read)]
      [else
       (with-input-from-string (fetch (p:pkgs-all-url)) read)]))

  (define manifest
    (let ([closure
           (specify-closure
            #:clean-deps? (p:clean-deps?)
            universe roots (p:exception-roots))])
      (string-append (jsexpr->string closure #:indent 2) "\n")))

  (if (p:output-file)
      (display-to-file manifest (p:output-file) #:exists 'replace)
      (display manifest))

  )
