# The no-op Bash function that preserves the return status of its inputs
#
# NOTE:
# If nop is called as the first command inside the else-block,
# and the inputs of nop don't have return status,
# it will return non-zero exit status from the if-condition.
nop() {
    local ret="$?"
    if [[ "$ret" != 0 ]]; then
        echo "nop: Get nonzero exit status $ret from the previous command." >&2
        return "$ret"
    fi
    return 0
}

addCMakeParams() {
    # NIXPKGS_CMAKE_PREFIX_PATH is like CMAKE_PREFIX_PATH except cmake
    # will not search it for programs
    addToSearchPath NIXPKGS_CMAKE_PREFIX_PATH $1
}

# https://cmake.org/cmake/help/book/mastering-cmake/cmake/Help/guide/user-interaction/index.html#setting-variables-on-the-command-line
# https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables
# https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/CMake%20Cache.html
declare -gA cmakeEntries

# https://cmake.org/cmake/help/latest/command/if.html#constant
canonicalizeCMakeBool() {
    local valIn="$1"
    case "${valIn^^}" in
        1|ON|YES|TRUE|Y)
            echo ON
            ;;
        ""|0|OFF|NO|FALSE|N|IGNORE|NOTFOUND|*-NOTFOUND)
            echo OFF
            ;;
        *[!0-9]*)
            echo "ERROR: cmakeBoolToBash: unsupported value ${valIn}" >&2
            return 1
            ;;
        *)
            echo 1
            ;;
    esac
}

canonicalizeCMakeEntryAttrs() {
    local key typeOrig
    for key in "${!cmakeEntries[@]}"; do
        if ! jq -e "has(\"$key\")" "$NIX_ATTRS_JSON_FILE" > /dev/null; then
            continue
        fi
        typeOrig="$(jq ".cmakeEntries.$key|type" "$NIX_ATTRS_JSON_FILE")"
        if [[ "$typeOrig" == "null" ]]; then
            {
                echo 'ERROR: canonicalizeCMakeEntryAttrs: `cmakeEntries.'"$key"'` has `null` value.'
                echo '  `null` values in structured sub-attributes are not ignored but translated to empty strings.'
                echo '  To exclude a cmakeEntries attribute, simply remove it from `cmakeEntries`'
            } >&2
            return 1
        fi
        if [[ "$typeOrig" == "boolean" ]]; then
            cmakeEntries[$key]="$(canonicalizeCMakeBool "${cmakeEntries[$key]}")"
        fi
    done
}

canonicalizeCMakeEntryAttrsIfAvailable() {
    local reasonToSkip=""
    if ! [[ -e "${NIX_ATTRS_JSON_FILE-}" ]]; then
        reasonToSkip="File \$NIX_ATTRS_JSON_FILE not available."
    elif ! command -v jq; then
        reasonToSkip="Command jq not available."
    elif ! jq -e "has(\"cmakeEntries\")" "$NIX_ATTRS_JSON_FILE"; then
        reasonToSkip="Attribute cmakeEntries not set."
    fi
    if [[ -n "$reasonToSkip" ]]; then
        echo "cmake: Skipping entry attribute canonicalization." >&2
        echo "$reasonToSkip" >&2
        return
    fi
    canonicalizeCMakeEntryAttrs
}

canonicalizeCMakeEntryAttrsIfAvailable

cmakeBoolToBash() {
    local valIn="$1"
    local valCanonical
    valCanonical="$(canonicalizeCMakeBool "$valIn")"
    if [[ "$valCanonical" == ON ]]; then
        echo 1
    fi
}

testCMakeBool() {
    local valIn="$1"
    local valCanonical
    nop "${valCanonical=$(canonicalizeCMakeBool "$valIn")}" || exit 1
    if [[ "$valCanonical" != ON ]]; then
        false
    fi
}

