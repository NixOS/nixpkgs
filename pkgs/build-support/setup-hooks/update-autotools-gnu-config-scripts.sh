appendToVar preConfigurePhases updateAutotoolsGnuConfigScriptsPhase

updateAutotoolsGnuConfigScriptsPhase() {
    if [ -n "${dontUpdateAutotoolsGnuConfigScripts-}" ]; then return; fi

    for script in config.sub config.guess; do
        for f in $(find . -type f -name "$script"); do
            echo "Updating Autotools / GNU config script to a newer upstream version: $f"
            cp -f "@gnu_config@/$script" "$f"
        done
    done
}
