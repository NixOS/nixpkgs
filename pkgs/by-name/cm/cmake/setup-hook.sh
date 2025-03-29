addCMakeParams() {
    # NIXPKGS_CMAKE_PREFIX_PATH is like CMAKE_PREFIX_PATH except cmake
    # will not search it for programs
    addToSearchPath NIXPKGS_CMAKE_PREFIX_PATH $1
}

fixCmakeFiles() {
    # Replace occurences of /usr and /opt by /var/empty.
    echo "fixing cmake files..."
    find "$1" -type f \( -name "*.cmake" -o -name "*.cmake.in" -o -name CMakeLists.txt \) -print |
        while read fn; do
            sed -e 's^/usr\([ /]\|$\)^/var/empty\1^g' -e 's^/opt\([ /]\|$\)^/var/empty\1^g' < "$fn" > "$fn.tmp"
            mv "$fn.tmp" "$fn"
        done
}

cmakeConfigurePhase() {
    runHook preConfigure

    # default to CMake defaults if unset
    : ${cmakeBuildDir:=build}

    export CTEST_OUTPUT_ON_FAILURE=1
    if [ -n "${enableParallelChecking-1}" ]; then
        export CTEST_PARALLEL_LEVEL=$NIX_BUILD_CORES
    fi

    if [ -z "${dontFixCmake-}" ]; then
        fixCmakeFiles .
    fi

    if [ -z "${dontUseCmakeBuildDir-}" ]; then
        mkdir -p "$cmakeBuildDir"
        cd "$cmakeBuildDir"
        : ${cmakeDir:=..}
    else
        : ${cmakeDir:=.}
    fi

    if [ -z "${dontAddPrefix-}" ]; then
        prependToVar cmakeFlags "-DCMAKE_INSTALL_PREFIX=$prefix"
    fi

    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    prependToVar cmakeFlags "-DCMAKE_CXX_COMPILER=$CXX"
    prependToVar cmakeFlags "-DCMAKE_C_COMPILER=$CC"
    prependToVar cmakeFlags "-DCMAKE_AR=$(command -v $AR)"
    prependToVar cmakeFlags "-DCMAKE_RANLIB=$(command -v $RANLIB)"
    prependToVar cmakeFlags "-DCMAKE_STRIP=$(command -v $STRIP)"

    # on macOS we want to prefer Unix-style headers to Frameworks
    # because we usually do not package the framework
    prependToVar cmakeFlags "-DCMAKE_FIND_FRAMEWORK=LAST"

    # correctly detect our clang compiler
    prependToVar cmakeFlags "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"

    # This installs shared libraries with a fully-specified install
    # name. By default, cmake installs shared libraries with just the
    # basename as the install name, which means that, on Darwin, they
    # can only be found by an executable at runtime if the shared
    # libraries are in a system path or in the same directory as the
    # executable. This flag makes the shared library accessible from its
    # nix/store directory.
    prependToVar cmakeFlags "-DCMAKE_INSTALL_NAME_DIR=${!outputLib}/lib"

    # The docdir flag needs to include PROJECT_NAME as per GNU guidelines,
    # try to extract it from CMakeLists.txt.
    if [[ -z "$shareDocName" ]]; then
        local cmakeLists="${cmakeDir}/CMakeLists.txt"
        if [[ -f "$cmakeLists" ]]; then
            local shareDocName="$(grep --only-matching --perl-regexp --ignore-case '\bproject\s*\(\s*"?\K([^[:space:]")]+)' < "$cmakeLists" | head -n1)"
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
    fi

    # This ensures correct paths with multiple output derivations
    # It requires the project to use variables from GNUInstallDirs module
    # https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
    prependToVar cmakeFlags "-DCMAKE_INSTALL_BINDIR=${!outputBin}/bin"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_SBINDIR=${!outputBin}/sbin"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_MANDIR=${!outputMan}/share/man"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_INFODIR=${!outputInfo}/share/info"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_DOCDIR=${!outputDoc}/share/doc/${shareDocName}"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_LIBDIR=${!outputLib}/lib"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_LIBEXECDIR=${!outputLib}/libexec"
    prependToVar cmakeFlags "-DCMAKE_INSTALL_LOCALEDIR=${!outputLib}/share/locale"

    # Don’t build tests when doCheck = false
    if [ -z "${doCheck-}" ]; then
        prependToVar cmakeFlags "-DBUILD_TESTING=OFF"
    fi

    # Always build Release, to ensure optimisation flags
    prependToVar cmakeFlags "-DCMAKE_BUILD_TYPE=${cmakeBuildType:-Release}"

    # Disable user package registry to avoid potential side effects
    # and unecessary attempts to access non-existent home folder
    # https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#disabling-the-package-registry
    prependToVar cmakeFlags "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
    prependToVar cmakeFlags "-DCMAKE_FIND_USE_PACKAGE_REGISTRY=OFF"
    prependToVar cmakeFlags "-DCMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY=OFF"

    if [ "${buildPhase-}" = ninjaBuildPhase ]; then
        prependToVar cmakeFlags "-GNinja"
    fi

    local flagsArray=()
    concatTo flagsArray cmakeFlags cmakeFlagsArray

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
