# This Bash library contains components to construct a nix-prefetcher of
# Visual Studio Code extensions in the form of VSIX files
# in a modular (Makefile-like) way.
#
# When writing a prefetcher for an extension registry,
# Use this derivation as build inputs, source this file by name,
# and override some functions if need be.
#
# A function in the form `prepare_foo`
# guarentees that the shell variable FOO are assigned with the value needed.
# Call it (in the main shell, not in the sub-shells) before accessing FOO.
# This way, each function can be overrided seperately,
# and only nessesary steps will be executed.
#
# A file path is calculated by `prepare_foo_path_expected`
# and realized by `perpare_foo_path`.
# For example, calling prepare_vsix_path will realize the .vsix file,
# and prepare_package_json_path the package.json file.
#
# Part of the code is adapted from get_vsixpkg() of the original update_install_exts.sh

###PLACEHOLDER_PATH_PREFIXING###

# Helper to just fail with a message and non-zero exit code.
function fail {
    echo "$1" >&2
    exit 1
}

# Define a new function named NEW_NAME
# with the definition of function named OLD_NAME.
# This provides access to the original function
# while overriding.
# See https://mharrison.org/post/bashfunctionoverride/
function save_function {
    local OLD_NAME NEW_NAME FUNCTION_COMMAND
    OLD_NAME="$1"
    NEW_NAME="$2"
    FUNCTION_COMMAND=$(declare -f "$OLD_NAME")
    eval "$NEW_NAME${FUNCTION_COMMAND#"$OLD_NAME"}"
}

# escape doublequotes ("\""), used to output conformed json strings.
function escape_doublequotes {
    local RESULT;
    RESULT="${1//\\/\\\\}"
    echo "${RESULT//\"/\\\"/}"
}

# `shift` command for `QUEUED_ARGS`
# shellcheck disable=SC2120
function shift_args {
    local -i N_SHIFT="${1-1}"
    QUEUED_ARGS=( "${QUEUED_ARGS[@]:$N_SHIFT}" )
}

