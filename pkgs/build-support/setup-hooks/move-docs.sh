# This setup hook automatically moves $out/{man,doc,info} to
# $out/share.

preFixupHooks+=(_moveDocs)

_moveDocs() {
    forceShare=${forceShare:=man doc info}
    if [ -z "$forceShare" ]; then return; fi

    for d in $forceShare; do
        if [ -d "$prefix/$d" ]; then
            if [ -d "$prefix/share/$d" ]; then
                echo "both $d/ and share/$d/ exist!"
            else
                echo "moving $prefix/$d to $prefix/share/$d"
                mkdir -p $prefix/share
                if [ -w $prefix/share ]; then
                    mv $prefix/$d $prefix/share
                    ln -s share/$d $prefix
                fi
            fi
        fi
    done
}
