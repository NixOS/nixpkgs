addEmacsVars () {
    prependToSearchPath EMACSLOADPATH "$1/share/emacs/site-lisp"
}

envHooks+=(addEmacsVars)
