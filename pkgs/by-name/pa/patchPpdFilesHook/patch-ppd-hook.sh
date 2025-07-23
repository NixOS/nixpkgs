fixupOutputHooks+=(_patchPpdFileCommands4fixupOutputHooks)



# Install a hook for the `fixupPhase`:
# If the variable `ppdFileCommands` contains a list of
# executable names, the hook calls `patchPpdFileCommands`
# on each output's `/share/cups/model` and `/share/ppds`
# directories in order to replace calls to those executables.

_patchPpdFileCommands4fixupOutputHooks () {
    [[ -n $ppdFileCommands ]]  ||  return 0
    if [[ -d $prefix/share/cups/model ]]; then
        patchPpdFileCommands "$prefix/share/cups/model" $ppdFileCommands
    fi
    if [[ -d $prefix/share/ppds ]]; then
        patchPpdFileCommands "$prefix/share/ppds" $ppdFileCommands
    fi
}



# patchPpdFileCommands PPD-ROOT PROGNAME...
#
# Look for ppd files in the directory PPD-ROOT.
# Descend into subdirectories, even if they are symlinks.
# However, ignore ppd files that don't belong to the same
# prefix ($NIX_STORE/$package_name) as PPD-ROOT-DIR does,
# to avoid stepping into other package's directories.
# ppd files may be gzipped; if the are,
# uncompress them, later recompress them.
# Skip symlinks to ppd files.
# PPD-ROOT may also be a single ppd file.
#
# Look for the PROGNAME executable in outputs and `buildInputs`,
# then look for PROGNAME invocations in the ppd files,
# without path or with common paths like `/usr/bin/$PROGNAME`.
# Replace those invocations with an absolute path to the
# corresponding executable from the outputs or `buildInputs`.
# Executables are searched where CUPS would search them,
# i.e., in `/bin` and `/lib/cups/filter`.
#
# As soon as an executable's path is replaced as
# described above, the package containing the binary
# is added to the list of propagated build inputs.
# This ensures the executable's package is still
# recognized as runtime dependency of the ppd file
# even if the ppd file is compressed lateron.
#
# PROGNAME may not contain spaces or tabs.
# The function will also likely fail or produce
# broken results if PROGNAME contains characters that
# require shell or regex escaping (e.g. a backslash).