# Split shorthands and re-add them into QUEUED_ARGS
# -abc -d -> -a -b -c -d
function manage_shorthands {
    local STR_RAW="${QUEUED_ARGS[0]:1}"
    shift_args
    local -a SUB_ARGS=()
    local -i i=0;
    # Parameterized expansions of for loop
    # doesn't work with 'set -u' (throw unbound variable error)
    # {1..2} doesn't work with variables as the upper bound
    # So use 'seq' from 'coreutils'
    for i in $(seq 0 $((${#STR_RAW} - 1))); do
        SUB_ARGS+=( "-${STR_RAW:$i:1}" )
    done
    QUEUED_ARGS=( "${SUB_ARGS[@]}" "${QUEUED_ARGS[@]}" )
}

# Quietly but delicately curl down the file, blowing up at the first sign of trouble.
function download_file {
    local FILE_PATH="$1"
    local URL="$2"
    curl --silent --show-error --fail -L -o "$FILE_PATH" "$URL"
    if [[ ! -e "$FILE_PATH" ]]; then
        fail "download_file: $FILE_PATH download failed."
    fi
}

# Create a tempdir for the extension download.
function create_exttmp {
    EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)
}

function prepare_exttmp {
    if [[ -z "${EXTTMP-}" ]]; then
        fail "create_exttmp must be run first for security reasons"
    fi
}

# The publisher part of the extension identifier
function prepare_vsix_publisher {
    if [[ -z "${VSIX_PUBLISHER-}" ]]; then
        fail "VSIX_PUBLISHER: Variable empty or unavailable."
    fi
}

# The name part of the extension identifier
function prepare_vsix_name {
    if [[ -z "${VSIX_NAME-}" ]]; then
        fail "VSIX_NAME: Variable empty or unavailable."
    fi
}

# The specified version, often default to latest (registry-dependent)
function prepare_vsix_version_specified {
    if [[ -z "${VSIX_VERSION_SPECIFIED-}" ]]; then
        fail "VSIX_VERSION_SPECIFIED: Variable empty or unavailable."
    fi
}

# The extension identifier
function prepare_vsix_fullname {
    prepare_vsix_publisher
    prepare_vsix_name
    VSIX_FULLNAME="$VSIX_PUBLISHER.$VSIX_NAME"
}

# URL to download the .vsix file
function prepare_vsix_url {
    fail "prepare_vsix_url: Bash function not implemented."
}

# Expected path of the .vsix file
function prepare_vsix_path_expected {
    prepare_exttmp
    prepare_vsix_fullname
    VSIX_PATH_EXPECTED="$EXTTMP/$VSIX_FULLNAME.zip"
}

function download_vsix {
    prepare_vsix_path_expected
    prepare_vsix_url
    download_file "$VSIX_PATH_EXPECTED" "$VSIX_URL"
    VSIX_PATH="$VSIX_PATH_EXPECTED"
}

# Realized path of the .vsix file
function prepare_vsix_path {
    if [[ -z "${VSIX_PATH-}" ]]; then
        download_vsix
    fi
}

# Add the downloadded .vsix file to the Nix store
function add_vsix_to_store {
    prepare_vsix_path
    nix-store --add-fixed sha256 "$VSIX_PATH" >/dev/null
}

function prepare_hash_format {
    if [[ -z "${HASH_FORMAT-}" ]]; then
        HASH_FORMAT="sri"
    fi
}

function prepare_hash_algo {
    if [[ -z "${HASH_ALGO-}" ]]; then
        HASH_ALGO="sha256"
    fi
}

# Calculate the hash
function prepare_vsix_hash {
    if [[ -z "${VSIX_HASH-}" ]]; then
        prepare_vsix_path
        prepare_hash_format
        prepare_hash_algo
        VSIX_HASH=$(nix --extra-experimental-features "nix-command" hash file "--$HASH_FORMAT" --type "$HASH_ALGO" "$VSIX_PATH");
    fi
}

function prepare_package_json_path_expected {
    prepare_exttmp
    PACKAGE_JSON_PATH_EXPECTED="$EXTTMP/package.json"
}

function unpack_package_json {
    prepare_vsix_path
    prepare_package_json_path_expected
    unzip -qp "$VSIX_PATH" "extension/package.json" > "$PACKAGE_JSON_PATH_EXPECTED"
    PACKAGE_JSON_PATH="$PACKAGE_JSON_PATH_EXPECTED"
}

function prepare_package_json_path {
    if [[ -z "${PACKAGE_JSON_PATH-}" ]]; then
        unpack_package_json
    fi
}

# Get an attribute from a JSON file and assign to a shell variable.
# when the shell variable is empty or unset.
#
# Use as
# refget_from_json VARNAME_JSON VARNAME [+]ATTRNAME [EXLCUSION1 [EXCLUSION2 ...] ]
#
# Prefix the attribute name with `+`
# for JSON text output instead of raw string output
# (omitting `-r` for `jq`).
#
# The exclusion arguments, if given,
# forces the shell variable to be assign as "null"
# when the extracted value is identical to one of them.
function refget_from_varname_json {
    local VARNAME ATTRNAME IS_RAW
    VARNAME_JSON_PATH="$1"
    VARNAME="$2"
    ATTRNAME="$3"
    IS_RAW=1
    if [[ -n "${!VARNAME-}" ]]; then
        return 0
    fi
    if [[ "${ATTRNAME::1}" == "+" ]]; then
        ATTRNAME="${ATTRNAME:1}"
        IS_RAW=0
    fi
    local -a EXCLUSION_ARRAY
    EXCLUSION_ARRAY=()
    if (( "$#" > 3 )); then
        shift 3
        EXCLUSION_ARRAY=( "$@" )
    fi
    local RAWFLAG
    RAWFLAG=""
    if (( IS_RAW )); then
        RAWFLAG="-r"
    fi
    "prepare_${VARNAME_JSON_PATH,,}"
    declare -g "$VARNAME"="$(jq -c $RAWFLAG ".$ATTRNAME" "${!VARNAME_JSON_PATH}")"
    local EXCLUSION
    for EXCLUSION in "${EXCLUSION_ARRAY[@]}"; do
        if [[ "${!VARNAME}" == "$EXCLUSION" ]]; then
            declare -g "$VARNAME"="null"
            break
        fi
    done
}

# Get an attribute from package.json and assign to a shell variable.
# when the shell variable is empty or unset.
function refget_from_package_json {
    refget_from_varname_json PACKAGE_JSON_PATH "$@"
}

function prepare_vsix_version_fetched {
    refget_from_package_json VSIX_VERSION_FETCHED version
}

function prepare_vsix_version {
    if [[ -z "${VSIX_VERSION-}" ]]; then
        prepare_vsix_version_fetched
        if \
            [[ "$VSIX_VERSION_SPECIFIED" != "latest" ]] \
            && [[ "$VSIX_VERSION_SPECIFIED" != "pre" ]] \
            && [[ "$VSIX_VERSION_SPECIFIED" != "$VSIX_VERSION_FETCHED" ]] \
        ; then
            fail "prepare_vsix_version: Fetched version desn't match the specified vesion"
        else
            VSIX_VERSION="$VSIX_VERSION_FETCHED"
        fi
    fi
}

function prepare_meta_description {
    refget_from_package_json META_DESCRIPTION description ""
}

function prepare_meta_homepage {
    refget_from_package_json META_HOMEPAGE homepage ""
}

function prepare_meta_license_raw {
    refget_from_package_json META_LICENSE_RAW license ""
}

function prepare_extensionpack {
    refget_from_package_json EXTENSIONPACK +extensionPack
}

# Clean up the temp folder whenever exit
function cleanup_exttmp {
    if [[ -n "${EXTTMP-}" ]]; then
        rm -rf "$EXTTMP"
        unset EXTTMP
    fi
}

# Cleanup function, used by `trap` to execute on `EXIT`
function cleanup {
    cleanup_exttmp
}

# Prepare an associative array DICT_KEY_OUTPUT for keys / variables to print
function prepare_dict_key_output {
    declare -g -A DICT_KEY_OUTPUT
    if ! (set -u; echo "${#DICT_KEY_OUTPUT[@]}") > /dev/null 2>&1; then
        # Prevent Bash from considering it unbound
        # https://stackoverflow.com/questions/28055346/bash-unbound-variable-array-script-s3-bash
        DICT_KEY_OUTPUT=()
    fi
    if ! (( "${#DICT_KEY_OUTPUT[@]}" )); then
        DICT_KEY_OUTPUT["publisher"]=VSIX_PUBLISHER
        DICT_KEY_OUTPUT["name"]=VSIX_NAME
        DICT_KEY_OUTPUT["version"]=VSIX_VERSION
        if ! (( NO_HASH )); then
            prepare_hash_format
            if [[ "$HASH_FORMAT" == "sri" ]]; then
                DICT_KEY_OUTPUT["hash"]=VSIX_HASH
            else
                prepare_hash_algo
                DICT_KEY_OUTPUT["$HASH_ALGO"]=VSIX_HASH
            fi
        fi
        if ! (( NO_META )); then
            local KEYNAME VARNAME
            for KEYNAME in description homepage license_raw; do
                VARNAME="META_${KEYNAME^^}" # Upper case
                DICT_KEY_OUTPUT["$KEYNAME"]="$VARNAME"
            done
            DICT_KEY_OUTPUT["+extensionpack"]=EXTENSIONPACK
        fi
    fi
}

# Print the output
function print_output {
    prepare_dict_key_output
    local RESULT KEYNAME VARNAME
    # Reverse the keys first,
    # since Bash associative array's key display order
    # tends to be the reversal of the specification order.
    local -a KEYNAME_ARRAY_REVERSED=()
    for KEYNAME in "${!DICT_KEY_OUTPUT[@]}"; do
        KEYNAME_ARRAY_REVERSED=( "$KEYNAME" "${KEYNAME_ARRAY_REVERSED[@]}" )
    done
    for KEYNAME in "${KEYNAME_ARRAY_REVERSED[@]}"; do
        # Lower case
        "prepare_${DICT_KEY_OUTPUT["$KEYNAME"],,}"
    done
    RESULT="$(
        for KEYNAME in "${KEYNAME_ARRAY_REVERSED[@]}"; do
            VARNAME="${DICT_KEY_OUTPUT["$KEYNAME"]}"
            VALUE="${!VARNAME}"
            if [[ "$VALUE" != "null" ]]; then
                if [[ "${KEYNAME::1}" == "+" ]]; then
                    echo -n "\"${KEYNAME:1}\": $VALUE, "
                else
                    echo -n "\"$KEYNAME\": \"$(escape_doublequotes "$VALUE")\", "
                fi
            fi
        done
        echo
    )"
    # Remove the trailing ", " nd add "{" and "}"
    [[ -z "$RESULT" ]] || RESULT="${RESULT::-2}"
    # Run through jq
    echo "{$RESULT}" | jq
}
