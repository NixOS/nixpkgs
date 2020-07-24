thisroot () {
    # Workaround thisroot.sh dependency on man
    if [ -z "${MANPATH-}" ]; then
        MANPATH=:
    fi
    local oldOpts="-u"
    shopt -qo nounset || oldOpts="+u"
    set +u
    source @out@/bin/thisroot.sh
    set "$oldOpts"
}

postHooks+=(thisroot)