patchPpdFileCommands () {

    local bin binnew binold binoldgrep cupspath path ppdroot ppdrootprefix

    # we will store some temporary data here
    pushd "$(mktemp -d --tmpdir patch-ppd-file-commands.XXXX)"

    # remember the ppd root path
    [[ "$1" == $NIX_STORE/* ]]  # ensure it's a store directory
    ppdroot=$1
    shift  # now "$@" is the list of binaries
    ppdrootprefix=${ppdroot%"/${ppdroot#"$NIX_STORE"/*/}"}

    # create `cupspath` (where we should look for binaries),
    # with these priorities
    # * outputs of current build before buildInputs
    # * `/lib/cups/filter' before `/bin`
    # * add HOST_PATH at end, so we don't miss anything
    for path in $(getAllOutputNames); do
        addToSearchPath cupspath "${!path}/lib/cups/filter"
        addToSearchPath cupspath "${!path}/bin"
    done
    for path in ${pkgsHostTarget+"${pkgsHostTarget[@]}"}; do
        addToSearchPath cupspath "$path/lib/cups/filter"
        addToSearchPath cupspath "$path/bin"
    done
    while read -r -d : path; do
        addToSearchPath cupspath "$path"
    done  <<< "${HOST_PATH:+"${HOST_PATH}:"}"

    # create list of compressed ppd files
    # so we can recompress them later
    find -L "$ppdroot" -type f -iname '*.ppd.gz' '!' -xtype l -print0  > gzipped

    # decompress gzipped ppd files
    echo "patchPpdFileCommands: decompressing $(grep -cz '^' < gzipped) gzipped ppd file(s) in $ppdroot"
    xargs -0r -n 64 -P "$NIX_BUILD_CORES"  gunzip  < gzipped

    # create list of all ppd files to be checked
    find -L "$ppdroot" -type f -iname '*.ppd' '!' -xtype l -print0  > ppds

    for bin in "$@"; do

        # discover new path
        binnew=$(PATH=$cupspath '@which@/bin/which' "$bin")
        echo "patchPpdFileCommands: located binary $binnew"

        # for each binary, we look for the name itself, but
        # also for a couple of common paths that might be used
        for binold in {/usr,}/{lib/cups/filter,sbin,bin}/"$bin" "$bin"; do

            # escape regex characters in the old command string
            binoldgrep=$(sed 's,[]$.*[\^],\\&,g' <<< "$binold")
            # ...and surround old command with some regex
            # that singles out shell command invocations
            # to avoid replacing other strings that might contain the
            # command name by accident (like "perl" in "perl-script")
            binoldgrep='\(^\|[;&| '$'\t''"`(]\)'"$binoldgrep"'\($\|[);&| '$'\t''"`<>]\)'
            # this string is used to *quickly* filter out
            # unaffected files before the (slower) awk script runs;
            # note that a similar regex is build in the awk script;
            # if `binoldgrep` is changed, the awk script should also be checked

            # create list of likely affected files
            # (might yield exit status != 0 if there are no matches)
            xargs -0r  grep -lZ "$binoldgrep"  < ppds  > ppds-to-patch  ||  true

            echo "patchPpdFileCommands: $(grep -cz '^' < ppds-to-patch) ppd file(s) contain $binold"

            # actually patch affected ppd files with awk;
            # this takes some time but can be parallelized;
            # speed up with LC_ALL=C, https://stackoverflow.com/a/33850386
            LC_ALL=C xargs -0r -n 64 -P "$NIX_BUILD_CORES"  \
              awk -i inplace -v old="${binold//\\/\\\\}" -v new="${binnew//\\/\\\\}" -f "@awkscript@"  \
              < ppds-to-patch

        done

        # create list of affected files
        xargs -0r  grep -lZF "$binnew"  < ppds  > patched-ppds  ||  true

        echo "patchPpdFileCommands: $(grep -cz '^' < patched-ppds) ppd file(s) patched with $binnew"

        # if the new command is contained in a file,
        # remember the new path so we can add it to
        # the list of propagated dependencies later
        if [[ -s patched-ppds ]]; then
            printf '%s\0' "${binnew%"/${binnew#"${NIX_STORE}"/*/}"}"  >> dependencies
        fi

    done

    # recompress ppd files that have been decompressed before
    echo "patchPpdFileCommands: recompressing $(grep -cz '^' < gzipped) gzipped ppd file(s)"
    # we can't just hand over the paths of the uncompressed files
    # to gzip as it would add the lower-cased extension ".gz"
    # even for files where the original was named ".GZ"
    xargs -0r -n 1 -P "$NIX_BUILD_CORES"  \
      "$SHELL" -c 'gzip -9nS ".${0##*.}" "${0%.*}"'  \
      < gzipped

    # enlist dependencies for propagation;
    # this is needed in case ppd files are compressed later
    # (Nix won't find dependency paths in compressed files)
    if [[ -s dependencies ]]; then

        # weed out duplicates from the dependency list first
        sort -zu dependencies  > sorted-dependencies

        mkdir -p "$ppdrootprefix/nix-support"
        while IFS= read -r -d '' path; do
            printWords "$path" >> "$ppdrootprefix/nix-support/propagated-build-inputs"
            # stdenv writes it's own `propagated-build-inputs`,
            # based on the variable `propagatedBuildInputs`,
            # but only to one output (`outputDev`).
            # So we also add our dependencies to that variable.
            # If our file survives as written above, great!
            # If stdenv overwrits it,
            # our dependencies will still be added to the file.
            # The end result might contain too many
            # propagated dependencies for multi-output packages,
            # but never a broken package.
            appendToVar propagatedBuildInputs "$path"
        done  < sorted-dependencies
    fi

    popd

}
