# shellcheck shell=bash

# Outputs line-separated "${dest}\t${source}"
_getDartEntryPoints() {
    if [ -n "$dartEntryPoints" ]; then
        @jq@ -r '(to_entries | map(.key + "\t" + .value) | join("\n"))' "$dartEntryPoints"
    else
        # The pubspec executables section follows the pattern:
        # <output-bin-name>: [source-file-name]
        # Where source-file-name defaults to output-bin-name if omited
        @yq@ -r '(.executables | to_entries | map("bin/" + .key + "\t" + "bin/" + (.value // .key) + ".dart") | join("\n"))' pubspec.yaml
    fi
}

dartBuildHook() {
    echo "Executing dartBuildHook"

    runHook preBuild

    while IFS=$'\t' read -ra target; do
        dest="${target[0]}"
        src="${target[1]}"
        eval "$dartCompileCommand" "$dartOutputType" \
            -o "$dest" "${dartCompileFlags[@]}" "$src" "${dartJitFlags[@]}"
    done < <(_getDartEntryPoints)

    runHook postBuild

    echo "Finished dartBuildHook"
}

if [ -z "${dontDartBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=dartBuildHook
fi
