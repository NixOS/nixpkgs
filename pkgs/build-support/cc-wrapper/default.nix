# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{
  name ? "",
  lib,
  stdenvNoCC,
  runtimeShell,
  cc ? null,
  libc ? null,
  bintools,
  coreutils ? null,
  apple-sdk ? null,
  nativeTools,
  noLibc ? false,
  nativeLibc,
  nativePrefix ? "",
  propagateDoc ? cc != null && cc ? man,
  extraTools ? [ ],
  extraPackages ? [ ],
  extraBuildCommands ? "",
  nixSupport ? { },
  isGNU ? false,
  isClang ? cc.isClang or false,
  isZig ? cc.isZig or false,
  isArocc ? cc.isArocc or false,
  isCcache ? cc.isCcache or false,
  gnugrep ? null,
  expand-response-params,
  libcxx ? null,

  # Whether or not to add `-B` and `-L` to `nix-support/cc-{c,ld}flags`
  useCcForLibs ?

    # Always add these flags for Clang, because in order to compile (most
    # software) it needs libraries that are shipped and compiled with gcc.
    if isClang then
      true

    # Never add these flags for a build!=host cross-compiler or a host!=target
    # ("cross-built-native") compiler; currently nixpkgs has a special build
    # path for these (`crossStageStatic`).  Hopefully at some point that build
    # path will be merged with this one and this conditional will be removed.
    else if (with stdenvNoCC; buildPlatform != hostPlatform || hostPlatform != targetPlatform) then
      false

    # Never add these flags when wrapping the bootstrapFiles' compiler; it has a
    # /usr/-like layout with everything smashed into a single outpath, so it has
    # no trouble finding its own libraries.
    else if (cc.passthru.isFromBootstrapFiles or false) then
      false

    # Add these flags when wrapping `xgcc` (the first compiler that nixpkgs builds)
    else if (cc.passthru.isXgcc or false) then
      true

    # Add these flags when wrapping `stdenv.cc`
    else if (cc.stdenv.cc.cc.passthru.isXgcc or false) then
      true

    # Do not add these flags in any other situation.  This is `false` mainly to
    # prevent these flags from being added when wrapping *old* versions of gcc
    # (e.g. `gcc6Stdenv`), since they will cause the old gcc to get `-B` and
    # `-L` flags pointing at the new gcc's libstdc++ headers.  Example failure:
    # https://hydra.nixos.org/build/213125495
    else
      false,

  # the derivation at which the `-B` and `-L` flags added by `useCcForLibs` will point
  gccForLibs ? if useCcForLibs then cc else null,
  fortify-headers ? null,
  includeFortifyHeaders ? null,
}:

assert nativeTools -> !propagateDoc && nativePrefix != "";
assert !nativeTools -> cc != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

