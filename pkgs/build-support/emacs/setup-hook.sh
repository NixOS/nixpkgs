addEmacsVars () {
  if test -d $1/share/emacs/site-lisp; then
      export EMACSLOADPATH="$1/share/emacs/site-lisp:$EMACSLOADPATH"
  fi
}

envHooks+=(addEmacsVars)
