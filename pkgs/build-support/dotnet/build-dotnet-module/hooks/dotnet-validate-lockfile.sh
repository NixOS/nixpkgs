# Validate a lockfile does not depend on any floating Nuget dependencies
# Note that all ranges other than floating resolve to the lowest available version by default
# See https://docs.microsoft.com/en-us/nuget/concepts/package-versioning#version-ranges for more information
dotnetValidateLockfileHook() {
    echo "Executing dotnetValidateLockfileHook"

    if [[ ! -f "${lockfilePath-}" ]]; then
        echo "Could not locate the lockfile! Consider setting \"dontDotnetValidateLockfile\""
        exit 1
    fi

    lockfileVersion="$(jq ".version" < "${lockfilePath}")"

    if (( "${lockfileVersion}" != 1 && "${lockfileVersion}" != 2 )); then
        echo "error: unsupported lockfile version: ${lockfileVersion}"
        exit 1
    fi

    # An array of most dependencies and their versions.
    depsWithVersions="$(jq -rc '
        # Direct dependencies. This only includes entries with requested version ranges
        [ .dependencies[] | with_entries(select(.value | has("requested"))) | to_entries[] | {
            "name": .key, # Name of dependency
            "version": .value.requested # Requested version range
        # Dependencies of dependencies. Includes all of them, as requested ranges are not marked
        }] + [ .dependencies[] | with_entries(select(.value | has("dependencies"))) | .[].dependencies | to_entries[] | {
            "name": .key, # Name of dependency
            "version": .value # Version, this can either be a range or an exact match
        }]
    ' < "${lockfilePath}")"

    depsLength="$(jq -rc 'length' <<< "${depsWithVersions}")"
    lockfileErrors=()

    i=0
    while (( "$i" < "${depsLength}" )); do
        depName="$(jq -rc --arg i "$i" '.[($i | tonumber)] | .name' <<< "${depsWithVersions}")"
        depVersion="$(jq -rc --arg i "$i" '.[($i | tonumber)] | .version' <<< "${depsWithVersions}")"

        # Check if the version range is floating
        if [[ "${depVersion}" = *"*"* ]]; then
            lockfileErrors+=("Package \"${depName}\" requested floating version range \"${depVersion}\"")
        fi

        i=$(( i + 1 ))
    done
    unset i

    if (( "${#lockfileErrors[@]}" > 0 )); then
        echo "Attempted to fetch unstable NuGet dependency version(s):"

        for error in "${lockfileErrors[@]}"; do
            echo "  ${error}"
        done

        echo "This project uses unstable version range(s) for its Nuget dependencies, which we cannot deterministically fetch."
        echo "Please set the \"nugetDeps\" attribute to a lockfile generated with the \"passthru.fetch-deps\" script to ensure all dependencies are locked."
        exit 1
    fi

    echo "succesfully validated lockfile"
    echo "Finished dotnetValidateLockfileHook"
}

if [[ -z "${dontDotnetValidateLockfile-}" && -z "${postConfigure-}" ]]; then
    postConfigure=dotnetValidateLockfileHook
fi
