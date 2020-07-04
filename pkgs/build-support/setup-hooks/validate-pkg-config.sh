# This setup hook validates each pkgconfig file in each output.

fixupOutputHooks+=(_validatePkgConfig)

_validatePkgConfig() {
    for pc in $(find "$prefix" -name '*.pc'); do
        local bail=0

        # Do not fail immediately. It's nice to see all errors when
        # there are multiple pkgconfig files.
        if ! pkg-config --validate "$pc"; then
            bail=1
        fi
    done

    if [ $bail -eq 1 ]; then
        exit 1
    fi
}
