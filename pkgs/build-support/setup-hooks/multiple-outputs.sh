preConfigureHooks+=(_multioutConfig)

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

# Add standard flags to put files into the desired outputs.
_multioutConfig() {
    if [ -n "${setOutputFlags-1}" ]; then
        configureFlags="\
            --bindir=$outputBin/bin --sbindir=$outputBin/sbin --libexecdir=$outputBin/libexec \
            --includedir=$outputInclude/include --oldincludedir=$outputInclude/include \
            --mandir=$outputMan/share/man --infodir=$outputInfo/share/info --docdir=$outputDoc/share/doc \
            --libdir=$outputLib/lib \
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

