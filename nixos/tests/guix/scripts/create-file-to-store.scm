;; A script that creates a store item with the given text and prints the
;; resulting store item path.
(use-modules (guix))

(with-store store
            (display (add-text-to-store store "guix-basic-test-text"
                                        (string-join
                                          (cdr (command-line))))))
