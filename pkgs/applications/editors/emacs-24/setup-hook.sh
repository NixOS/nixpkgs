addEmacsPackageElPath() {
    addToSearchPath EMACS_PACKAGE_EL_PACKAGES $1/share/emacs/elpa/
}

envHooks=(${envHooks[@]} addEmacsPackageElPath)
