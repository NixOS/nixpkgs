addToEmacsLoadPath() {
  local lispDir="$1"
  if [[ -d $lispDir && ${EMACSLOADPATH-} != *"$lispDir":* ]] ; then
    # It turns out, that the trailing : is actually required
    # see https://www.gnu.org/software/emacs/manual/html_node/elisp/Library-Search.html
    export EMACSLOADPATH="$lispDir:${EMACSLOADPATH-}"
  fi
}

addEmacsVars () {
  addToEmacsLoadPath "$1/share/emacs/site-lisp"

  # Add sub paths to the Emacs load path if it is a directory
  # containing .el files. This is necessary to build some packages,
  # e.g., using trivialBuild.
  for lispDir in \
      "$1/share/emacs/site-lisp/"* \
      "$1/share/emacs/site-lisp/elpa/"*; do
    if [[ -d $lispDir && "$(echo "$lispDir"/*.el)" ]] ; then
      addToEmacsLoadPath "$lispDir"
    fi
  done
}

if [[ ! -v emacsHookDone ]]; then
  emacsHookDone=1

  # If this is for a wrapper derivation, emacs and the dependencies are all
  # run-time dependencies. If this is for precompiling packages into bytecode,
  # emacs is a compile-time dependency of the package.
  addEnvHooks "$hostOffset" addEmacsVars
  addEnvHooks "$targetOffset" addEmacsVars
fi