let
  inherit (lib)
    attrByPath
    concatMapStrings
    concatStringsSep
    escapeShellArg
    escapeShellArgs
    getBin
    getDev
    getLib
    getName
    getVersion
    hasPrefix
    mapAttrsToList
    optional
    optionalAttrs
    optionals
    optionalString
    removePrefix
    removeSuffix
    replaceStrings
    toList
    versionAtLeast
    ;

  inherit (stdenvNoCC) buildPlatform hostPlatform targetPlatform;

  includeFortifyHeaders' =
    if includeFortifyHeaders != null then
      includeFortifyHeaders
    else
      (targetPlatform.libc == "musl" && isGNU);

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by default.
  targetPrefix = optionalString (targetPlatform != hostPlatform) (targetPlatform.config + "-");

  ccVersion = getVersion cc;
  ccName = removePrefix targetPrefix (getName cc);

  libc_bin = optionalString (libc != null) (getBin libc);
  libc_dev = optionalString (libc != null) (getDev libc);
  libc_lib = optionalString (libc != null) (getLib libc);
  cc_solib = getLib cc + optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}";

  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = optionalString (!nativeTools) (getBin coreutils);

  # The "suffix salt" is a arbitrary string added in the end of env vars
  # defined by cc-wrapper's hooks so that multiple cc-wrappers can be used
  # without interfering. For the moment, it is defined as the target triple,
  # adjusted to be a valid bash identifier. This should be considered an
  # unstable implementation detail, however.
  suffixSalt =
    replaceStrings [ "-" "." ] [ "_" "_" ] targetPlatform.config
    + lib.optionalString (targetPlatform.isDarwin && targetPlatform.isStatic) "_static";

  useGccForLibs =
    useCcForLibs
    && libcxx == null
    && !targetPlatform.isDarwin
    && !(targetPlatform.useLLVM or false)
    && !(targetPlatform.useAndroidPrebuilt or false)
    && !(targetPlatform.isiOS or false)
    && gccForLibs != null;
  gccForLibs_solib =
    getLib gccForLibs + optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}";

  # Analogously to cc_solib and gccForLibs_solib
  libcxx_solib = "${getLib libcxx}/lib";

  # The following two functions, `isGccArchSupported` and
  # `isGccTuneSupported`, only handle those situations where a flag
  # (`-march` or `-mtune`) is accepted by one compiler but rejected
  # by another, and both compilers are relevant to nixpkgs.  We are
  # not trying to maintain a complete list of all flags accepted by
  # all versions of all compilers ever in nixpkgs.
  #
  # The two main cases of interest are:
  #
  # - One compiler is gcc and the other is clang
  # - One compiler is pkgs.gcc and the other is bootstrap-files.gcc
  #   -- older compilers (for example bootstrap's GCC 5) fail with
  #   -march=too-modern-cpu

  isGccArchSupported =
    arch:
    if targetPlatform.isPower then
      false
    # powerpc does not allow -march=
    else if isGNU then
      {
        # Generic
        x86-64-v2 = versionAtLeast ccVersion "11.0";
        x86-64-v3 = versionAtLeast ccVersion "11.0";
        x86-64-v4 = versionAtLeast ccVersion "11.0";

        # Intel
        skylake = true;
        skylake-avx512 = true;
        cannonlake = versionAtLeast ccVersion "8.0";
        icelake-client = versionAtLeast ccVersion "8.0";
        icelake-server = versionAtLeast ccVersion "8.0";
        cascadelake = versionAtLeast ccVersion "9.0";
        cooperlake = versionAtLeast ccVersion "10.0";
        tigerlake = versionAtLeast ccVersion "10.0";
        knm = versionAtLeast ccVersion "8.0";
        alderlake = versionAtLeast ccVersion "12.0";
        sapphirerapids = versionAtLeast ccVersion "11.0";
        emeraldrapids = versionAtLeast ccVersion "13.0";
        sierraforest = versionAtLeast ccVersion "13.0";

        # AMD
        znver1 = true;
        znver2 = versionAtLeast ccVersion "9.0";
        znver3 = versionAtLeast ccVersion "11.0";
        znver4 = versionAtLeast ccVersion "13.0";
        znver5 = versionAtLeast ccVersion "14.0";

        # LoongArch64
        # https://gcc.gnu.org/gcc-12/changes.html#loongarch
        # la464 was added together with loongarch64 support
        # https://gcc.gnu.org/gcc-14/changes.html#loongarch
        "la64v1.0" = versionAtLeast ccVersion "14.0";
        "la64v1.1" = versionAtLeast ccVersion "14.0";
        la664 = versionAtLeast ccVersion "14.0";
      }
      .${arch} or true
    else if isClang then
      {
        #Generic
        x86-64-v2 = versionAtLeast ccVersion "12.0";
        x86-64-v3 = versionAtLeast ccVersion "12.0";
        x86-64-v4 = versionAtLeast ccVersion "12.0";

        # Intel
        cannonlake = versionAtLeast ccVersion "5.0";
        icelake-client = versionAtLeast ccVersion "7.0";
        icelake-server = versionAtLeast ccVersion "7.0";
        knm = versionAtLeast ccVersion "7.0";
        alderlake = versionAtLeast ccVersion "16.0";
        sapphirerapids = versionAtLeast ccVersion "12.0";
        emeraldrapids = versionAtLeast ccVersion "16.0";

        # AMD
        znver1 = versionAtLeast ccVersion "4.0";
        znver2 = versionAtLeast ccVersion "9.0";
        znver3 = versionAtLeast ccVersion "12.0";
        znver4 = versionAtLeast ccVersion "16.0";
        znver5 = versionAtLeast ccVersion "19.1";

        # LoongArch64
        # https://releases.llvm.org/16.0.0/tools/clang/docs/ReleaseNotes.html#loongarch-support
        # la464 was added together with loongarch64 support
        # https://releases.llvm.org/19.1.0/tools/clang/docs/ReleaseNotes.html#loongarch-support
        "la64v1.0" = versionAtLeast ccVersion "19.1";
        "la64v1.1" = versionAtLeast ccVersion "19.1";
        la664 = versionAtLeast ccVersion "19.1";
      }
      .${arch} or true
    else
      false;

  isGccTuneSupported =
    tune:
    # for x86 -mtune= takes the same values as -march, plus two more:
    if targetPlatform.isx86 then
      {
        generic = true;
        intel = true;
      }
      .${tune} or (isGccArchSupported tune)
    # on arm64, the -mtune= values are specific processors
    else if targetPlatform.isAarch64 then
      (
        if isGNU then
          {
            cortex-a53 = true;
            cortex-a72 = true;
            "cortex-a72.cortex-a53" = true;
          }
          .${tune} or false
        else if isClang then
          {
            cortex-a53 = versionAtLeast ccVersion "3.9"; # llvm dfc5d1
          }
          .${tune} or false
        else
          false
      )
    else if targetPlatform.isPower then
      # powerpc does not support -march
      true
    else if targetPlatform.isMips then
      # for mips -mtune= takes the same values as -march
      isGccArchSupported tune
    else
      false;

  # Clang does not support as many `-mtune=` values as gcc does;
  # this function will return the best possible approximation of the
  # provided `-mtune=` value, or `null` if none exists.
  #
  # Note: this function can make use of ccVersion; for example, `if
  # versionOlder ccVersion "12" then ...`
  findBestTuneApproximation =
    tune:
    let
      guess =
        if isClang then
          {
            # clang does not tune for big.LITTLE chips
            "cortex-a72.cortex-a53" = "cortex-a72";
          }
          .${tune} or tune
        else
          tune;
    in
    if isGccTuneSupported guess then guess else null;

  thumb = if targetPlatform.gcc.thumb then "thumb" else "arm";
  tune =
    if targetPlatform ? gcc.tune then findBestTuneApproximation targetPlatform.gcc.tune else null;

  # Machine flags. These are necessary to support

  # TODO: We should make a way to support miscellaneous machine
  # flags and other gcc flags as well.

  machineFlags =
    # Always add -march based on cpu in triple. Sometimes there is a
    # discrepancy (x86_64 vs. x86-64), so we provide an "arch" arg in
    # that case.
    optional (
      targetPlatform ? gcc.arch
      && !(targetPlatform.isDarwin && targetPlatform.isAarch64)
      && isGccArchSupported targetPlatform.gcc.arch
    ) "-march=${targetPlatform.gcc.arch}"
    ++
      # TODO: aarch64-darwin has mcpu incompatible with gcc
      optional (
        targetPlatform ? gcc.cpu && !(targetPlatform.isDarwin && targetPlatform.isAarch64)
      ) "-mcpu=${targetPlatform.gcc.cpu}"
    ++
      # -mfloat-abi only matters on arm32 but we set it here
      # unconditionally just in case. If the abi specifically sets hard
      # vs. soft floats we use it here.
      optional (targetPlatform ? gcc.float-abi) "-mfloat-abi=${targetPlatform.gcc.float-abi}"
    ++ optional (targetPlatform ? gcc.fpu) "-mfpu=${targetPlatform.gcc.fpu}"
    ++ optional (targetPlatform ? gcc.mode) "-mmode=${targetPlatform.gcc.mode}"
    ++ optional (targetPlatform ? gcc.thumb) "-m${thumb}"
    ++ optional (tune != null) "-mtune=${tune}"
    ++
      optional (targetPlatform ? gcc.strict-align)
        "-m${optionalString (!targetPlatform.gcc.strict-align) "no-"}strict-align"
    ++ optional (
      targetPlatform ? gcc.cmodel
      &&
        # TODO: clang on powerpcspe also needs a condition: https://github.com/llvm/llvm-project/issues/71356
        # https://releases.llvm.org/18.1.6/tools/clang/docs/ReleaseNotes.html#loongarch-support
        ((targetPlatform.isLoongArch64 && isClang) -> versionAtLeast ccVersion "18.1")
    ) "-mcmodel=${targetPlatform.gcc.cmodel}";

  defaultHardeningFlags = bintools.defaultHardeningFlags or [ ];

  # if cc.hardeningUnsupportedFlagsByTargetPlatform exists, this is
  # called with the targetPlatform as an argument and
  # cc.hardeningUnsupportedFlags is completely ignored - the function
  # is responsible for including the constant hardeningUnsupportedFlags
  # list however it sees fit.
  ccHardeningUnsupportedFlags =
    if cc ? hardeningUnsupportedFlagsByTargetPlatform then
      cc.hardeningUnsupportedFlagsByTargetPlatform targetPlatform
    else
      (cc.hardeningUnsupportedFlags or [ ]);

  darwinPlatformForCC = optionalString targetPlatform.isDarwin (
    if (targetPlatform.darwinPlatform == "macos" && isGNU) then
      "macosx"
    else
      targetPlatform.darwinPlatform
  );

  # Header files that use `__FILE__` (e.g., for error reporting) lead
  # to unwanted references to development packages and outputs in built
  # binaries, like C++ programs depending on GCC and Boost at runtime.
  #
  # We use `-fmacro-prefix-map` to avoid the store references in these
  # situations while keeping them in compiler diagnostics and debugging
  # and profiling output.
  #
  # Unfortunately, doing this with GCC runs into issues with compiler
  # argument length limits due to <https://gcc.gnu.org/PR111527>, so we
  # disable it there in favour of our existing patch.
  #
  # TODO: Drop `mangle-NIX_STORE-in-__FILE__.patch` from GCC and make
  # this unconditional once the upstream bug is fixed.
  useMacroPrefixMap = !isGNU;
