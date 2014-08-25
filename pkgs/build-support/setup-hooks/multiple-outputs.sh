preConfigureHooks+=(_multioutConfig)
preFixupHooks+=(_multioutDocs)
postFixupHooks+=(_multioutPropagateDev)


# Assign the first nonempty string to variable named $1
_assignFirst() {
    local varName="$1"
    shift
    while [ $# -ge 0 ]; do
        if [ -n "$1" ]; then eval "${varName}"="$1"; return; fi
        shift
    done
    return 1 # none found
}

# Setup chains of sane default values with easy overridability.
# The variables are global to be usable anywhere during the build.
# ToDo: I was unable to get rid of the double-name redundancy (I hate bash eval ways)

_assignFirst outputDev "$outputDev" "$dev" "$out"
_assignFirst outputBin "$outputBin" "$bin" "$out"

_assignFirst outputInclude "$outputInclude" "$outputDev"

# so-libs are often among the main things to keep, and so go to $out
_assignFirst outputLib "$outputLib" "$lib" "$out"

_assignFirst outputDoc "$outputDoc" "$doc" "$out"
# man and info pages are small and often useful to distribute with binaries
_assignFirst outputMan "$outputMan" "$man" "$outputBin"
_assignFirst outputInfo "$outputInfo" "$info" "$outputMan"

# put propagated*BuildInputs into $outputDev instead of $out
propagateIntoOutput="$outputDev"

# Add standard flags to put files into the desired outputs.
_multioutConfig() {
    if [ -n "${setOutputFlags-1}" ]; then
        configureFlags="\
            --bindir=$outputBin/bin --sbindir=$outputBin/sbin \
            --includedir=$outputInclude/include --oldincludedir=$outputInclude/include \
            --mandir=$outputMan/share/man --infodir=$outputInfo/share/info --docdir=$outputDoc/share/doc \
            --libdir=$outputLib/lib --libexecdir=$outputLib/libexec \
            $configureFlags"

        installFlags="\
            pkgconfigdir=$outputDev/lib/pkgconfig \
            m4datadir=$outputDev/share/aclocal aclocaldir=$outputDev/share/aclocal \
            $installFlags"
    fi
}

# Add rpath prefixes to library paths, and avoid stdenv doing it for $out.
_addRpathPrefix "$outputLib"
NIX_NO_SELF_RPATH=1

# Move documentation into the desired outputs.
_multioutDocs() {
    _moveToOutput share/man "$outputMan"
    _moveToOutput share/info "$outputInfo"
    _moveToOutput share/doc "$outputDoc"

    # Remove empty share directory.
    if [ -d "$out/share" ]; then
        rmdir "$out/share" 2> /dev/null || true
    fi
}
_moveToOutput() {
    local d="$1"
    local dst="$2"
    if [ -z "$dst" -a ! -e $dst/$d ]; then return; fi
    local output
    for output in $outputs; do
        if [ "${!output}" = "$dst" ]; then continue; fi
        if [ -d "${!output}/$d" ]; then
            echo "moving ${!output}/$d to $dst/$d"
            mkdir -p $dst/share
            mv ${!output}/$d $dst/$d
            break
        fi
    done
}

_multioutPropagateDev() {
    if [ "$outputInclude" != "$propagateIntoOutput" ]; then
        mkdir -p "$propagateIntoOutput"/nix-support
        echo -n " $outputInclude" >> "$propagateIntoOutput"/nix-support/propagated-native-build-inputs
    fi
    if [ "$outputLib" != "$propagateIntoOutput" ]; then
        mkdir -p "$propagateIntoOutput"/nix-support
        echo -n " $outputLib" >> "$propagateIntoOutput"/nix-support/propagated-native-build-inputs
    fi
}

