addEmacsVars () {
  if test -d $1/share/emacs/site-lisp; then
      export EMACSLOADPATH="$1/share/emacs/site-lisp:$EMACSLOADPATH"
  fi
}

# If this is for a wrapper derivation, emacs and the dependencies are all
# run-time dependencies. If this is for precompiling packages into bytecode,
# emacs is a compile-time dependency of the package.
addEnvHooks "$targetOffset" addEmacsVars
addEnvHooks "$targetOffset" addEmacsVars
