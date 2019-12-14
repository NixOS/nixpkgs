#!/bin/bash
# the shebang is here for shellcheck

# This setup hook will do the following to any installed desktop file:
# replace Exec=/any/path/to/foo by a shell script lauching
# * $out/bin/foo if it exists
# * foo (from $PATH) otherwise
# This transformation is only done if
# $out/bin/foo exists and is executable
# It can also pick foo in buildInputs.
# The goal is that:
# * no manual patching is needed for desktop file which hardcode /usr/bin/foo
# * if the store path containing foo still exists, then it is used
# * if the desktop file is copied (usually, done by the menu editor of desktop environments),
# foo is updated and then the original store path containing foo is garbage-collected,
# the desktop file still executes foo from $PATH.

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
                # skip cases which need unescaping, this also makes the setup hook idempotent
                \"* | *\\* | *\`* | *\$* )
                    echo "Quoted Exec= clause in $desktopFile, skipping";
                    continue;;
                *)
                    # we look in $out/bin and buildInputs
                    dirs="${!outputBin}/bin:$HOST_PATH";
                    success=;
                    IFS=:
                    for dir in $dirs; do
                        relative="$(basename "$execname")";
                        absolute="$dir/$relative";
                        if [[ -x $absolute ]]; then
                            # after bash quoting of this file
                            # /bin/sh -c "x='python'; if test -x '/nix/store/hash/bin/python'; then '/nix/store/hash/bin/python'; fi; exec \$x \"\$@\"" "python"
                            # after desktop file quoting
                            # /bin/sh -c 'x='python'; if test -x '/nix/store/hash/bin/python'; then '/nix/store/hash/bin/python'; fi; exec $x "$@"' 'python'
                            # shellcheck disable=2016
                            launcher="/bin/sh -c \"x='$relative'; if test -x '$absolute'; then x='$absolute'; fi;"' exec \$x \"\$@\"" "'"$relative"'"'
                            echo "Fixing Exec=$execname to Exec=$launcher in $desktopFile"
                            substituteInPlace "$desktopFile" --replace "$line" "${line/$execname/$launcher}"
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


