# shellcheck shell=bash disable=SC2154

ctestCheckHook() {
    echo "Executing ctestCheckHook"

    runHook preCheck

    local buildCores=1

    if [ "${enableParallelChecking-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        "-j$buildCores"
        # This is enabled by the cmakeConfigurePhase by exporting
        # CTEST_OUTPUT_ON_FAILURE, but it makes sense it enable it globally here
        # as well.
        "--output-on-failure"
    )

    local disabledTestsArray=()
    concatTo disabledTestsArray disabledTests

    if [ ${#disabledTestsArray[@]} -ne 0 ]; then
        local ctestExcludedTestsFile=$NIX_BUILD_TOP/.ctest-excluded-tests
        disabledTestsString="$(concatStringsSep "\n" disabledTestsArray)"
        echo -e "$disabledTestsString" >"$ctestExcludedTestsFile"
        flagsArray+=("--exclude-from-file" "$ctestExcludedTestsFile")
    fi

    concatTo flagsArray ctestFlags checkFlags checkFlagsArray

    echoCmd 'ctest flags' "${flagsArray[@]}"
    ctest "${flagsArray[@]}"

    echo "Finished ctestCheckHook"

    runHook postCheck
}

if [ -z "${dontUseCTestCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=ctestCheckHook
fi
