#!/bin/bash
# the shebang is here for shellcheck

# This setup hook will do the following to any installed desktop file:
# replace Exec=/any/path/to/foo by Exec=$out/bin/foo if
# $out/bin/foo exists and is executable
# It can also pick foo in buildInputs.

fixupOutputHooks+=('autoPatchDesktopFileExec;')

autoPatchDesktopFileExec () {
    # shellcheck disable=2154
    dir="${!outputBin}/share/applications";
    if [[ -d $dir ]]; then
        patchDesktopFileExecIn "$dir";
    fi;
}

patchDesktopFileExecIn () {
    echo "fixing Exec= paths in desktop files of $1";
    for desktopFile in "$1"/**.desktop; do
        lines="$(grep -E '^\s*Exec' "$desktopFile")"
        IFS=$'\n';
        for line in $lines; do
            execname="$(<<<"$line" cut -d= -f2 | sed -r 's@\s*(\S*).*@\1@')";
            case "$execname" in
                # skip cases which need unescaping
                \"*)
                    echo "Quoted Exec= clause in $desktopFile, skipping";
                    continue;;
                *\\*)
                    echo "Quoted Exec= clause in $desktopFile, skipping";
                    continue;;
                *)
                    # we look in $out/bin and buildInputs
                    dirs="${!outputBin}/bin:$HOST_PATH";
                    success=;
                    IFS=:
                    for dir in $dirs; do
                        absolute="$dir/$(basename "$execname")";
                        if [[ -x $absolute ]]; then
                            echo "Fixing Exec=$execname to Exec=$absolute in $desktopFile"
                            substituteInPlace "$desktopFile" --replace "$line" "${line/$execname/$absolute}"
                            success=1;
                            break;
                        fi;
                    done
                    if [[ -z $success ]]; then
                        echo "Error: $desktopFile has Exec=$execname which is not found in $dirs or is not executable.";
                        exit 1;
                    fi;;
            esac
        done
    done
}


