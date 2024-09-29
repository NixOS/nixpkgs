preConfigurePhases+=(gnulibBootstrapPhase)

gnulibBootstrapPhase() {
    runHook preGnulibBootstrap

    local -a flagsArray=()
    concatTo flagsArray gnulibBootstrapFlags

    # For Gnulib’s build-aux/git-version-gen.
    if [[ -z ${gnulibBootstrapDontWriteTarballVersion-} && -n ${version-} ]]; then
        printf %s "$version" >.tarball-version
    fi

    cp @gnulib@/build-aux/bootstrap .
    GNULIB_SRCDIR=@gnulib@ sh bootstrap \
        --bootstrap-sync --no-git --gen \
        "${flagsArray[@]}"

    runHook postGnulibBootstrap
}