in

assert includeFortifyHeaders' -> fortify-headers != null;

# Ensure bintools matches
assert libc_bin == bintools.libc_bin;
assert libc_dev == bintools.libc_dev;
assert libc_lib == bintools.libc_lib;
assert nativeTools == bintools.nativeTools;
assert nativeLibc == bintools.nativeLibc;
assert nativePrefix == bintools.nativePrefix;

stdenvNoCC.mkDerivation {
  pname = targetPrefix + (if name != "" then name else "${ccName}-wrapper");
  version = optionalString (cc != null) ccVersion;

  preferLocalBuild = true;

  outputs = [
    "out"
  ]
  ++ optionals propagateDoc [
    "man"
    "info"
  ];

  # Cannot be in "passthru" due to "substituteAll"
  inherit isArocc;

  passthru = {
    inherit targetPrefix suffixSalt;
    # "cc" is the generic name for a C compiler, but there is no one for package
    # providing the linker and related tools. The two we use now are GNU
    # Binutils, and Apple's "cctools"; "bintools" as an attempt to find an
    # unused middle-ground name that evokes both.
    inherit bintools;
    inherit
      cc
      libc
      libcxx
      nativeTools
      nativeLibc
      nativePrefix
      isGNU
      isClang
      isZig
      ;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/include"))
            (setenv "NIX_CFLAGS_COMPILE_${suffixSalt}" (concat (getenv "NIX_CFLAGS_COMPILE_${suffixSalt}") " -isystem " arg "/include"))))
        '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';

    # Expose expand-response-params we are /actually/ using. In stdenv
    # bootstrapping, expand-response-params usually comes from an earlier stage,
    # so it is important to expose this for reference checking.
    inherit expand-response-params;

    inherit nixSupport;

    inherit defaultHardeningFlags;
  }
  // optionalAttrs cc.langGo or false {
    # So gccgo looks more like go for buildGoModule

    inherit (targetPlatform.go) GOOS GOARCH GOARM;

    CGO_ENABLED = 1;
  };

  dontBuild = true;
  dontConfigure = true;
  enableParallelBuilding = true;

  # TODO(@connorbaker):
  # This is a quick fix unblock builds broken by https://github.com/NixOS/nixpkgs/pull/370750.
  dontCheckForBrokenSymlinks = true;

  unpackPhase = ''
    src=$PWD
  '';

  wrapper = ./cc-wrapper.sh;

  installPhase = ''
    mkdir -p $out/bin $out/nix-support

    wrap() {
      local dst="$1"
      local wrapper="$2"
      export prog="$3"
      export use_response_file_by_default=${if isClang && !isCcache then "1" else "0"}
      substituteAll "$wrapper" "$out/bin/$dst"
      chmod +x "$out/bin/$dst"
    }

    include() {
      printf -- '%s %s\n' "$1" "$2"
      ${lib.optionalString useMacroPrefixMap ''
        local scrubbed="$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-''${2#"$NIX_STORE"/*-}"
        printf -- '-fmacro-prefix-map=%s=%s\n' "$2" "$scrubbed"
      ''}
    }
  ''

  + (
    if nativeTools then
      ''
        echo ${if targetPlatform.isDarwin then cc else nativePrefix} > $out/nix-support/orig-cc

        ccPath="${if targetPlatform.isDarwin then cc else nativePrefix}/bin"
      ''
    else
      ''
        echo $cc > $out/nix-support/orig-cc

        ccPath="${cc}/bin"
      ''
  )

  # Create symlinks to everything in the bintools wrapper.
  + ''
    for bbin in $bintools/bin/*; do
      mkdir -p "$out/bin"
      ln -s "$bbin" "$out/bin/$(basename $bbin)"
    done
  ''

  # We export environment variables pointing to the wrapped nonstandard
  # cmds, lest some lousy configure script use those to guess compiler
  # version.
  + ''
    export named_cc=${targetPrefix}cc
    export named_cxx=${targetPrefix}c++

    if [ -e $ccPath/${targetPrefix}gcc ]; then
      wrap ${targetPrefix}gcc $wrapper $ccPath/${targetPrefix}gcc
      ln -s ${targetPrefix}gcc $out/bin/${targetPrefix}cc
      export named_cc=${targetPrefix}gcc
      export named_cxx=${targetPrefix}g++
    elif [ -e $ccPath/clang ]; then
      wrap ${targetPrefix}clang $wrapper $ccPath/clang
      ln -s ${targetPrefix}clang $out/bin/${targetPrefix}cc
      export named_cc=${targetPrefix}clang
      export named_cxx=${targetPrefix}clang++
    elif [ -e $ccPath/arocc ]; then
      wrap ${targetPrefix}arocc $wrapper $ccPath/arocc
      ln -s ${targetPrefix}arocc $out/bin/${targetPrefix}cc
      export named_cc=${targetPrefix}arocc
    fi

    if [ -e $ccPath/${targetPrefix}g++ ]; then
      wrap ${targetPrefix}g++ $wrapper $ccPath/${targetPrefix}g++
      ln -s ${targetPrefix}g++ $out/bin/${targetPrefix}c++
    elif [ -e $ccPath/clang++ ]; then
      wrap ${targetPrefix}clang++ $wrapper $ccPath/clang++
      ln -s ${targetPrefix}clang++ $out/bin/${targetPrefix}c++
    fi

    if [ -e $ccPath/${targetPrefix}cpp ]; then
      wrap ${targetPrefix}cpp $wrapper $ccPath/${targetPrefix}cpp
    elif [ -e $ccPath/cpp ]; then
      wrap ${targetPrefix}cpp $wrapper $ccPath/cpp
    fi
  ''

  # No need to wrap gnat, gnatkr, gnatname or gnatprep; we can just symlink them in
  + optionalString cc.langAda or false ''
    for cmd in gnatbind gnatchop gnatclean gnatlink gnatls gnatmake; do
      wrap ${targetPrefix}$cmd ${./gnat-wrapper.sh} $ccPath/${targetPrefix}$cmd
    done

    for cmd in gnat gnatkr gnatname gnatprep; do
      ln -s $ccPath/${targetPrefix}$cmd $out/bin/${targetPrefix}$cmd
    done

    # this symlink points to the unwrapped gnat's output "out". It is used by
    # our custom gprconfig compiler description to find GNAT's ada runtime. See
    # ../../development/ada-modules/gprbuild/{boot.nix, nixpkgs-gnat.xml}
    ln -sf ${cc} $out/nix-support/gprconfig-gnat-unwrapped
  ''

  + optionalString cc.langFortran or false ''
    wrap ${targetPrefix}gfortran $wrapper $ccPath/${targetPrefix}gfortran
    ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}g77
    ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}f77
    export named_fc=${targetPrefix}gfortran
  ''

  + optionalString cc.langGo or false ''
    wrap ${targetPrefix}gccgo $wrapper $ccPath/${targetPrefix}gccgo
    wrap ${targetPrefix}go ${./go-wrapper.sh} $ccPath/${targetPrefix}go
  '';

  strictDeps = true;
  propagatedBuildInputs = [
    bintools
  ]
  ++ extraTools;
  depsTargetTargetPropagated = optional (libcxx != null) libcxx ++ extraPackages;

  setupHooks = [
    ../setup-hooks/role.bash
  ]
  ++ optional (cc.langC or true) ./setup-hook.sh
  ++ optional (cc.langFortran or false) ./fortran-hook.sh
  ++ optional (targetPlatform.isWindows) (
    stdenvNoCC.mkDerivation {
      name = "win-dll-hook.sh";
      dontUnpack = true;
      installPhase = ''
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib" > $out
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib64" >> $out
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib32" >> $out
      '';
    }
  );

  postFixup =
    # Ensure flags files exists, as some other programs cat them. (That these
    # are considered an exposed interface is a bit dubious, but fine for now.)
    ''
      touch "$out/nix-support/cc-cflags"
      touch "$out/nix-support/cc-ldflags"
    ''

    # Backwards compatibility for packages expecting this file, e.g. with
    # `$NIX_CC/nix-support/dynamic-linker`.
    #
    # TODO(@Ericson2314): Remove this after stable release and force
    # everyone to refer to bintools-wrapper directly.
    + optionalString (!isArocc) ''
      if [[ -f "$bintools/nix-support/dynamic-linker" ]]; then
        ln -s "$bintools/nix-support/dynamic-linker" "$out/nix-support"
      fi
      if [[ -f "$bintools/nix-support/dynamic-linker-m32" ]]; then
        ln -s "$bintools/nix-support/dynamic-linker-m32" "$out/nix-support"
      fi
    ''

    ##
    ## GCC libs for non-GCC support
    ##
    + optionalString (useGccForLibs && isClang) ''

      echo "-B${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}" >> $out/nix-support/cc-cflags
    ''
    + optionalString (useGccForLibs && !isArocc) ''
      echo "-L${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}" >> $out/nix-support/cc-ldflags
      echo "-L${gccForLibs_solib}/lib" >> $out/nix-support/cc-ldflags
    ''

    # TODO We would like to connect this to `useGccForLibs`, but we cannot yet
    # because `libcxxStdenv` on linux still needs this. Maybe someday we'll
    # always set `useLLVM` on Darwin, and maybe also break down `useLLVM` into
    # fine-grained use flags (libgcc vs compiler-rt, ld.lld vs legacy, libc++
    # vs libstdc++, etc.) since Darwin isn't `useLLVM` on all counts. (See
    # https://clang.llvm.org/docs/Toolchain.html for all the axes one might
    # break `useLLVM` into.)
    +
      optionalString
        (
          isClang
          && targetPlatform.isLinux
          && !(targetPlatform.useAndroidPrebuilt or false)
          && !(targetPlatform.useLLVM or false)
          && gccForLibs != null
        )
        (
          ''
            echo "--gcc-toolchain=${gccForLibs}" >> $out/nix-support/cc-cflags

            # Pull in 'cc.out' target to get 'libstdc++fs.a'. It should be in
            # 'cc.lib'. But it's a gcc package bug.
            # TODO(trofi): remove once gcc is fixed to move libraries to .lib output.
            echo "-L${gccForLibs}/${
              optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}"
            }/lib" >> $out/nix-support/cc-ldflags
          ''
          # this ensures that when clang passes -lgcc_s to lld (as it does
          # when building e.g. firefox), lld is able to find libgcc_s.so
          + optionals (!isArocc) (
            concatMapStrings (libgcc: ''
              echo "-L${libgcc}/lib" >> $out/nix-support/cc-ldflags
            '') (toList (gccForLibs.libgcc or [ ]))
          )
        )

    ##
    ## General libc support
    ##

    # The "-B${libc_lib}/lib/" flag is a quick hack to force gcc to link
    # against the crt1.o from our own glibc, rather than the one in
    # /usr/lib.  (This is only an issue when using an `impure'
    # compiler/linker, i.e., one that searches /usr/lib and so on.)
    #
    # Unfortunately, setting -B appears to override the default search
    # path. Thus, the gcc-specific "../includes-fixed" directory is
    # now longer searched and glibc's <limits.h> header fails to
    # compile, because it uses "#include_next <limits.h>" to find the
    # limits.h file in ../includes-fixed. To remedy the problem,
    # another -idirafter is necessary to add that directory again.
    + optionalString (libc != null) (
      ''
        touch "$out/nix-support/libc-cflags"
        touch "$out/nix-support/libc-ldflags"
      ''
      + optionalString (!isArocc) ''
        echo "-B${libc_lib}${libc.libdir or "/lib/"}" >> $out/nix-support/libc-crt1-cflags
      ''
      + ''
        include "-${
          if isArocc then "I" else "idirafter"
        }" "${libc_dev}${libc.incdir or "/include"}" >> $out/nix-support/libc-cflags
      ''
      + optionalString isGNU ''
        for dir in "${cc}"/lib/gcc/*/*/include-fixed; do
          include '-idirafter' ''${dir} >> $out/nix-support/libc-cflags
        done
      ''
      + ''

        echo "${libc_lib}" > $out/nix-support/orig-libc
        echo "${libc_dev}" > $out/nix-support/orig-libc-dev
      ''
      # fortify-headers is a set of wrapper headers that augment libc
      # and use #include_next to pass through to libc's true
      # implementations, so must appear before them in search order.
      # in theory a correctly placed -idirafter could be used, but in
      # practice the compiler may have been built with a --with-headers
      # like option that forces the libc headers before all -idirafter,
      # hence -isystem here.
      + optionalString includeFortifyHeaders' ''
        include -isystem "${fortify-headers}/include" >> $out/nix-support/libc-cflags
      ''
    )

    ##
    ## General libc++ support
    ##

    # We have a libc++ directly, we have one via "smuggled" GCC, or we have one
    # bundled with the C compiler because it is GCC
    +
      optionalString
        (libcxx != null || (useGccForLibs && gccForLibs.langCC or false) || (isGNU && cc.langCC or false))
        ''
          touch "$out/nix-support/libcxx-cxxflags"
          touch "$out/nix-support/libcxx-ldflags"
        ''
    # Adding -isystem flags should be done only for clang; gcc
    # already knows how to find its own libstdc++, and adding
    # additional -isystem flags will confuse gfortran (see
    # https://github.com/NixOS/nixpkgs/pull/209870#issuecomment-1500550903)
    + optionalString (libcxx == null && isClang && (useGccForLibs && gccForLibs.langCC or false)) ''
      for dir in ${gccForLibs}/include/c++/*; do
        include -isystem "$dir" >> $out/nix-support/libcxx-cxxflags
      done
      for dir in ${gccForLibs}/include/c++/*/${targetPlatform.config}; do
        include -isystem "$dir" >> $out/nix-support/libcxx-cxxflags
      done
    ''
    + optionalString (libcxx.isLLVM or false) ''
      include -isystem "${getDev libcxx}/include/c++/v1" >> $out/nix-support/libcxx-cxxflags
      echo "-stdlib=libc++" >> $out/nix-support/libcxx-ldflags
    ''
    # GCC NG friendly libc++
    + optionalString (libcxx != null && libcxx.isGNU or false) ''
      include -isystem "${getDev libcxx}/include" >> $out/nix-support/libcxx-cxxflags
    ''

    ##
    ## Initial CFLAGS
    ##

    # GCC shows ${cc_solib}/lib in `gcc -print-search-dirs', but not
    # ${cc_solib}/lib64 (even though it does actually search there...)..
    # This confuses libtool.  So add it to the compiler tool search
    # path explicitly.
    + optionalString (!nativeTools && !isArocc) ''
      if [ -e "${cc_solib}/lib64" -a ! -L "${cc_solib}/lib64" ]; then
        ccLDFlags+=" -L${cc_solib}/lib64"
        ccCFlags+=" -B${cc_solib}/lib64"
      fi
      ccLDFlags+=" -L${cc_solib}/lib"
      ccCFlags+=" -B${cc_solib}/lib"

    ''
    + optionalString (cc.langAda or false && !isArocc) ''
      touch "$out/nix-support/gnat-cflags"
      touch "$out/nix-support/gnat-ldflags"
      basePath=$(echo $cc/lib/*/*/*)
      ccCFlags+=" -B$basePath -I$basePath/adainclude"
      gnatCFlags="-I$basePath/adainclude -I$basePath/adalib"

      echo "$gnatCFlags" >> $out/nix-support/gnat-cflags
    ''
    + ''
      echo "$ccLDFlags" >> $out/nix-support/cc-ldflags
      echo "$ccCFlags" >> $out/nix-support/cc-cflags
    ''
    + optionalString (targetPlatform.isDarwin && (libcxx != null) && (cc.isClang or false)) ''
      echo " -L${libcxx_solib}" >> $out/nix-support/cc-ldflags
    ''

    ## Prevent clang from seeing /usr/include. There is a desire to achieve this
    ## through alternate means because it breaks -sysroot and related functionality.
    #
    # This flag prevents global system header directories from
    # leaking through on non‐NixOS Linux. However, on macOS, the
    # SDK path is used as the sysroot, and forcing `-nostdlibinc`
    # breaks `-isysroot` with an unwrapped compiler. As macOS has
    # no `/usr/include`, there’s essentially no risk to dropping
    # the flag there. See discussion in NixOS/nixpkgs#191152.
    #
    +
      optionalString
        (
          (cc.isClang or false)
          && !(cc.isROCm or false)
          && !targetPlatform.isDarwin
          && !targetPlatform.isAndroid
        )
        ''
          echo " -nostdlibinc" >> $out/nix-support/cc-cflags
        ''

    ##
    ## Man page and info support
    ##
    + optionalString propagateDoc ''
      ln -s ${cc.man} $man
      ln -s ${cc.info} $info
    ''

    ##
    ## Hardening support
    ##
    + ''
      export hardening_unsupported_flags="${concatStringsSep " " ccHardeningUnsupportedFlags}"
    ''

    # Do not prevent omission of framepointers on x86 32bit due to the small
    # number of general purpose registers. Keeping EBP available provides
    # non-trivial performance benefits.
    # Also skip s390/s390x as it fails to build glibc and causes
    # performance regressions:
    #   https://bugs.launchpad.net/ubuntu-z-systems/+bug/2064538
    #   https://github.com/NixOS/nixpkgs/issues/428260
    + (
      let
        enable_fp = !targetPlatform.isx86_32 && !targetPlatform.isS390;
        enable_leaf_fp =
          enable_fp
          && (
            targetPlatform.isx86_64
            || targetPlatform.isAarch64
            || (targetPlatform.isRiscV && (!isGNU || versionAtLeast ccVersion "15.1"))
          );
      in
      optionalString enable_fp ''
        echo " -fno-omit-frame-pointer ${optionalString enable_leaf_fp "-mno-omit-leaf-frame-pointer "}" >> $out/nix-support/cc-cflags-before
      ''
    )

    # For clang, this is handled in add-clang-cc-cflags-before.sh
    + optionalString (!isClang && machineFlags != [ ]) ''
      printf "%s\n" ${lib.escapeShellArgs machineFlags} >> $out/nix-support/cc-cflags-before
    ''

    # TODO: categorize these and figure out a better place for them
    + optionalString targetPlatform.isWindows ''
      hardening_unsupported_flags+=" pic"
    ''
    + optionalString targetPlatform.isMinGW ''
      hardening_unsupported_flags+=" stackprotector fortify"
    ''
    + optionalString targetPlatform.isAvr ''
      hardening_unsupported_flags+=" stackprotector pic"
    ''
    + optionalString (targetPlatform.libc == "newlib" || targetPlatform.libc == "newlib-nano") ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    ''
    + optionalString (targetPlatform.libc == "musl" && targetPlatform.isx86_32) ''
      hardening_unsupported_flags+=" stackprotector"
    ''
    + optionalString targetPlatform.isNetBSD ''
      hardening_unsupported_flags+=" stackprotector fortify"
    ''
    + optionalString cc.langAda or false ''
      hardening_unsupported_flags+=" format stackprotector strictoverflow"
    ''
    + optionalString cc.langFortran or false ''
      hardening_unsupported_flags+=" format"
    ''
    + optionalString cc.langGo or false ''
      hardening_unsupported_flags+=" format"
    ''
    + optionalString targetPlatform.isWasm ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    ''
    + optionalString targetPlatform.isMicroBlaze ''
      hardening_unsupported_flags+=" stackprotector"
    ''

    + optionalString (libc != null && targetPlatform.isAvr && !isArocc) ''
      for isa in avr5 avr3 avr4 avr6 avr25 avr31 avr35 avr51 avrxmega2 avrxmega4 avrxmega5 avrxmega6 avrxmega7 tiny-stack; do
        echo "-B${getLib libc}/avr/lib/$isa" >> $out/nix-support/libc-crt1-cflags
      done
    ''

    + optionalString targetPlatform.isAndroid ''
      echo "-D__ANDROID_API__=${targetPlatform.androidSdkVersion}" >> $out/nix-support/cc-cflags
    ''

    # There are a few tools (to name one libstdcxx5) which do not work
    # well with multi line flags, so make the flags single line again
    + ''
      for flags in "$out/nix-support"/*flags*; do
        substituteInPlace "$flags" --replace $'\n' ' '
      done

      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${./add-hardening.sh} $out/nix-support/add-hardening.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash
      substituteAll ${../wrapper-common/darwin-sdk-setup.bash} $out/nix-support/darwin-sdk-setup.bash
    ''

    + optionalString cc.langAda or false ''
      substituteAll ${./add-gnat-extra-flags.sh} $out/nix-support/add-gnat-extra-flags.sh
    ''

    ##
    ## General Clang support
    ## Needs to go after ^ because the for loop eats \n and makes this file an invalid script
    ##
    + optionalString isClang (
      let
        hasUnsupportedGnuSuffix = hasPrefix "gnuabielfv" targetPlatform.parsed.abi.name;
        clangCompatibleConfig =
          if hasUnsupportedGnuSuffix then
            removeSuffix (removePrefix "gnu" targetPlatform.parsed.abi.name) targetPlatform.config
          else
            targetPlatform.config;
        explicitAbiValue = if hasUnsupportedGnuSuffix then targetPlatform.parsed.abi.abi else "";
      in
      ''
        # Escape twice: once for this script, once for the one it gets substituted into.
        export machineFlags=${escapeShellArg (escapeShellArgs machineFlags)}
        export defaultTarget=${clangCompatibleConfig}
        export explicitAbiValue=${explicitAbiValue}
        substituteAll ${./add-clang-cc-cflags-before.sh} $out/nix-support/add-local-cc-cflags-before.sh
      ''
    )

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands
    + concatStringsSep "; " (
      mapAttrsToList (name: value: "echo ${toString value} >> $out/nix-support/${name}") nixSupport
    );

  env = {
    inherit isClang;

    # for substitution in utils.bash
    # TODO(@sternenseemann): invent something cleaner than passing in "" in case of absence
    expandResponseParams = lib.optionalString (expand-response-params != "") (
      lib.getExe expand-response-params
    );
    # TODO(@sternenseemann): rename env var via stdenv rebuild
    shell = getBin runtimeShell + runtimeShell.shellPath or "";
    gnugrep_bin = optionalString (!nativeTools) gnugrep;
    rm = if nativeTools then "rm" else lib.getExe' coreutils "rm";
    mktemp = if nativeTools then "mktemp" else lib.getExe' coreutils "mktemp";
    # stdenv.cc.cc should not be null and we have nothing better for now.
    # if the native impure bootstrap is gotten rid of this can become `inherit cc;` again.
    cc = optionalString (!nativeTools) cc;
    wrapperName = "CC_WRAPPER";
    inherit suffixSalt coreutils_bin bintools;
    inherit libc_bin libc_dev libc_lib;
    inherit darwinPlatformForCC;
    default_hardening_flags_str = builtins.toString defaultHardeningFlags;
    inherit useMacroPrefixMap;
  }
  // lib.mapAttrs (_: lib.optionalString targetPlatform.isDarwin) {
    # These will become empty strings when not targeting Darwin.
    inherit (targetPlatform) darwinMinVersion darwinMinVersionVariable;
  }
  // lib.optionalAttrs (stdenvNoCC.targetPlatform.isDarwin && apple-sdk != null) {
    # Wrapped compilers should do something useful even when no SDK is provided at `DEVELOPER_DIR`.
    fallback_sdk = apple-sdk.__spliced.buildTarget or apple-sdk;
  };

  meta =
    let
      cc_ = optionalAttrs (cc != null) cc;
    in
    (optionalAttrs (cc_ ? meta) (removeAttrs cc.meta [ "priority" ]))
    // {
      description = attrByPath [ "meta" "description" ] "System C compiler" cc_ + " (wrapper script)";
      priority = 10;
      mainProgram = if name != "" then name else "${targetPrefix}${ccName}";
    };
}
