preConfigureHooks+=(_multioutConfig)
preFixupHooks+=(_multioutDocs)
preFixupHooks+=(_multioutDevs)
postFixupHooks+=(_multioutPropagateDev)


# Assign the first string containing nonempty variable to the variable named $1
_assignFirst() {
    local varName="$1"
    shift
    while [ $# -ge 1 ]; do
        if [ -n "${!1}" ]; then eval "${varName}"="$1"; return; fi
        shift
    done
    return 1 # none found
}

# Setup chains of sane default values with easy overridability.
# The variables are global to be usable anywhere during the build.
# ToDo: I was unable to get rid of the double-name redundancy (I hate bash eval ways)

# ToDo: easy way of overriding from withing mkDerivation attrset

_assignFirst outputDev "$outputDev" "dev" "out"
_assignFirst outputBin "$outputBin" "bin" "out"

_assignFirst outputInclude "$outputInclude" "$outputDev"

# so-libs are often among the main things to keep, and so go to $out
_assignFirst outputLib "$outputLib" "lib" "out"

_assignFirst outputDoc "$outputDoc" "doc" "out"
# man and info pages are small and often useful to distribute with binaries
_assignFirst outputMan "$outputMan" "man" "doc" "$outputBin"
_assignFirst outputInfo "$outputInfo" "info" "doc" "$outputMan"

# Make stdenv put propagated*BuildInputs into $outputDev instead of $out
propagateIntoOutput="${!outputDev}"


# Add standard flags to put files into the desired outputs.
_multioutConfig() {
    if [ -z "${setOutputFlags-1}" ]; then return; fi;

    configureFlags="\
        --bindir=${!outputBin}/bin --sbindir=${!outputBin}/sbin \
        --includedir=${!outputInclude}/include --oldincludedir=${!outputInclude}/include \
        --mandir=${!outputMan}/share/man --infodir=${!outputInfo}/share/info \
        --docdir=${!outputDoc}/share/doc \
        --libdir=${!outputLib}/lib --libexecdir=${!outputLib}/libexec \
        $configureFlags"

    installFlags="\
        pkgconfigdir=${!outputDev}/lib/pkgconfig \
        m4datadir=${!outputDev}/share/aclocal aclocaldir=${!outputDev}/share/aclocal \
        $installFlags"
}

# Add rpath prefixes to library paths, and avoid stdenv doing it for $out.
_addRpathPrefix "${!outputLib}"
NIX_NO_SELF_RPATH=1


# Move subpaths that match pattern $1 from under any output/ to the $2 output/
_moveToOutput() {
    local patt="$1"
    local dstOut="$2"
    echo "XXX: m2o '$1' '$2'"
    local output
    for output in $outputs; do
        echo "XXX: output='$output'"
        if [ "${output}" = "$dstOut" ]; then continue; fi
        local srcPath
        for srcPath in ${!output}/$patt; do
            if [ ! -e "$srcPath" ]; then continue; fi
            local dstPath="$dstOut${srcPath#${!output}}"
            echo "moving $srcPath to $dstPath"

            if [ -d "$dstPath" ] && [ -d "$srcPath" ]
            then # attempt directory merge
                mv -t "$dstPath" "$srcPath"/*
                rmdir "$srcPath"
            else # usual move
                mkdir -p $(readlink -m "$dstPath/..") # create the parent for $dstPath
                mv "$srcPath" "$dstPath"
            fi
        done
    done
}

# Move documentation to the desired outputs.
_multioutDocs() {
    echo "Looking for documentation to move between outputs"
    _moveToOutput share/man "${!outputMan}"
    _moveToOutput share/info "${!outputInfo}"
    _moveToOutput share/doc "${!outputDoc}"

    # Remove empty share directory.
    if [ -d "$out/share" ]; then
        rmdir "$out/share" 2> /dev/null || true
    fi
}

# Move development-only stuff to the desired outputs.
_multioutDevs() {
    if [ -z "${moveToDev-1}" ]; then return; fi;
    echo "Looking for development-only stuff to move between outputs"
    _moveToOutput include "${!outputInclude}"
    _moveToOutput lib/pkgconfig "${!outputDev}"
    _moveToOutput "lib/*.la" "${!outputDev}"
}

# Make ${!outputDev} propagate other outputs needed for development
# Note: during the build, probably only the "native" development packages are useful.
# With current cross-building setup, all packages are "native" if not cross-building.
_multioutPropagateDev() {
    if [ "${!outputInclude}" != "$propagateIntoOutput" ]; then
        mkdir -p "$propagateIntoOutput"/nix-support
        echo -n " ${!outputInclude}" >> "$propagateIntoOutput"/nix-support/propagated-native-build-inputs
    fi
    if [ "${!outputLib}" != "$propagateIntoOutput" ]; then
        mkdir -p "$propagateIntoOutput"/nix-support
        echo -n " ${!outputLib}" >> "$propagateIntoOutput"/nix-support/propagated-native-build-inputs
    fi
}

