(defmacro mk-subdirs-expr (path)
  `(setq load-path
         (delete-dups (append '(,path)
                              ',(let ((default-directory path))
                                  (normal-top-level-add-subdirs-to-load-path))
                              load-path))))
