
usage() {
    echo "
$0 <path to unpacked binary distribution directory>

This program return the list of libraries and where to find them based on
your currently installed programs.
";
    exit 1
}

if test $# -ne 1; then
  usage
fi

binaryDist=$1

hasBinaries=false
for bin in $(find $binaryDist -executable -type f) :; do
    if test $bin = ":"; then
        $hasBinaries || \
            echo "No patchable found in this directory."
        break
    fi
    hasBinaries=true

    echo ""
    echo "$bin:"
    hasLibraries=false
    unset interpreter
    unset addRPath
    for lib in $(strings $bin | grep '^\(/\|\)lib.*\.so' | sort | uniq) :; do
        if test $lib = ":"; then
            $hasLibraries || \
                echo "  This program is a script or it is statically linked."
            break
        fi
        hasLibraries=true

        echo "  $lib:";

        libPath=$lib
        lib=$(basename $lib)

        #versionLessLib=$(echo $lib | sed 's,[.][.0-9]*$,,')

        libs="$(
            find /nix/store/*/lib* \( -type f -or -type l \) -name $lib |
            grep -v '\(bootstrap-tools\|system-path\|user-environment\|extra-utils\)'
        )"

        echo "$libs" |
        sed 's,^/nix/store/[a-z0-9]*-\([^/]*\)/.*/\([^/]*\)$,    \1 -> \2,' |
        sort |
        uniq;

        names=$(
            echo "$libs" |
            sed 's,^/nix/store/[a-z0-9]*-\([^/]*\)-[.0-9]*/.*$,\1,' |
            sort |
            uniq;
        )

        if test "$names" = "glibc"; then names="glibc"; fi
        if echo $names | grep -c "gcc" &> /dev/null; then names="stdenv.cc.cc"; fi

        if test $lib != $libPath; then
            interpreter="--interpreter \${$names}/lib/$lib"
        elif echo $addRPath | grep -c "$names" &> /dev/null; then
            :
        else
            addRPath=${addRPath+$addRPath:}"\${$names}/lib"
        fi
    done;
    $hasLibraries && \
        echo "
  Patchelf command:

    patchelf $interpreter \\
      ${addRPath+--set-rpath $addRPath \\
}      \$out/$bin

"
done;
