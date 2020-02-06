# The base package for automatic multiple-output splitting. Used in stdenv as well.
preConfigureHooks+=(_multioutConfig)
preFixupHooks+=(_multioutDocs)
preFixupHooks+=(_multioutDevs)
postFixupHooks+=(_multioutPropagateDev)

# Assign the first string containing nonempty variable to the variable named $1
_assignFirst() {
    local varName="$1"
    local REMOVE=REMOVE # slightly hacky - we allow REMOVE (i.e. not a variable name)
    shift
    while (( $# )); do
        if [ -n "${!1-}" ]; then eval "${varName}"="$1"; return; fi
        shift
    done
    echo "Error: _assignFirst found no valid variant!"
    return 1 # none found
}

# Same as _assignFirst, but only if "$1" = ""
_overrideFirst() {
    if [ -z "${!1-}" ]; then
        _assignFirst "$@"
    fi
}


# Setup chains of sane default values with easy overridability.
# The variables are global to be usable anywhere during the build.
# Typical usage in package is defining outputBin = "dev";

_overrideFirst outputDev "dev" "out"
_overrideFirst outputBin "bin" "out"

_overrideFirst outputInclude "$outputDev"

# so-libs are often among the main things to keep, and so go to $out
_overrideFirst outputLib "lib" "out"

_overrideFirst outputDoc "doc" "out"
_overrideFirst outputDevdoc "devdoc" REMOVE # documentation for developers
# man and info pages are small and often useful to distribute with binaries
_overrideFirst outputMan "man" "$outputBin"
_overrideFirst outputDevman "devman" "devdoc" "$outputMan"
_overrideFirst outputInfo "info" "$outputBin"


# Add standard flags to put files into the desired outputs.
_multioutConfig() {
    if [ "$outputs" = "out" ] || [ -z "${setOutputFlags-1}" ]; then return; fi;

    # try to detect share/doc/${shareDocName}
    # Note: sadly, $configureScript detection comes later in configurePhase,
    #   and reordering would cause more trouble than worth.
    if [ -z "$shareDocName" ]; then
        local confScript="$configureScript"
        if [ -z "$confScript" ] && [ -x ./configure ]; then
            confScript=./configure
        fi
        if [ -f "$confScript" ]; then
            local shareDocName="$(sed -n "s/^PACKAGE_TARNAME='\(.*\)'$/\1/p" < "$confScript")"
        fi
                                    # PACKAGE_TARNAME sometimes contains garbage.
        if [ -n "$shareDocName" ] || echo "$shareDocName" | grep -q '[^a-zA-Z0-9_-]'; then
            shareDocName="$(echo "$name" | sed 's/-[^a-zA-Z].*//')"
        fi
    fi

    configureFlags="\
        --bindir=${!outputBin}/bin --sbindir=${!outputBin}/sbin \
        --includedir=${!outputInclude}/include --oldincludedir=${!outputInclude}/include \
        --mandir=${!outputMan}/share/man --infodir=${!outputInfo}/share/info \
        --docdir=${!outputDoc}/share/doc/${shareDocName} \
        --libdir=${!outputLib}/lib --libexecdir=${!outputLib}/libexec \
        --localedir=${!outputLib}/share/locale \
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
# Beware: only globbing patterns are accepted, e.g.: * ? {foo,bar}
# A special target "REMOVE" is allowed: moveToOutput foo REMOVE
moveToOutput() {
    local patt="$1"
    local dstOut="$2"
    local output
    for output in $outputs; do
        if [ "${!output}" = "$dstOut" ]; then continue; fi
        local srcPath
        for srcPath in "${!output}"/$patt; do
            # apply to existing files/dirs, *including* broken symlinks
            if [ ! -e "$srcPath" ] && [ ! -L "$srcPath" ]; then continue; fi

            if [ "$dstOut" = REMOVE ]; then
                echo "Removing $srcPath"
                rm -r "$srcPath"
            else
                local dstPath="$dstOut${srcPath#${!output}}"
                echo "Moving $srcPath to $dstPath"

                if [ -d "$dstPath" ] && [ -d "$srcPath" ]
                then # attempt directory merge
                    # check the case of trying to move an empty directory
                    rmdir "$srcPath" --ignore-fail-on-non-empty
                    if [ -d "$srcPath" ]; then
                      mv -t "$dstPath" "$srcPath"/*
                      rmdir "$srcPath"
                    fi
                else # usual move
                    mkdir -p "$(readlink -m "$dstPath/..")"
                    mv "$srcPath" "$dstPath"
                fi
            fi

            # remove empty directories, printing iff at least one gets removed
            local srcParent="$(readlink -m "$srcPath/..")"
            if rmdir "$srcParent"; then
                echo "Removing empty $srcParent/ and (possibly) its parents"
                rmdir -p --ignore-fail-on-non-empty "$(readlink -m "$srcParent/..")" \
                    2> /dev/null || true # doesn't ignore failure for some reason
            fi
        done
    done
}

# Move documentation to the desired outputs.
_multioutDocs() {
    local REMOVE=REMOVE # slightly hacky - we expand ${!outputFoo}

    moveToOutput share/info "${!outputInfo}"
    moveToOutput share/doc "${!outputDoc}"
    moveToOutput share/gtk-doc "${!outputDevdoc}"
    moveToOutput share/devhelp/books "${!outputDevdoc}"

    # the default outputMan is in $bin
    moveToOutput share/man "${!outputMan}"
    moveToOutput share/man/man3 "${!outputDevman}"
}

# Move development-only stuff to the desired outputs.
_multioutDevs() {
    if [ "$outputs" = "out" ] || [ -z "${moveToDev-1}" ]; then return; fi;
    moveToOutput include "${!outputInclude}"
    # these files are sometimes provided even without using the corresponding tool
    moveToOutput lib/pkgconfig "${!outputDev}"
    moveToOutput share/pkgconfig "${!outputDev}"
    moveToOutput lib/cmake "${!outputDev}"
    moveToOutput share/aclocal "${!outputDev}"
    # don't move *.la, as libtool needs them in the directory of the library

    for f in "${!outputDev}"/{lib,share}/pkgconfig/*.pc; do
        echo "Patching '$f' includedir to output ${!outputInclude}"
        sed -i "/^includedir=/s,=\${prefix},=${!outputInclude}," "$f"
    done
}

# Make the "dev" propagate other outputs needed for development.
_multioutPropagateDev() {
    if [ "$outputs" = "out" ]; then return; fi;

    local outputFirst
    for outputFirst in $outputs; do
        break
    done
    local propagaterOutput="$outputDev"
    if [ -z "$propagaterOutput" ]; then
        propagaterOutput="$outputFirst"
    fi

    # Default value: propagate binaries, includes and libraries
    if [ -z "${propagatedBuildOutputs+1}" ]; then
        local po_dirty="$outputBin $outputInclude $outputLib"
        set +o pipefail
        propagatedBuildOutputs=`echo "$po_dirty" \
            | tr -s ' ' '\n' | grep -v -F "$propagaterOutput" \
            | sort -u | tr '\n' ' ' `
        set -o pipefail
    fi

    # The variable was explicitly set to empty or we resolved it so
    if [ -z "$propagatedBuildOutputs" ]; then
        return
    fi

    mkdir -p "${!propagaterOutput}"/nix-support
    for output in $propagatedBuildOutputs; do
        echo -n " ${!output}" >> "${!propagaterOutput}"/nix-support/propagated-build-inputs
    done
}
