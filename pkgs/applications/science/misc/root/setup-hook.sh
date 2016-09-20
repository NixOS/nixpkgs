thisroot () {
    # Workaround thisroot.sh dependency on man
    if [ -z "${MANPATH}" ]; then
        MANPATH=:
    fi
    source @out@/bin/thisroot.sh
}

envHooks+=(thisroot)
