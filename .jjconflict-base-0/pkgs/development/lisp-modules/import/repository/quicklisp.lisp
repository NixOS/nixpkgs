(defpackage org.lispbuilds.nix/repository/quicklisp
  (:use :cl)
  (:import-from :dex)
  (:import-from :alexandria :read-file-into-string :ensure-list)
  (:import-from :arrow-macros :->>)
  (:import-from :str)
  (:import-from
   :org.lispbuilds.nix/database/sqlite
   :sqlite-database
   :init-db
   :database-url
   :init-file)
  (:import-from
   :org.lispbuilds.nix/api
   :import-lisp-packages)
  (:import-from
   :org.lispbuilds.nix/util
   :replace-regexes)
  (:export :quicklisp-repository)
  (:local-nicknames
   (:json :com.inuoe.jzon)))

(in-package org.lispbuilds.nix/repository/quicklisp)

(defclass quicklisp-repository ()
  ((dist-url :initarg :dist-url
             :reader dist-url
             :initform (error "dist url required"))))

(defun clear-line ()
  (write-char #\Return *error-output*)
  (write-char #\Escape *error-output*)
  (write-char #\[ *error-output*)
  (write-char #\K *error-output*))

(defun status (&rest format-args)
  (clear-line)
  (apply #'format (list* *error-output* format-args))
  (force-output *error-output*))

;; TODO: This should not know about the imported.nix file.
(defun init-tarball-hashes (database)
  (status "no packages.sqlite - will pre-fill tarball hashes from ~A to save time~%"
          (truename "imported.nix"))
  (let* ((lines (uiop:read-file-lines "imported.nix"))
         (lines (remove-if-not
                  (lambda (line)
                    (let ((trimmed (str:trim-left line)))
                      (or (str:starts-with-p "url = " trimmed)
                          (str:starts-with-p "sha256 = " trimmed))))
                  lines))
         (lines (mapcar
                 (lambda (line)
                   (multiple-value-bind (whole groups)
                       (ppcre:scan-to-strings "\"\(.*\)\"" line)
                     (declare (ignore whole))
                     (svref groups 0)))
                 lines)))
    (sqlite:with-open-database (db (database-url database))
      (init-db db (init-file database))
      (sqlite:with-transaction db
        (loop while lines do
          (sqlite:execute-non-query db
            "insert or ignore into sha256(url,hash) values (?,?)"
            (prog1 (first lines) (setf lines (rest lines)))
            (prog1 (first lines) (setf lines (rest lines))))))
      (status "OK, imported ~A hashes into DB.~%"
              (sqlite:execute-single db
                 "select count(*) from sha256")))))

(defparameter *broken-systems*
  '(
    ;; Infinite recursion through dependencies in 2024-10-12 dist
    "cl-quil" "qvm"
    )
  "List of broken systems, which should be omitted from the package graph")

(defmethod import-lisp-packages ((repository quicklisp-repository)
                                 (database sqlite-database))

  ;; If packages.sqlite is missing, we should populate the sha256
  ;; table to speed things up.
  (unless (probe-file (database-url database))
    (init-tarball-hashes database))

  (let* ((db (sqlite:connect (database-url database)))
         (systems-url (str:concat (dist-url repository) "systems.txt"))
         (releases-url (str:concat (dist-url repository) "releases.txt"))
         (systems-lines (rest (butlast (str:split #\Newline (dex:get systems-url)))))
         (releases-lines (rest (butlast (str:split #\Newline (dex:get releases-url))))))

    (flet ((sql-query (sql &rest params)
             (apply #'sqlite:execute-to-list (list* db sql params))))

      ;; Ensure database schema
      (init-db db (init-file database))

      ;; Prepare temporary tables for efficient access
      (sql-query "create temp table if not exists quicklisp_system
                  (project, asd, name unique, deps)")

      (sql-query "create temp table if not exists quicklisp_release
                  (project unique, url, size, md5, sha1, prefix not null, asds)")

      (sqlite:with-transaction db
        (dolist (line systems-lines)
          (destructuring-bind (project asd name &rest deps)
              (str:words line)
            (sql-query
             "insert or ignore into quicklisp_system values(?,?,?,?)"
             project asd name (json:stringify (coerce deps 'vector))))))

      (sqlite:with-transaction db
        (dolist (line releases-lines)
          (destructuring-bind (project url size md5 sha1 prefix &rest asds)
              (str:words line)
            (sql-query
             "insert or ignore into quicklisp_release values(?,?,?,?,?,?,?)"
             project url size md5 sha1 prefix (json:stringify (coerce
                                                               asds
                                                               'vector))))))

      ;; Weed out circular dependencies from the package graph.
      (sqlite:with-transaction db
        (sql-query "create temp table will_delete (root,name)")
        (loop for (system) in (sql-query "select name from quicklisp_system") do
          (when (sql-query
                  "with recursive dep(root, name) as (
                    select s.name, d.value
                    from quicklisp_system s
                    cross join json_each(s.deps) d
                    where s.name = ?
                    union
                    select dep.root, d.value
                    from quicklisp_system s, dep
                    cross join json_each(s.deps) d
                    where s.name = dep.name
                  ) select 1 from dep where name = root"
                 system)
            (sql-query
             "with recursive broken(name) as (
                select ?
                union
                select s.name from quicklisp_system s, broken b
                where b.name in (select value from json_each(s.deps))
              ) insert into will_delete select ?, name from broken"
             system system)))
        (loop for (root name) in (sql-query "select root, name from will_delete") do
          (warn "Circular dependency in '~a': Omitting '~a'" root name)
          (sql-query "delete from quicklisp_system where name = ?" name)))

      (sqlite:with-transaction db
        ;; Should these be temp tables, that then get queried by
        ;; system name? This looks like it uses a lot of memory.
        (let ((systems
                (sql-query
                 "with pkgs as (
                    select
                      name, asd, url, deps,
                      ltrim(replace(prefix, r.project, ''), '-_') as version
                    from quicklisp_system s, quicklisp_release r
                    where s.project = r.project
                  )
                  select
                    name, version, asd, url,
                    (select json_group_array(
                       json_array(value, (select version from pkgs where name=value))
                     )
                     from json_each(deps)
                     where value <> 'asdf') as deps
                  from pkgs"
                 )))

          ;; First pass: insert system and source tarball informaton.
          ;; Can't insert dependency information, because this works
          ;; on system ids in the database and they don't exist
          ;; yet. Could it be better to just base dependencies on
          ;; names? But then ACID is lost.
          (dolist (system systems)
            (destructuring-bind (name version asd url deps) system
              (declare (ignore deps))
              (status "importing system '~a-~a'" name version)
              (let ((hash (nix-prefetch-tarball url db)))
                (sql-query
                 "insert or ignore into system(name,version,asd) values (?,?,?)"
                 name version asd)
                (sql-query
                 "insert or ignore into sha256(url,hash) values (?,?)"
                 url hash)
                (sql-query
                 "insert or ignore into src values
                  ((select id from sha256 where url=?),
                   (select id from system where name=? and version=?))"
                 url name version))))

          ;; Second pass: connect the in-database systems with
          ;; dependency information
          (dolist (system systems)
            (destructuring-bind (name version asd url deps) system
              (declare (ignore asd url))
              (dolist (dep (coerce (json:parse deps) 'list))
                (destructuring-bind (dep-name dep-version) (coerce dep 'list)
                  (if (eql dep-version 'NULL)
                    (warn "Bad data in Quicklisp: ~a has no version" dep-name)
                  (sql-query
                    "insert or ignore into dep values
                     ((select id from system where name=? and version=?),
                      (select id from system where name=? and version=?))"
                    name version
                    dep-name dep-version))))))))))

  (write-char #\Newline *error-output*))

(defun shell-command-to-string (cmd)
  ;; Clearing the library path is needed to prevent a bug, where the
  ;; called subprocess uses a different glibc than the SBCL process
  ;; is. In that case, the call to execve attempts to load the
  ;; libraries used by SBCL from LD_LIBRARY_PATH using a different
  ;; glibc than they expect, which errors out.
  (let ((ld-library-path  (uiop:getenv "LD_LIBRARY_PATH")))
    (setf (uiop:getenv "LD_LIBRARY_PATH") "")
    (unwind-protect
         (uiop:run-program cmd :output '(:string :stripped t))
      (setf (uiop:getenv "LD_LIBRARY_PATH") ld-library-path))))

(defun nix-prefetch-tarball (url db)
  (restart-case
      (compute-sha256 url db)
    (try-again ()
      :report "Try downloading again"
      (nix-prefetch-tarball url db))))

(defun compute-sha256 (url db)
  (or (sqlite:execute-single db "select hash from sha256 where url=?" url)
      (let ((sha256 (shell-command-to-string (str:concat "nix-prefetch-url --unpack " url))))
        sha256)))
