{
  lib,
  stdenv,
  llvm_meta,
  pkgsBuildBuild,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  python3,
  libffi,
  libbfd,
  libpfm,
  libxml2,
  ncurses,
  version,
  zlib,
  which,
  tblgen,
  updateAutotoolsGnuConfigScriptsHook,
  fetchpatch,
}:

let
  inherit (lib) optionals optionalString;
in

stdenv.mkDerivation (
  finalAttrs:
  let
    # Ordinarily we would just the `doCheck` and `checkDeps` functionality
    # `mkDerivation` gives us to manage our test dependencies (instead of breaking
    # out `doCheck` as a package level attribute).
    #
    # Unfortunately `lit` does not forward `$PYTHONPATH` to children processes, in
    # particular the children it uses to do feature detection.
    #
    # This means that python deps we add to `checkDeps` (which the python
    # interpreter is made aware of via `$PYTHONPATH` – populated by the python
    # setup hook) are not picked up by `lit` which causes it to skip tests.
    #
    # Adding `python3.withPackages (ps: [ ... ])` to `checkDeps` also doesn't work
    # because this package is shadowed in `$PATH` by the regular `python3`
    # package.
    #
    # So, we "manually" assemble one python derivation for the package to depend
    # on, taking into account whether checks are enabled or not:
    python =
      if finalAttrs.finalPackage.doCheck then
        # Note that we _explicitly_ ask for a python interpreter for our host
        # platform here; the splicing that would ordinarily take care of this for
        # us does not seem to work once we use `withPackages`.
        let
          checkDeps = ps: [ ps.psutil ];
        in
        pkgsBuildBuild.targetPackages.python3.withPackages checkDeps
      else
        python3;
  in
  {
    pname = "llvm";
    inherit version;

    # Used when creating a version-suffixed symlink of libLLVM.dylib
    shortVersion = lib.concatStringsSep "." (lib.take 1 (lib.splitString "." version));

    src = runCommand "llvm-src-${version}" { inherit (monorepoSrc) passthru; } ''
      mkdir -p "$out"
      cp -r ${monorepoSrc}/llvm "$out"
      cp -r ${monorepoSrc}/cmake "$out"
      cp -r ${monorepoSrc}/third-party "$out"
      chmod u+w "$out/llvm/tools"
      cp -r ${monorepoSrc}/polly "$out/llvm/tools"
    '';
    sourceRoot = "${finalAttrs.src.name}/llvm";

    outputs = [
      "out"
      "lib"
      "dev"
      "python"
    ];

    hardeningDisable = [
      "trivialautovarinit"
      "shadowstack"
    ];

    patches = [
      # Support custom installation dirs
      # Originally based off https://reviews.llvm.org/D99484
      # Latest state: https://github.com/llvm/llvm-project/pull/125376
      ./gnu-install-dirs.patch

      # Running the tests involves invoking binaries (like `opt`) that depend on
      # the LLVM dylibs and reference them by absolute install path (i.e. their
      # nix store path).
      #
      # Because we have not yet run the install phase (we're running these tests
      # as part of `checkPhase` instead of `installCheckPhase`) these absolute
      # paths do not exist yet; to work around this we point the loader (`ld` on
      # unix, `dyld` on macOS) at the `lib` directory which will later become this
      # package's `lib` output.
      #
      # Previously we would just set `LD_LIBRARY_PATH` to include the build `lib`
      # dir but:
      #   - this doesn't generalize well to other platforms; `lit` doesn't forward
      #     `DYLD_LIBRARY_PATH` (macOS):
      #     + https://github.com/llvm/llvm-project/blob/0d89963df354ee309c15f67dc47c8ab3cb5d0fb2/llvm/utils/lit/lit/TestingConfig.py#L26
      #   - even if `lit` forwarded this env var, we actually cannot set
      #     `DYLD_LIBRARY_PATH` in the child processes `lit` launches because
      #     `DYLD_LIBRARY_PATH` (and `DYLD_FALLBACK_LIBRARY_PATH`) is cleared for
      #     "protected processes" (i.e. the python interpreter that runs `lit`):
      #     https://stackoverflow.com/a/35570229
      #   - other LLVM subprojects deal with this issue by having their `lit`
      #     configuration set these env vars for us; it makes sense to do the same
      #     for LLVM:
      #     + https://github.com/llvm/llvm-project/blob/4c106cfdf7cf7eec861ad3983a3dd9a9e8f3a8ae/clang-tools-extra/test/Unit/lit.cfg.py#L22-L31
      #
      # !!! TODO: look into upstreaming this patch
      ./llvm-lit-cfg-add-libs-to-dylib-path.patch

      # `lit` has a mode where it executes run lines as a shell script which is
      # constructs; this is problematic for macOS because it means that there's
      # another process in between `lit` and the binaries being tested. As noted
      # above, this means that `DYLD_LIBRARY_PATH` is cleared which means that our
      # tests fail with dyld errors.
      #
      # To get around this we patch `lit` to reintroduce `DYLD_LIBRARY_PATH`, when
      # present in the test configuration.
      #
      # It's not clear to me why this isn't an issue for LLVM developers running
      # on macOS (nothing about this _seems_ nix specific)..
      ./lit-shell-script-runner-set-dyld-library-path.patch

      # Add missing include headers to build against gcc-15:
      #   https://github.com/llvm/llvm-project/pull/101761
      (fetchpatch {
        url = "https://github.com/llvm/llvm-project/commit/7e44305041d96b064c197216b931ae3917a34ac1.patch";
        hash = "sha256-1htuzsaPHbYgravGc1vrR8sqpQ/NSQ8PUZeAU8ucCFk=";
        stripLen = 1;
      })

      # Fix musl build.
      (fetchpatch {
        url = "https://github.com/llvm/llvm-project/commit/5cd554303ead0f8891eee3cd6d25cb07f5a7bf67.patch";
        relative = "llvm";
        hash = "sha256-XPbvNJ45SzjMGlNUgt/IgEvM2dHQpDOe6woUJY+nUYA=";
      })

      # Fix for Python 3.13
      ./no-pipes.patch
      # fix RuntimeDyld usage on aarch64-linux (e.g. python312Packages.numba tests)
      # See also: https://github.com/numba/numba/issues/9109
      (fetchpatch {
        url = "https://github.com/llvm/llvm-project/commit/2e1b838a889f9793d4bcd5dbfe10db9796b77143.patch";
        relative = "llvm";
        hash = "sha256-Ot45P/iwaR4hkcM3xtLwfryQNgHI6pv6ADjv98tgdZA=";
      })

      # Just like the `gnu-install-dirs` patch, but for `polly`.
      ./gnu-install-dirs-polly.patch
      # Just like the `llvm-lit-cfg` patch, but for `polly`.
      ./polly-lit-cfg-add-libs-to-dylib-path.patch
    ];

    nativeBuildInputs = [
      cmake
      # while this is not an autotools build, it still includes a config.guess
      # this is needed until scripts are updated to not use /usr/bin/uname on FreeBSD native
      updateAutotoolsGnuConfigScriptsHook
      python
      ninja
    ];

    buildInputs = [
      libxml2
      libffi
      libpfm
    ];

    propagatedBuildInputs = lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) ncurses ++ [
      zlib
    ];

    postPatch =
      # FileSystem permissions tests fail with various special bits
      ''
        substituteInPlace unittests/Support/CMakeLists.txt \
          --replace-fail "Path.cpp" ""
        rm unittests/Support/Path.cpp
        substituteInPlace unittests/IR/CMakeLists.txt \
          --replace-fail "PassBuilderCallbacksTest.cpp" ""
        rm unittests/IR/PassBuilderCallbacksTest.cpp
        rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
        rm utils/lit/tests/googletest-timeout.py
        patchShebangs test/BugPoint/compile-custom.ll.py
      '';

    # Workaround for configure flags that need to have spaces
    preConfigure = ''
      cmakeFlagsArray+=(
        -DLLVM_LIT_ARGS="--verbose -j''${NIX_BUILD_CORES}"
      )
    '';

    # E.g. Mesa uses the build-id as a cache key (see #93946):
    LDFLAGS = "-Wl,--build-id=sha1";

    cmakeBuildType = "Release";

    cmakeFlags =
      let
        # These flags influence llvm-config's BuildVariables.inc in addition to the
        # general build. We need to make sure these are also passed via
        # CROSS_TOOLCHAIN_FLAGS_NATIVE when cross-compiling or llvm-config-native
        # will return different results from the cross llvm-config.
        #
        # Some flags don't need to be repassed because LLVM already does so (like
        # CMAKE_BUILD_TYPE), others are irrelevant to the result.
        flagsForLlvmConfig = [
          (lib.cmakeFeature "LLVM_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/llvm")
          (lib.cmakeBool "LLVM_ENABLE_RTTI" true)
          (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" true)
          (lib.cmakeFeature "LLVM_TABLEGEN" "${tblgen}/bin/llvm-tblgen")
        ];
      in
      flagsForLlvmConfig
      ++ [
        (lib.cmakeBool "LLVM_INSTALL_UTILS" true) # Needed by rustc
        (lib.cmakeBool "LLVM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
        (lib.cmakeBool "LLVM_ENABLE_FFI" true)
        (lib.cmakeFeature "LLVM_HOST_TRIPLE" stdenv.hostPlatform.config)
        (lib.cmakeFeature "LLVM_DEFAULT_TARGET_TRIPLE" stdenv.hostPlatform.config)
        (lib.cmakeBool "LLVM_ENABLE_DUMP" true)
        (lib.cmakeBool "LLVM_ENABLE_TERMINFO" true)
        (lib.cmakeBool "LLVM_INCLUDE_TESTS" finalAttrs.finalPackage.doCheck)

        # LLVM depends on binutils only through libbfd/include/plugin-api.h, which
        # is meant to be a stable interface. Depend on that file directly rather
        # than through a build of BFD to break the dependency of clang on the target
        # triple. The result of this is that a single clang build can be used for
        # multiple targets.
        (lib.cmakeFeature "LLVM_BINUTILS_INCDIR" "${libbfd.plugin-api-header}/include")
      ]
      ++
        optionals
          (
            (stdenv.hostPlatform != stdenv.buildPlatform)
            && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform)
          )
          [
            (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
            (
              let
                nativeCC = pkgsBuildBuild.targetPackages.stdenv.cc;
                nativeBintools = nativeCC.bintools.bintools;
                nativeToolchainFlags = [
                  (lib.cmakeFeature "CMAKE_C_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}cc")
                  (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}c++")
                  (lib.cmakeFeature "CMAKE_AR" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ar")
                  (lib.cmakeFeature "CMAKE_STRIP" "${nativeBintools}/bin/${nativeBintools.targetPrefix}strip")
                  (lib.cmakeFeature "CMAKE_RANLIB" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ranlib")
                ];
                # We need to repass the custom GNUInstallDirs values, otherwise CMake
                # will choose them for us, leading to wrong results in llvm-config-native
                nativeInstallFlags = [
                  (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
                  (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "${placeholder "out"}/bin")
                  (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "${placeholder "dev"}/include")
                  (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "${placeholder "lib"}/lib")
                  (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "${placeholder "lib"}/libexec")
                ];
              in
              lib.cmakeOptionType "list" "CROSS_TOOLCHAIN_FLAGS_NATIVE" (
                lib.concatStringsSep ";" (
                  lib.concatLists [
                    flagsForLlvmConfig
                    nativeToolchainFlags
                    nativeInstallFlags
                  ]
                )
              )
            )
          ];

    postInstall = ''
      mkdir -p $python/share
      mv $out/share/opt-viewer $python/share/opt-viewer
      moveToOutput "bin/llvm-config*" "$dev"
      substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-${lib.toLower finalAttrs.finalPackage.cmakeBuildType}.cmake" \
        --replace-fail "$out/bin/llvm-config" "$dev/bin/llvm-config"
      substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
        --replace-fail 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
    ''
    + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) (
      if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
        ''
          ln -s $dev/bin/llvm-config $dev/bin/llvm-config-native
        ''
      else
        ''
          cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
        ''
    );

    doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

    checkTarget = "check-all";

    requiredSystemFeatures = [ "big-parallel" ];
    meta = llvm_meta // {
      homepage = "https://llvm.org/";
      description = "Collection of modular and reusable compiler and toolchain technologies";
      longDescription = ''
        The LLVM Project is a collection of modular and reusable compiler and
        toolchain technologies. Despite its name, LLVM has little to do with
        traditional virtual machines. The name "LLVM" itself is not an acronym; it
        is the full name of the project.
        LLVM began as a research project at the University of Illinois, with the
        goal of providing a modern, SSA-based compilation strategy capable of
        supporting both static and dynamic compilation of arbitrary programming
        languages. Since then, LLVM has grown to be an umbrella project consisting
        of a number of subprojects, many of which are being used in production by
        a wide variety of commercial and open source projects as well as being
        widely used in academic research. Code in the LLVM project is licensed
        under the "Apache 2.0 License with LLVM exceptions".
      '';
    };

    nativeCheckInputs = [
      which
    ];

    # Defensive check: some paths (that we make symlinks to) depend on the release
    # version, for example:
    #  - https://github.com/llvm/llvm-project/blob/406bde9a15136254f2b10d9ef3a42033b3cb1b16/clang/lib/Headers/CMakeLists.txt#L185
    #
    # So we want to sure that the version in the source matches the release
    # version we were given.
    #
    # We do this check here, in the LLVM build, because it happens early.
    postConfigure =
      let
        v = lib.versions;
        major = v.major version;
        minor = v.minor version;
        patch = v.patch version;
      in
      ''
        # $1: part, $2: expected
        check_version() {
          part="''${1^^}"
          part="$(cat include/llvm/Config/llvm-config.h  | grep "#define LLVM_VERSION_''${part} " | cut -d' ' -f3)"

          if [[ "$part" != "$2" ]]; then
            echo >&2 \
              "mismatch in the $1 version! we have version ${version}" \
              "and expected the $1 version to be '$2'; the source has '$part' instead"
            exit 3
          fi
        }

        check_version major ${major}
        check_version minor ${minor}
        check_version patch ${patch}
      '';
  }
)
