# This setup hook moves $out/{man,doc,info} to $out/share; moves
# $out/share/man to $man/share/man; and moves $out/share/doc to
# $man/share/doc.

preFixupHooks+=(_moveDocs)

_moveToShare() {
    forceShare=${forceShare:=man doc info}
    if [ -z "$forceShare" -o -z "$out" ]; then return; fi

    for d in $forceShare; do
        if [ -d "$out/$d" ]; then
            if [ -d "$out/share/$d" ]; then
                echo "both $d/ and share/$d/ exist!"
            else
                echo "moving $out/$d to $out/share/$d"
                mkdir -p $out/share
                mv $out/$d $out/share/
            fi
        fi
    done
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

_moveDocs() {
    _moveToShare
    _moveToOutput share/man "$man"
    _moveToOutput share/info "$info"
    _moveToOutput share/doc "$doc"
    _moveToOutput share/gtk-doc "$doc"

    # Remove empty share directory.
    if [ -d "$out/share" ]; then
        rmdir $out/share 2> /dev/null || true
    fi
}
