# shellcheck shell=bash
# This setup hook moves $out/{man,doc,info} to $out/share; moves
# $out/share/man to $man/share/man; and moves $out/share/doc to
# $man/share/doc.

preFixupHooks+=(_moveToShare)

_moveToShare() {
    forceShare=${forceShare:=man doc info}
    if [[ -z "$out" ]]; then return; fi

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
