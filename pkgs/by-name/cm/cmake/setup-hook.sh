addCMakeParams() {
    # NIXPKGS_CMAKE_PREFIX_PATH is like CMAKE_PREFIX_PATH except cmake
    # will not search it for programs
    addToSearchPath NIXPKGS_CMAKE_PREFIX_PATH $1
}

# The docdir flag needs to include PROJECT_NAME as per GNU guidelines,
# try to extract it from CMakeLists.txt.
parseShareDocName() {
    local cmakeLists="$cmakeDir/CMakeLists.txt"
    if [[ -f "$cmakeLists" ]]; then
        local shareDocName
        shareDocName="$(grep --only-matching --perl-regexp --ignore-case '\bproject\s*\(\s*"?\K([^[:space:]")]+)' <"$cmakeLists" | head -n1)"
    fi
    # The argument sometimes contains garbage or variable interpolation.
    # When that is the case, let’s fall back to the derivation name.
    if [[ -z "$shareDocName" ]] || echo "$shareDocName" | grep -q '[^a-zA-Z0-9_+-]'; then
        if [[ -n "${pname-}" ]]; then
            shareDocName="$pname"
        else
            shareDocName="$(echo "$name" | sed 's/-[^a-zA-Z].*//')"
        fi
    fi
    echo "$shareDocName"
}

declare -gA cmakeEntries

cmakeValueFromJSON() {
    cmake -DINPUT_JSON="$1" -P /dev/stdin <<END_OF_CMAKE_SCRIPT
set(UNEXPECTED_TYPES NULL ARRAY OBJECT)
string(JSON VALUE_TYPE TYPE "\${INPUT_JSON}")
list(FIND UNEXPECTED_TYPES "\${VALUE_TYPE}" UNEXPECTED_TYPE_FOUND)
if (NOT UNEXPECTED_TYPE_FOUND STREQUAL "-1")
  message(FATAL_ERROR "GetCMakeEntryWith: Unexpected value type \${VALUE_TYPE} for INPUT_JSON \${INPUT_JSON}")
endif()
string(JSON OUTPUT_STRING GET "\${INPUT_JSON}")
file(APPEND /dev/stdout "\${OUTPUT_STRING}")
END_OF_CMAKE_SCRIPT
}

canonicaliseCMakeBool() {
    cmake -DINPUT_STRING="$1" -P /dev/stdin <<END_OF_CMAKE_SCRIPT
if (INPUT_STRING)
  set(RESULT_BY_VARIABLE true)
else()
  set(RESULT_BY_VARIABLE false)
endif()
if ("\${INPUT_STRING}")
  set(RESULT_BY_STRING true)
else()
  set(RESULT_BY_STRING false)
endif()
if (NOT RESULT_BY_VARIABLE STREQUAL "\${RESULT_BY_STRING}")
  message(INFO "INPUT_STRING is begin\${INPUT_STRING}end")
  message(INFO "RESULT_BY_VARIABLE is \${RESULT_BY_VARIABLE}")
  message(INFO "RESULT_BY_STRING is \${RESULT_BY_STRING}")
  message(FATAL_ERROR "canonicaliseCMakeBool: ${name-cmake/setup-hook.sh}: VALUE is neither a CMake true constant nor a CMake false constant.")
endif()
string(JSON OUTPUT_STRING GET "\${RESULT_BY_VARIABLE}")
file(APPEND /dev/stdout "\${OUTPUT_STRING}")
END_OF_CMAKE_SCRIPT
}

cmakeBoolToJSON() {
    local canonicalBool
    canonicalBool="$(canonicaliseCMakeBool "$1")"
    if [[ "$canonicalBool" = "ON" ]]; then
        echo true
    else
        echo false
    fi
}

cmakeStringToJSON() {
    cmake -DINPUT_STRING="$1" -P /dev/stdin <<END_OF_CMAKE_SCRIPT
string(JSON OUTPUT_STRING STRING_ENCODE "\${INPUT_STRING}")
file(APPEND /dev/stdout "\${OUTPUT_STRING}")
END_OF_CMAKE_SCRIPT
}

cmakeGetJSONType() {
    cmake -DINPUT_JSON="$1" -P /dev/stdin <<END_OF_CMAKE_SCRIPT
string(JSON OUTPUT_STRING TYPE "\${INPUT_JSON}")
file(APPEND /dev/stdout "\${OUTPUT_STRING}")
END_OF_CMAKE_SCRIPT
}

getCMakeEntryWith() {
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: getCMakeEntryWith requires argument KEY." >&2
        return 1
    fi
    local key=$1
    local keyword="${2:-GET}"
    keyword="${keyword^^}"
    local has_default=
    local -a extraFlags=()
    if (("$#" >= 3)); then
        has_default=1
        local default=$3
        extraFlags+=("-DDEFAULT_STRING=$default")
    fi
    if [[ "$keyword" == "REMOVE" ]]; then
        unset cmakeEntries[$key]
    fi
    if [[ -n "${__structuredAttrs-}" ]]; then
        cmake -DKEY="$key" -DKEYWORD="$keyword" "${extraFlags[@]}" -P @GetCMakeEntryWith@
    elif [[ "$keyword" == "REMOVE" ]]; then
        return
    elif [[ -n "$has_default" ]]; then
        echo "${cmakeEntries[$key]-$default}"
    else
        echo "${cmakeEntries[$key]}"
    fi
}

getCMakeEntry() {
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: getCMakeEntry requires argument KEY." >&2
        return 1
    fi
    local key="$1"
    shift
    getCMakeEntryWith "$key" GET "$@"
}

getCMakeEntryJSON() {
    if [[ -z "${__structuredAttrs-}" ]]; then
        echo "ERROR: ${name-cmake/setup-hook.sh}: getCMakeEntryJSON requires __structuredAttrs = true" >&2
        return 1
    fi
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: getCMakeEntryJSON requires argument KEY." >&2
        return 1
    fi
    local key="$1"
    shift
    getCMakeEntryWith "$key" GET_RAW "$@"
}

removeCMakeEntry() {
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: removeCMakeEntry requires argument KEY." >&2
        return 1
    fi
    local key="$1"
    getCMakeEntryWith "$key" REMOVE
}

setCMakeEntryJSON() {
    if (("$#" < 2)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: setCMakeEntryJSON requires arguments KEY VALUE." >&2
        return 1
    fi
    local key=$1
    local input_json=$2
    local dont_override="${3-}"

    if [[ -n "${__structuredAttrs-}" ]]; then
        cmake \
            -DKEY="$key" \
            -DINPUT_JSON="$input_json" \
            -DDONT_OVERRIDE="$dont_override" \
            -P @SetCMakeEntryJSON@
    fi

    if [[ "$(cmakeBoolToJSON "$dont_override")" == true ]] && [[ -v cmakeEntries[$key] ]]; then
        return
    fi

    local value_type
    vaule_type="$(cmakeGetJSONType "$input_json")"
    case "$value_type" in
        NULL|ARRAY|OBJECT)
            echo "ERROR: ${name-cmake/setup-hook.sh}: setCMakeEntryBool: unexpected value type $value_type for INPUT_JSON $input_json" >&2
            ;;
    esac

    local val_canonical
    val_canonical="$(cmakeValueFromJSON "$input_json")"
    cmakeEntries[$key]=$val_canonical
}

setCMakeEntryBool() {
    if (("$#" < 2)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: setCMakeEntryBool requires arguments KEY VALUE." >&2
        return 1
    fi
    local key=$1
    local bool_string=$2
    local dont_override="${3-}"

    local bool_json
    bool_json="$(cmakeBoolToJSON "$bool_string")"
    setCMakeEntryJSON "$key" "$bool_json" "$dont_override"
}

setCMakeEntryString() {
    if (("$#" < 2)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: setCMakeEntryString requires arguments KEY VALUE." >&2
        return 1
    fi
    local key=$1
    local input_string=$2
    local dont_override="${3-}"

    local string_json
    string_json="$(cmakeStringToJSON "$input_string")"

    setCMakeEntryJSON "$key" "$string_json" "$dont_override"
}

# Define the prepend/append setters

_prefix_CMakeEntry_type_() {
    if (("$#" < 2)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: prependCMakeEntry_type_ requires arguments KEY VALUE." >&2
        return 1
    fi
    setCMakeEntry_type_ "$1" "$2" _dont_override_
}

for _type in Bool JSON String; do
    local original_definition new_definition
    original_definition="$(declare -f _prefix_CMakeEntry_type_)"
    new_definition=$original_definition
    new_definition="${new_definition//_prefix_/prepend}"
    new_definition="${new_definition//_type_/$_type}"
    new_definition="${new_definition//_dont_override_/true}"
    eval "$new_definition"
    new_definition=$original_definition
    new_definition="${new_definition//_prefix_/append}"
    new_definition="${new_definition//_type_/$_type}"
    new_definition="${new_definition//_dont_override_/false}"
    eval "$new_definition"
done

unset -f _prefix_CMakeEntry_type_

sourceCMakeEntriesVar() {
    if [[ -z "${__structuredAttrs-}" ]]; then
        return 0
    fi
    # `cmake.setupHooks` get source when building `cmake` itself, where the `cmake` command is unavailable.
    if ! command -v cmake; then
        echo "WARNING: ${name-cmake/setup-hook.sh}: sourceCMakeEntriesVar requires cmake, doing nothing." >&2
        return 0
    fi
    cmakeEntries=()
    local commandsToSource=""
    commandsToSource="$(cmake -P @GenCMakeEntriesRC@)"
    source /dev/stdin <<< "$commandsToSource"
}

if [[ -n "${__structuredAttrs-}" ]]; then
    appendToVar prePhases sourceCMakeEntriesVar
fi

concatCMakeEntryFlagsTo() {
    if [[ "$1" != flagsArray ]]; then
        local -n flagsArray="$1"
    fi
    if (("$#" >= 2)); then
        if [[ "$2" != cmakeEntries ]]; then
            local -n cmakeEntries="$2"
        fi
    else
        local cmakeEntries=()
        sourceCMakeEntriesVar
    fi
    local key
    for key in "${!cmakeEntries[@]}"; do
        flagsArray+=("-D$key=${cmakeEntries[$key]}")
    done
}

sourceCMakeFlagsVar() {
    # `cmake.setupHooks` get source when building `cmake` itself, where the `cmake` command is unavailable.
    if ! command -v cmake; then
        echo "WARNING: ${name-cmake/setup-hook.sh}: sourceCMakeFlagsVar requires cmake, doing nothing." >&2
        return 0
    fi

    local useArray
    if [[ -n "${__structuredAttrs-}" ]]; then
        useArray=true
    else
        useArray=false
    fi

    # check if variable already exist and if it does then do extra checks
    if type=$(declare -p cmakeFlags 2> /dev/null); then
        case "${type#* }" in
            -A*)
                echo "ERROR: ${name-cmake/setup-hook.sh}: sourceCMakeFlagsVar: cmakeFlags is an associative array." >&2
                return 1
                ;;
            -a*)
                useArray=true
                cmakeFlags=()
                ;;
            *)
                useArray=false
                cmakeFlags=""
                ;;
        esac
    fi

    if $useArray; then
        local -n flagsArray=cmakeFlags
    else
        local flagsArray=()
    fi

    local commandsToSource=""
    commandsToSource="$(cmake -DATTRIBUTE_NAME=cmakeFlags -DVARIABLE_NAME=flagsArray -DIGNORE_NULL=true -P @GenCMakeEntriesRC@)"
    source /dev/stdin <<< "$commandsToSource"

    if ! $useArray; then
        appendToVar cmakeFlags "${flagsArray[@]}"
    fi
}

if [[ -n "${__structuredAttrs-}" ]]; then
    appendToVar prePhases sourceCMakeFlagsVar
fi

setCMakeFlagsFromVar() {
    if [[ -z "${__structuredAttrs-}" ]]; then
        return
    fi
    # `cmake.setupHooks` get source when building `cmake` itself, where the `cmake` command is unavailable.
    if ! command -v cmake; then
        echo "WARNING: ${name-cmake/setup-hook.sh}: setCMakeFlagsFromVar requires cmake, doing nothing." >&2
        return 0
    fi
    local flagsArray=()
    concatTo flagsArray cmakeFlags
    local escapedArray=()
    local s
    for s in "${flagsArray[@]}"; do
        escapedArray+=("$(cmakeStringToJSON "$s")")
    done
    local json_value
    json_value="[$(concatStringsSep "," escapedArray)]"
    cmake -DPREKEY= -DKEY=cmakeFlags -DINPUT_JSON="$json_value" -P @SetCMakeEntryJSON@
}

appendToCMakeFlags() {
    appendToVar cmakeFlags "$@"
    if [[ -z "${__structuredAttrs-}" ]]; then
        return
    fi
    cmake -DOPERATION=APPEND -DNEW_ELEMENTS="$(concatStringsSep ";" "$@")" -P @OperateCMakeFlags@
}

prependToCMakeFlags() {
    prependToVar cmakeFlags "$@"
    if [[ -z "${__structuredAttrs-}" ]]; then
        return
    fi
    cmake -DOPERATION=PREPEND -DNEW_ELEMENTS="$(concatStringsSep ";" "$@")" -P @OperateCMakeFlags@
}

removeCMakeFlag() {
    if [[ -z "${__structuredAttrs-}" ]]; then
        echo "ERROR: ${name-cmake/setup-hook.sh}: removeCMakeFlag requires __structuredAttrs = true" >&2
        return 1
    fi
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: removeCMakeFlag requires argument PATTERN." >&2
        return 1
    fi
    cmake -DOPERATION=REMOVE_EQUAL -DPATTERN="$1" -P @OperateCMakeFlags@
    sourceCMakeFlagsVar
}

removeMatchedCMakeFlag() {
    if [[ -z "${__structuredAttrs-}" ]]; then
        echo "ERROR: ${name-cmake/setup-hook.sh}: removeMatchedCMakeFlag requires __structuredAttrs = true" >&2
        return 1
    fi
    if (("$#" < 1)); then
        echo "ERROR: ${name-cmake/setup-hook.sh}: removeMatchedCMakeFlag requires argument PATTERN." >&2
        return 1
    fi
    cmake -DOPERATION=REMOVE_MATCHED -DPATTERN="$1" -P @OperateCMakeFlags@
    sourceCMakeFlagsVar
}

cmakeConfigurePhase() {
    # For backward compatibility
    setCMakeFlagsFromVar

    runHook preConfigure

    # default to CMake defaults if unset
    : ${cmakeBuildDir:=build}

    export CTEST_OUTPUT_ON_FAILURE=1
    if [ -n "${enableParallelChecking-1}" ]; then
        export CTEST_PARALLEL_LEVEL=$NIX_BUILD_CORES
    fi

    if [ -z "${dontUseCmakeBuildDir-}" ]; then
        mkdir -p "$cmakeBuildDir"
        cd "$cmakeBuildDir"
        : ${cmakeDir:=..}
    else
        : ${cmakeDir:=.}
    fi

    if [ -z "${dontAddPrefix-}" ]; then
        prependCMakeEntryString "CMAKE_INSTALL_PREFIX" "$prefix"
    fi

    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    prependCMakeEntryString "CMAKE_CXX_COMPILER" "$CXX"
    prependCMakeEntryString "CMAKE_C_COMPILER" "$CC"
    prependCMakeEntryString "CMAKE_AR" "$(command -v $AR)"
    prependCMakeEntryString "CMAKE_RANLIB" "$(command -v $RANLIB)"
    prependCMakeEntryString "CMAKE_STRIP" "$(command -v $STRIP)"

    # This installs shared libraries with a fully-specified install
    # name. By default, cmake installs shared libraries with just the
    # basename as the install name, which means that, on Darwin, they
    # can only be found by an executable at runtime if the shared
    # libraries are in a system path or in the same directory as the
    # executable. This flag makes the shared library accessible from its
    # nix/store directory.
    prependCMakeEntryString "CMAKE_INSTALL_NAME_DIR" "${!outputLib}/lib"

    # The docdir flag needs to include PROJECT_NAME as per GNU guidelines,
    # try to extract it from CMakeLists.txt.
    if [[ -z "$shareDocName" ]]; then
        shareDocName=$(parseShareDocName)
    fi

    # This ensures correct paths with multiple output derivations
    # It requires the project to use variables from GNUInstallDirs module
    # https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
    prependCMakeEntryString "CMAKE_INSTALL_BINDIR" "${!outputBin}/bin"
    prependCMakeEntryString "CMAKE_INSTALL_SBINDIR" "${!outputBin}/sbin"
    prependCMakeEntryString "CMAKE_INSTALL_INCLUDEDIR" "${!outputInclude}/include"
    prependCMakeEntryString "CMAKE_INSTALL_MANDIR" "${!outputMan}/share/man"
    prependCMakeEntryString "CMAKE_INSTALL_INFODIR" "${!outputInfo}/share/info"
    prependCMakeEntryString "CMAKE_INSTALL_DOCDIR" "${!outputDoc}/share/doc/${shareDocName}"
    prependCMakeEntryString "CMAKE_INSTALL_LIBDIR" "${!outputLib}/lib"
    prependCMakeEntryString "CMAKE_INSTALL_LIBEXECDIR" "${!outputLib}/libexec"
    prependCMakeEntryString "CMAKE_INSTALL_LOCALEDIR" "${!outputLib}/share/locale"

    # Don’t build tests when doCheck = false
    if [ -z "${doCheck-}" ]; then
        prependCMakeEntryBool "BUILD_TESTING" "OFF"
    fi

    # Always build Release, to ensure optimisation flags
    prependCMakeEntryString "CMAKE_BUILD_TYPE" "${cmakeBuildType:-Release}"

    # Disable user package registry to avoid potential side effects
    # and unecessary attempts to access non-existent home folder
    # https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#disabling-the-package-registry
    prependCMakeEntryBool "CMAKE_EXPORT_NO_PACKAGE_REGISTRY" "ON"
    prependCMakeEntryBool "CMAKE_FIND_USE_PACKAGE_REGISTRY" "OFF"
    prependCMakeEntryBool "CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY" "OFF"

    if [ "${buildPhase-}" = ninjaBuildPhase ]; then
        prependToCMakeFlags "-GNinja"
    fi

    local flagsArray=()
    concatCMakeEntryFlagsTo flagsArray cmakeEntries

    if [[ -n "${joinCMakeEntryFlags-}" ]]; then
        prependToCMakeFlags "${flagsArray[@]}"
    fi

    concatTo flagsArray cmakeFlags cmakeFlagsArray

    echoCmd 'cmake flags' "${flagsArray[@]}"

    if [[ -z "${dontExecuteCMake-}" ]]; then
        cmake "$cmakeDir" "${flagsArray[@]}"
    fi

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "cmake: enabled parallel building"
    fi
    if [[ "$enableParallelBuilding" -ne 0 ]]; then
        export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        echo "cmake: enabled parallel installing"
    fi

    runHook postConfigure
}

if [ -z "${dontUseCmakeConfigure-}" -a -z "${configurePhase-}" ]; then
    setOutputFlags=
    configurePhase=cmakeConfigurePhase
fi

addEnvHooks "$targetOffset" addCMakeParams

makeCmakeFindLibs() {
    isystem_seen=
    iframework_seen=
    for flag in ${NIX_CFLAGS_COMPILE-} ${NIX_LDFLAGS-}; do
        if test -n "$isystem_seen" && test -d "$flag"; then
            isystem_seen=
            addToSearchPath CMAKE_INCLUDE_PATH "${flag}"
        elif test -n "$iframework_seen" && test -d "$flag"; then
            iframework_seen=
            addToSearchPath CMAKE_FRAMEWORK_PATH "${flag}"
        else
            isystem_seen=
            iframework_seen=
            case $flag in
            -I*)
                addToSearchPath CMAKE_INCLUDE_PATH "${flag:2}"
                ;;
            -L*)
                addToSearchPath CMAKE_LIBRARY_PATH "${flag:2}"
                ;;
            -F*)
                addToSearchPath CMAKE_FRAMEWORK_PATH "${flag:2}"
                ;;
            -isystem)
                isystem_seen=1
                ;;
            -iframework)
                iframework_seen=1
                ;;
            esac
        fi
    done
}

# not using setupHook, because it could be a setupHook adding additional
# include flags to NIX_CFLAGS_COMPILE
postHooks+=(makeCmakeFindLibs)
