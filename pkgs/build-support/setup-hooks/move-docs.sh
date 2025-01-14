# This setup hook moves $out/{man,doc,info} to $out/share.

preFixupHooks+=(_moveToShare)

_moveToShare() {
    if [ -n "$__structuredAttrs" ]; then
        if [ -z "${forceShare-}" ]; then
            forceShare=( man doc info )
        fi
    else
        forceShare=( ${forceShare:-man doc info} )
    fi

    if [[ -z "$out" ]]; then return; fi

    for d in "${forceShare[@]}"; do
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
