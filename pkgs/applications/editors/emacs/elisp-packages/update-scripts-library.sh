#!/usr/bin/env bash

# This is a basic library that concentrates the main tasks of bulk updating.
# It is meant to be `source`d, so that it can be used in both
# batch and interactive environments.

# TODO: Bail out if any dependency is not found
# TODO: should we make this a nix-shell script?
# DEPENDENCIES=( "curl" "jq" "git" "nix" )

# Classic "where I am" block
# https://www.binaryphile.com/bash/2020/01/12/determining-the-location-of-your-script-in-bash.html
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

# Since Bash is meager on data structures, let's use a JSON file and jq!
# The format is straightforward:
# archive_name : { overlay_url, generated_file, nix_attribute }
JSON_ARCHIVE_TABLE="${SCRIPT_DIR}/elisp-archives-table.json"

function download_packagesets {
    # Silent early-return when no argument is passed
    if [[ "$#" == "0" ]]; then
        return 0
    fi

    declare -a ARCHIVE_LIST

    # collect the command line arguments, bailing out when any of them is not recognized
    while (( "$#" )); do
        ARCHIVE_NAME="$1"
        if [[ "$(jq "has(\"${ARCHIVE_NAME}\")" ${JSON_ARCHIVE_TABLE})" == "false" ]]; then
            echo "${FUNCNAME[0]}: unknown package archive: ${ARCHIVE_NAME}"
            return 1
        else
            ARCHIVE_LIST+=( "${ARCHIVE_NAME}" )
        fi
        shift
    done

    pushd "${SCRIPT_DIR}" > /dev/null
    for ARCHIVE_NAME in "${ARCHIVE_LIST[@]}"; do
        URL=$(jq --raw-output ".\"${ARCHIVE_NAME}\".overlay_url" "${JSON_ARCHIVE_TABLE}")
        echo "${FUNCNAME[0]}: ${ARCHIVE_NAME}..."
        curl --silent --remote-name "${URL}"
        echo "${FUNCNAME[0]}: ${ARCHIVE_NAME}: done!"
    done
    popd > /dev/null
}

function test_packagesets {
    # Silent early-return when no argument is passed
    if [[ "$#" == "0" ]]; then
        return 0
    fi

    declare -a ARCHIVE_LIST

    # collect the command line arguments, bailing out when any of them is not recognized
    while (( "$#" )); do
        ARCHIVE_NAME="$1"
        if [[ "$(jq "has(\"${ARCHIVE_NAME}\")" ${JSON_ARCHIVE_TABLE})" == "false" ]]; then
            echo "${FUNCNAME[0]}: unknown package archive: ${ARCHIVE_NAME}"
            return 1
        else
            ARCHIVE_LIST+=( "${ARCHIVE_NAME}" )
        fi
        shift
    done

    pushd "${SCRIPT_DIR}" > /dev/null
    for ARCHIVE_NAME in "${ARCHIVE_LIST[@]}"; do
        ATTRIBUTE=$(jq --raw-output ".\"${ARCHIVE_NAME}\".nix_attribute" "${JSON_ARCHIVE_TABLE}")
        echo "${FUNCNAME[0]}: ${ATTRIBUTE}..."
        NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ../../../../../ -A "${ATTRIBUTE}"
        echo "${FUNCNAME[0]}: ${ATTRIBUTE}: done!"
    done
    popd > /dev/null
}

function commit_packagesets {
    # Silent early-return when no argument is passed
    if [[ "$#" == "0" ]]; then
        return 0
    fi

    declare -a ARCHIVE_LIST

    while (( "$#" )); do
        ARCHIVE_NAME="$1"
        if [[ "$(jq "has(\"${ARCHIVE_NAME}\")" ${JSON_ARCHIVE_TABLE})" == "false" ]]; then
            echo "${FUNCNAME[0]}: unknown package archive: ${ARCHIVE_NAME}"
            return 1
        else
            ARCHIVE_LIST+=( "${ARCHIVE_NAME}" )
        fi
        shift
    done

    pushd "${SCRIPT_DIR}" > /dev/null
    for ARCHIVE_NAME in "${ARCHIVE_LIST[@]}"; do
        ATTRIBUTE=$(jq --raw-output ".\"${ARCHIVE_NAME}\".nix_attribute" "${JSON_ARCHIVE_TABLE}")
        FILE=$(jq --raw-output ".\"${ARCHIVE_NAME}\".generated_file" "${JSON_ARCHIVE_TABLE}")
        if [[ "$(git diff --exit-code "${FILE}" > /dev/null)" == "0" ]]; then
            echo "${FUNCNAME[0]}: ${FILE}..."
            git commit -m "${ATTRIBUTE}: updated at $(date --iso)" -- "${FILE}"
            echo "${FUNCNAME[0]}: ${FILE}: done!"
        else
            echo "${FUNCNAME[0]}: ${FILE} was not modified"
        fi
    done
    popd > /dev/null
}
