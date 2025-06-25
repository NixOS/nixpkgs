# shellcheck shell=bash

gclientUnpackHook() {
    echo "Executing gclientUnpackHook"

    runHook preUnpack

    if [ -z "${gclientDeps-}" ]; then
        echo "gclientDeps missing"
        exit 1
    fi

    for dep in $(@jq@ -c "to_entries[]" "$gclientDeps")
    do
        local name="$(echo "$dep" | @jq@ -r .key)"
        echo "copying $name..."
        local path="$(echo "$dep" | @jq@ -r .value.path)"
        mkdir -p $(dirname "$name")
        cp -r "$path/." "$name"
        chmod u+w -R "$name"
    done

    runHook postUnpack
}

if [ -z "${dontGclientUnpack-}" ] && [ -z "${unpackPhase-}" ]; then
  unpackPhase=(gclientUnpackHook)
fi
