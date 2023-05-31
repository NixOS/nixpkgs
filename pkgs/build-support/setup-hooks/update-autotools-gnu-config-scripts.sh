preConfigurePhases+=" updateAutotoolsGnuConfigScriptsPhase"

updateAutotoolsGnuConfigScriptsPhase() {
    if [ -n "${dontUpdateAutotoolsGnuConfigScripts-}" ]; then return; fi

    for script in config.sub config.guess; do
        for f in $(find . -type f -name "$script"); do
            echo "Updating Autotools / GNU config script to a newer upstream version: $f"
            cp "@gnu_config@/$script" "$f.new"
            if [ -e "$f" ]; then
                # Preserve timestamps to avoid unexpected regeneration
                # of the build system. For example `libtool` calls
                # `help2man` when `config.guess` updates.
                touch -r "$f" "$f.new"
            fi
            mv -f "$f.new" "$f"
        done
    done
}
