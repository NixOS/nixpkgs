addToEmacsLoadPath() {
  local lispDir="$1"
  if [[ -d $lispDir && ${EMACSLOADPATH-} != *"$lispDir":* ]] ; then
    # It turns out, that the trailing : is actually required
    # see https://www.gnu.org/software/emacs/manual/html_node/elisp/Library-Search.html
    export EMACSLOADPATH="$lispDir:${EMACSLOADPATH-}"
  fi
}

addToEmacsNativeLoadPath() {
  local nativeDir="$1"
  if [[ -d $nativeDir && ${EMACSNATIVELOADPATH-} != *"$nativeDir":* ]]; then
    export EMACSNATIVELOADPATH="$nativeDir:${EMACSNATIVELOADPATH-}"
  fi
}

addEmacsVars () {
  addToEmacsLoadPath "$1/share/emacs/site-lisp"

  if [ -n "${addEmacsNativeLoadPath:-}" ]; then
    addToEmacsNativeLoadPath "$1/share/emacs/native-lisp"
  fi
}
