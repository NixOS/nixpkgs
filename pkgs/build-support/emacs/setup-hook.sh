addEmacsVars () {
  if test -d $1/share/emacs/site-lisp; then
      # it turns out, that the trailing : is actually required
      # see https://www.gnu.org/software/emacs/manual/html_node/elisp/Library-Search.html
      export EMACSLOADPATH="$1/share/emacs/site-lisp:${EMACSLOADPATH-}"
  fi
}

# If this is for a wrapper derivation, emacs and the dependencies are all
# run-time dependencies. If this is for precompiling packages into bytecode,
# emacs is a compile-time dependency of the package.
addEnvHooks "$hostOffset" addEmacsVars
addEnvHooks "$targetOffset" addEmacsVars