concatCMakeEntryFlagsTo() {
    if [[ "$1" != flagsArray ]]; then
        local -n flagsArray="$1"
    fi
    if [[ "$2" != cmakeEntries ]]; then
        local -n cmakeEntries="$2"
    fi
    local key
    for key in "${!cmakeEntries[@]}"; do
        flagsArray+=("-D$key=${cmakeEntries[$key]}")
    done
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

cmakeConfigurePhase() {
    runHook preConfigure

    # default to CMake defaults if unset
    nop "${cmakeBuildDir:=build}"

    export CTEST_OUTPUT_ON_FAILURE=1
    if [ -n "${enableParallelChecking-1}" ]; then
        export CTEST_PARALLEL_LEVEL=$NIX_BUILD_CORES
    fi

    if [ -z "${dontUseCmakeBuildDir-}" ]; then
        mkdir -p "$cmakeBuildDir"
        cd "$cmakeBuildDir"
        nop "${cmakeDir:=..}"
    else
        true # Zeroize the previous exit status.
        nop "${cmakeDir:=.}"
    fi

    if [ -z "${dontAddPrefix-}" ]; then
        nop "${cmakeEntries[CMAKE_INSTALL_PREFIX]=$prefix}"
    fi

    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    nop "${cmakeEntries[CMAKE_CXX_COMPILER]=$CXX}"
    nop "${cmakeEntries[CMAKE_C_COMPILER]=$CC}"
    nop "${cmakeEntries[CMAKE_AR]=$(command -v "$AR")}"
    nop "${cmakeEntries[CMAKE_RANLIB]=$(command -v "$RANLIB")}"
    nop "${cmakeEntries[CMAKE_STRIP]=$(command -v "$STRIP")}"

    # This installs shared libraries with a fully-specified install
    # name. By default, cmake installs shared libraries with just the
    # basename as the install name, which means that, on Darwin, they
    # can only be found by an executable at runtime if the shared
    # libraries are in a system path or in the same directory as the
    # executable. This flag makes the shared library accessible from its
    # nix/store directory.
    nop "${cmakeEntries[CMAKE_INSTALL_NAME_DIR]=${!outputLib}/lib}"

    # The docdir flag needs to include PROJECT_NAME as per GNU guidelines,
    # try to extract it from CMakeLists.txt.
    if [[ -z "$shareDocName" ]]; then
        shareDocName=$(parseShareDocName)
    fi

    # This ensures correct paths with multiple output derivations
    # It requires the project to use variables from GNUInstallDirs module
    # https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
    nop "${cmakeEntries[CMAKE_INSTALL_BINDIR]=${!outputBin}/bin}"
    nop "${cmakeEntries[CMAKE_INSTALL_SBINDIR]=${!outputBin}/sbin}"
    nop "${cmakeEntries[CMAKE_INSTALL_INCLUDEDIR]=${!outputInclude}/include}"
    nop "${cmakeEntries[CMAKE_INSTALL_MANDIR]=${!outputMan}/share/man}"
    nop "${cmakeEntries[CMAKE_INSTALL_INFODIR]=${!outputInfo}/share/info}"
    nop "${cmakeEntries[CMAKE_INSTALL_DOCDIR]=${!outputDoc}/share/doc/${shareDocName}}"
    nop "${cmakeEntries[CMAKE_INSTALL_LIBDIR]=${!outputLib}/lib}"
    nop "${cmakeEntries[CMAKE_INSTALL_LIBEXECDIR]=${!outputLib}/libexec}"
    nop "${cmakeEntries[CMAKE_INSTALL_LOCALEDIR]=${!outputLib}/share/locale}"

    # Don’t build tests when doCheck = false
    if [ -z "${doCheck-}" ]; then
        nop "${BUILD_TESTING=OFF}"
    fi

    # Always build Release, to ensure optimisation flags
    nop "${cmakeEntries[CMAKE_BUILD_TYPE]=${cmakeBuildType:-Release}}"

    # Disable user package registry to avoid potential side effects
    # and unecessary attempts to access non-existent home folder
    # https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#disabling-the-package-registry
    nop "${CMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON}"
    nop "${CMAKE_FIND_USE_PACKAGE_REGISTRY=OFF}"
    nop "${CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY=OFF}"

    if [ "${buildPhase-}" = ninjaBuildPhase ]; then
        prependToVar cmakeFlags "-GNinja"
    fi

    local flagsArray=()
    concatCMakeEntryFlagsTo flagsArray cmakeEntries
    concatTo flagsArray cmakeFlags cmakeFlagsArray

    # Redefine cmakeFlags for backward compatibility purposes.
    # Some packages may still expect cmakeConfigurePhase
    # to add the full list of flags into cmakeFlags.
    if [[ "$(declare -p cmakeFlags)" =~ "^declare -a" ]]; then
        cmakeFlags=()
    else
        cmakeFlags=""
    fi
    appendToVar cmakeFlags "${flagsArray[@]}"

    echoCmd 'cmake flags' "${flagsArray[@]}"

    cmake "$cmakeDir" "${flagsArray[@]}"

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
