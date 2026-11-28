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
# For example, calling prepare_vsix_path will realize the VSIX file (*.vsix),
# and prepare_manifest_path the manifest file (package.json).
#
# Part of the code is adapted from get_vsixpkg() of the original update_install_exts.sh

###PLACEHOLDER_PATH_PREFIXING###

function reset_variables {
    # variables to be `prepare_`d
    unset COMPACT
    unset CONFIGURATION
    unset EXTTMP
    unset HASH_FORMAT
    unset HASH_ALGO
    unset NO_HASH
    unset NO_META
    unset PRINT_CONFIGURATION
    unset VSIX_HASH
    unset VSIX_IDENTIFIER
    unset VSIX_NAME
    unset VSIX_PATH
    unset VSIX_PATH_EXPECTED
    unset VSIX_PUBLISHER
    unset VSIX_URL
    unset VSIX_VERSION
    unset VSIX_VERSION_FETCHED
    unset VSIX_VERSION_SPECIFIED
}

if (("$#")) && [[ "${1-}" != "--no-reset" ]]; then
    reset_variables
fi

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
    local RESULT
    RESULT="${1//\\/\\\\}"
    echo "${RESULT//\"/\\\"/}"
}

# Split shorthands and re-add them into "$@"
# -abc -d -> -a -b -c -d
function manage_shorthands {
    local STR_RAW="${1:1}"
    shift
    local -i i=0
    # Parameterized expansions of for loop
    # doesn't work with 'set -u' (throw unbound variable error)
    # {1..2} doesn't work with variables as the upper bound
    # So use 'seq' from 'coreutils'
    for i in $(seq 0 $((${#STR_RAW} - 1))); do
        set -- "-${STR_RAW:-$i:1}" "$@"
    done
}

# Quietly but delicately curl down the file, blowing up at the first sign of trouble.
function download_file {
    local FILE_PATH="$1"
    local URL="$2"
    if ! curl --silent --show-error --fail -L -o "$FILE_PATH" "$URL" || [[ ! -e "$FILE_PATH" ]]; then
        echo "download_file: Failed to download $FILE_PATH from $URL." >&2
        return 1
    fi
}

# Create a tempdir for the extension download.
function create_exttmp {
    EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)
}

function prepare_exttmp {
    if [[ -z "${EXTTMP-}" ]]; then
        echo "create_exttmp must be run first for security reasons" >&2
        return 1
    fi
}

# The publisher part of the extension identifier
function prepare_vsix_publisher {
    if [[ -z "${VSIX_PUBLISHER-}" ]]; then
        echo "VSIX_PUBLISHER: Variable empty or unavailable." >&2
        return 1
    fi
}

# The name part of the extension identifier
function prepare_vsix_name {
    if [[ -z "${VSIX_NAME-}" ]]; then
        echo "VSIX_NAME: Variable empty or unavailable." >&2
        return 1
    fi
}

# The specified version, often default to latest (registry-dependent)
function prepare_vsix_version_specified {
    if [[ -z "${VSIX_VERSION_SPECIFIED-}" ]]; then
        echo "VSIX_VERSION_SPECIFIED: Variable empty or unavailable." >&2
        return 1
    fi
}

# The extension identifier
function prepare_vsix_identifier {
    prepare_vsix_publisher
    prepare_vsix_name
    VSIX_IDENTIFIER="$VSIX_PUBLISHER.$VSIX_NAME"
}

# URL to download the VSIX file
function prepare_vsix_url {
    echo "prepare_vsix_url: Bash function not implemented." >&2
    return 1
}

# Expected path of the VSIX file
function prepare_vsix_path_expected {
    prepare_exttmp
    prepare_vsix_identifier
    VSIX_PATH_EXPECTED="$EXTTMP/$VSIX_IDENTIFIER.vsix"
}

# Download the VSIX file
function download_vsix {
    prepare_vsix_path_expected
    prepare_vsix_url
    download_file "$VSIX_PATH_EXPECTED" "$VSIX_URL"
    VSIX_PATH="$VSIX_PATH_EXPECTED"
}

# Realized path of the VSIX file
function prepare_vsix_path {
    if [[ -z "${VSIX_PATH-}" ]]; then
        download_vsix
    fi
}

# Add the downloadded VSIX file to the Nix store
function add_vsix_to_store {
    prepare_vsix_identifier
    prepare_vsix_version_fetched
    local PROPER_NAME="$VSIX_IDENTIFIER-$VSIX_VERSION_FETCHED"
    prepare_vsix_platform
    if [[ "$VSIX_PLATFORM" != "universal" ]]; then
        PROPER_NAME="$PROPER_NAME@$VSIX_PLATFORM"
    fi
    PROPER_NAME="$PROPER_NAME.vsix"
    prepare_vsix_path
    local PROPER_PATH
    PROPER_PATH="$(dirname "$VSIX_PATH")/$PROPER_NAME"
    cp --link "$VSIX_PATH" "$PROPER_PATH"
    nix-store --add-fixed sha256 "$PROPER_PATH" >/dev/null
    unlink "$PROPER_PATH"
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

# Compute the hash directly
function compute_vsix_hash {
    if [[ -z "${VSIX_HASH-}" ]]; then
        prepare_vsix_path
        prepare_hash_format
        prepare_hash_algo
        VSIX_HASH=$(nix --extra-experimental-features "nix-command" hash file "--$HASH_FORMAT" --type "$HASH_ALGO" "$VSIX_PATH")
    fi
}

function prepare_vsix_hash {
    compute_vsix_hash
}

function prepare_manifest_path_expected {
    prepare_exttmp
    MANIFEST_PATH_EXPECTED="$EXTTMP/package.json"
}

# Unpack the extension manifest from the VSIX file
function unpack_manifest {
    prepare_vsix_path
    prepare_manifest_path_expected
    unzip -qp "$VSIX_PATH" "extension/package.json" >"$MANIFEST_PATH_EXPECTED"
    MANIFEST_PATH="$MANIFEST_PATH_EXPECTED"
}

# Realize the extension manifest
function prepare_manifest_path {
    if [[ -z "${MANIFEST_PATH-}" ]]; then
        unpack_manifest
    fi
}

# Get an attribute from a JSON file and assign to a shell variable.
# when the shell variable is empty or unset.
#
# Use as
# refget_from_varname_json VARNAME_JSON VARNAME [+]ATTRNAME [EXLCUSION1 [EXCLUSION2 ...] ]
#
# Prefix the attribute name with `+`
# for JSON text output instead of raw string output
# (omitting `-r` for `jq`).
#
# The exclusion arguments, if given,
# forces the shell variable to be assign as "null"
# when the extracted value is identical to one of them.
function refget_from_varname_json {
    local VARNAME_JSON_PATH VARNAME ATTRNAME IS_RAW
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
    if (("$#" > 3)); then
        shift 3
        EXCLUSION_ARRAY=("$@")
    fi
    local -a FLAGS_ARRAY
    FLAGS_ARRAY=("-c")
    if ((IS_RAW)); then
        FLAGS_ARRAY+=("-r")
    fi
    "prepare_${VARNAME_JSON_PATH,,}"
    declare -g "$VARNAME"="$(jq "${FLAGS_ARRAY[@]}" ".$ATTRNAME" "${!VARNAME_JSON_PATH}")"
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
function refget_from_manifest {
    refget_from_varname_json MANIFEST_PATH "$@"
}

function prepare_vsix_version_fetched {
    refget_from_manifest VSIX_VERSION_FETCHED version
}

function prepare_vsix_version {
    if [[ -z "${VSIX_VERSION-}" ]]; then
        prepare_vsix_version_fetched
        if
            [[ "$VSIX_VERSION_SPECIFIED" != "latest" ]] &&
                [[ "$VSIX_VERSION_SPECIFIED" != "pre" ]] &&
                [[ "$VSIX_VERSION_SPECIFIED" != "$VSIX_VERSION_FETCHED" ]]
        then
            echo "prepare_vsix_version: Fetched version desn't match the specified vesion" >&2
            return 1
        else
            VSIX_VERSION="$VSIX_VERSION_FETCHED"
        fi
    fi
}

function prepare_meta_description {
    refget_from_manifest META_DESCRIPTION description ""
}

function prepare_meta_homepage {
    refget_from_manifest META_HOMEPAGE homepage ""
}

function prepare_meta_license_raw {
    refget_from_manifest META_LICENSE_RAW license ""
}

function prepare_extensionpack {
    refget_from_manifest EXTENSIONPACK +extensionPack
}

function prepare_configuration {
    refget_from_manifest CONFIGURATION +contributes.configuration
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

function prepare_no_hash {
    if [[ -z "${NO_HASH-}" ]]; then
        NO_HASH=0
    fi
}

function prepare_no_meta {
    if [[ -z "${NO_META-}" ]]; then
        NO_META=0
    fi
}

function prepare_print_configuration {
    if [[ -z "${PRINT_CONFIGURATION}" ]]; then
        PRINT_CONFIGURATION=0
    fi
}

# Prepare an associative array DICT_KEY_OUTPUT for keys / variables to print
function prepare_dict_key_output {
    declare -g -A DICT_KEY_OUTPUT
    if ! (
        set -u
        echo "${#DICT_KEY_OUTPUT[@]}"
    ) >/dev/null 2>&1; then
        # Prevent Bash from considering it unbound
        # https://stackoverflow.com/questions/28055346/bash-unbound-variable-array-script-s3-bash
        DICT_KEY_OUTPUT=()
    fi
    if ! (("${#DICT_KEY_OUTPUT[@]}")); then
        DICT_KEY_OUTPUT["publisher"]=VSIX_PUBLISHER
        DICT_KEY_OUTPUT["name"]=VSIX_NAME
        DICT_KEY_OUTPUT["version"]=VSIX_VERSION
        prepare_no_hash
        if ! ((NO_HASH)); then
            prepare_hash_format
            if [[ "$HASH_FORMAT" == "sri" ]]; then
                DICT_KEY_OUTPUT["hash"]=VSIX_HASH
            else
                prepare_hash_algo
                DICT_KEY_OUTPUT["$HASH_ALGO"]=VSIX_HASH
            fi
        fi
        prepare_no_meta
        if ! ((NO_META)); then
            local KEYNAME VARNAME
            for KEYNAME in description homepage license_raw; do
                VARNAME="META_${KEYNAME^^}" # Upper case
                DICT_KEY_OUTPUT["$KEYNAME"]="$VARNAME"
            done
            DICT_KEY_OUTPUT["+extensionpack"]=EXTENSIONPACK
        fi
        if ((PRINT_CONFIGURATION)); then
            DICT_KEY_OUTPUT["+configuration"]=CONFIGURATION
        fi
    fi
}

function prepare_compact {
    if [[ -z "${COMPACT-}" ]]; then
        COMPACT=0
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
        KEYNAME_ARRAY_REVERSED=("$KEYNAME" "${KEYNAME_ARRAY_REVERSED[@]}")
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
    local -a FLAGS_ARRAY
    FLAGS_ARRAY=()
    prepare_compact
    if ((COMPACT)); then
        FLAGS_ARRAY+=("-c")
    fi
    echo "{$RESULT}" | jq "${FLAGS_ARRAY[@]}"
}
