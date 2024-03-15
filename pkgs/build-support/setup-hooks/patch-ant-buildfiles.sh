# Sets the `modificationtime` attribute on the <jar> and <war> ant tasks
# This is done to make the final archives deterministic
patchAntBuildfile() {
    local buildfile="$1"
    # using `local-name()` ignores the `xmlns` attribute in a parent node
    @xmlstarlet@ ed --inplace \
        --var T '//*[local-name()="jar" or local-name()="war"]' \
        --update '$T/@modificationtime' -v '0' \
        --insert '$T[not(@modificationtime)]' -t attr -n 'modificationtime' -v '0' \
        "$buildfile"
}

patchAntBuildfilesHook() {
    find -name '*.xml' -type f -print0 |
        while IFS= read -r -d '' file; do
            file=$(realpath "$file")
            # check if the xml file has any <target> nodes inside a top-level <project> node
            # this is done to only patch ant buildfiles, not just any xml file
            # using `local-name()` ignores the `xmlns` attribute in the <project> node
            if @xmlstarlet@ sel -Q -t -c '/*[local-name()="project"]/*[local-name()="target"]' "$file"; then
                echo "patching ant buildfile $file"
                patchAntBuildfile "$file"
            fi
        done
}

if [ -z "${dontPatchAntBuildfiles-}" ]; then
    postPatchHooks+=(patchAntBuildfilesHook)
fi
