{
  lib,
}:

{
  pname,
  version ? "0.1.0", # a dummy value
  src ? lib.path.append ./. "${pname}.el",
  doLint ? true,
}:

{
  melpaBuild,
  package-lint,
}:
melpaBuild {
  inherit pname version src;
  turnCompilationWarningToError = true;

  packageRequires = lib.optional doLint package-lint;

  doInstallCheck = doLint;
  preInstallCheck = ''
    lintEachFile() {
      find $out/share/emacs \
        -type f -name '*.el' \
        -not -name "*-pkg.el" -not -name "*-autoloads.el" \
        -print0 \
      | xargs --verbose -0 -I {} -n 1 -P "$NIX_BUILD_CORES" "$@"
    }

    lintEachFile \
      emacs --batch \
        --funcall=package-activate-all \
        --funcall=package-lint-batch-and-exit "{}"

    lintEachFile \
      emacs --batch \
        "{}" \
        --eval='(setopt checkdoc-arguments-in-order-flag t)' \
        --funcall=checkdoc-batch

    lintEachFile \
      emacs --batch \
        "{}" \
        --eval='
          (progn
            ;; load indentation settings, if any, see (info "(emacs) Lisp Indent")
            (eval-buffer)
            (indent-region (point-min) (point-max))
            (with-current-buffer
                (diff-no-select buffer-file-name (current-buffer) nil t)
              (goto-char (point-min))
              (condition-case nil
                  (let ((case-fold-search nil))
                    (search-forward "Diff finished (no differences)"))
                (search-failed
                 (princ (buffer-string))
                 (error "%s" "File indentation is wrong")))))'
  '';
}
