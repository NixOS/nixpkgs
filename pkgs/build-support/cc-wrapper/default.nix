# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? ""
, lib
, stdenvNoCC
, cc ? null, libc ? null, bintools, coreutils ? null, shell ? stdenvNoCC.shell
, zlib ? null
, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, propagateDoc ? cc != null && cc ? man
, extraTools ? [], extraPackages ? [], extraBuildCommands ? ""
, nixSupport ? {}
, isGNU ? false, isClang ? cc.isClang or false, isCcache ? cc.isCcache or false, gnugrep ? null
, buildPackages ? {}
, libcxx ? null

# Whether or not to add `-B` and `-L` to `nix-support/cc-{c,ld}flags`
, useCcForLibs ?

  # Always add these flags for Clang, because in order to compile (most
  # software) it needs libraries that are shipped and compiled with gcc.
  if isClang then true

  # Never add these flags for a build!=host cross-compiler or a host!=target
  # ("cross-built-native") compiler; currently nixpkgs has a special build
  # path for these (`crossStageStatic`).  Hopefully at some point that build
  # path will be merged with this one and this conditional will be removed.
  else if (with stdenvNoCC; buildPlatform != hostPlatform || hostPlatform != targetPlatform) then false

  # Never add these flags when wrapping the bootstrapFiles' compiler; it has a
  # /usr/-like layout with everything smashed into a single outpath, so it has
  # no trouble finding its own libraries.
  else if (cc.passthru.isFromBootstrapFiles or false) then false

  # Add these flags when wrapping `xgcc` (the first compiler that nixpkgs builds)
  else if (cc.passthru.isXgcc or false) then true

  # Add these flags when wrapping `stdenv.cc`
  else if (cc.stdenv.cc.cc.passthru.isXgcc or false) then true

  # Do not add these flags in any other situation.  This is `false` mainly to
  # prevent these flags from being added when wrapping *old* versions of gcc
  # (e.g. `gcc6Stdenv`), since they will cause the old gcc to get `-B` and
  # `-L` flags pointing at the new gcc's libstdc++ headers.  Example failure:
  # https://hydra.nixos.org/build/213125495
  else false

# the derivation at which the `-B` and `-L` flags added by `useCcForLibs` will point
, gccForLibs ? if useCcForLibs then cc else null
, fortify-headers ? null
, includeFortifyHeaders ? null
}:

with lib;

assert nativeTools -> !propagateDoc && nativePrefix != "";
assert !nativeTools ->
  cc != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

let
  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  includeFortifyHeaders' = if includeFortifyHeaders != null
    then includeFortifyHeaders
    else (targetPlatform.libc == "musl" && isGNU);

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform)
                                           (targetPlatform.config + "-");

  ccVersion = lib.getVersion cc;
  ccName = lib.removePrefix targetPrefix (lib.getName cc);

  libc_bin = optionalString (libc != null) (getBin libc);
  libc_dev = optionalString (libc != null) (getDev libc);
  libc_lib = optionalString (libc != null) (getLib libc);
  cc_solib = getLib cc
    + optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}";

  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = optionalString (!nativeTools) (getBin coreutils);

  # The "suffix salt" is a arbitrary string added in the end of env vars
  # defined by cc-wrapper's hooks so that multiple cc-wrappers can be used
  # without interfering. For the moment, it is defined as the target triple,
  # adjusted to be a valid bash identifier. This should be considered an
  # unstable implementation detail, however.
  suffixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

  expand-response-params =
    lib.optionalString ((buildPackages.stdenv.hasCC or false) && buildPackages.stdenv.cc != "/dev/null") (import ../expand-response-params { inherit (buildPackages) stdenv; });

  useGccForLibs = useCcForLibs
    && libcxx == null
    && !stdenv.targetPlatform.isDarwin
    && !(stdenv.targetPlatform.useLLVM or false)
    && !(stdenv.targetPlatform.useAndroidPrebuilt or false)
    && !(stdenv.targetPlatform.isiOS or false)
    && gccForLibs != null;
  gccForLibs_solib = getLib gccForLibs
    + optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}";

  # Analogously to cc_solib and gccForLibs_solib
  libcxx_solib = "${lib.getLib libcxx}/lib";

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

  isGccArchSupported = arch:
    if targetPlatform.isPower then false else # powerpc does not allow -march=
    if isGNU then
      { # Generic
        x86-64-v2 = versionAtLeast ccVersion "11.0";
        x86-64-v3 = versionAtLeast ccVersion "11.0";
        x86-64-v4 = versionAtLeast ccVersion "11.0";

        # Intel
        skylake        = versionAtLeast ccVersion "6.0";
        skylake-avx512 = versionAtLeast ccVersion "6.0";
        cannonlake     = versionAtLeast ccVersion "8.0";
        icelake-client = versionAtLeast ccVersion "8.0";
        icelake-server = versionAtLeast ccVersion "8.0";
        cascadelake    = versionAtLeast ccVersion "9.0";
        cooperlake     = versionAtLeast ccVersion "10.0";
        tigerlake      = versionAtLeast ccVersion "10.0";
        knm            = versionAtLeast ccVersion "8.0";
        alderlake      = versionAtLeast ccVersion "12.0";

        # AMD
        znver1         = versionAtLeast ccVersion "6.0";
        znver2         = versionAtLeast ccVersion "9.0";
        znver3         = versionAtLeast ccVersion "11.0";
        znver4         = versionAtLeast ccVersion "13.0";
      }.${arch} or true
    else if isClang then
      { #Generic
        x86-64-v2 = versionAtLeast ccVersion "12.0";
        x86-64-v3 = versionAtLeast ccVersion "12.0";
        x86-64-v4 = versionAtLeast ccVersion "12.0";

        # Intel
        cannonlake     = versionAtLeast ccVersion "5.0";
        icelake-client = versionAtLeast ccVersion "7.0";
        icelake-server = versionAtLeast ccVersion "7.0";
        knm            = versionAtLeast ccVersion "7.0";
        alderlake      = versionAtLeast ccVersion "16.0";

        # AMD
        znver1         = versionAtLeast ccVersion "4.0";
        znver2         = versionAtLeast ccVersion "9.0";
        znver3         = versionAtLeast ccVersion "12.0";
        znver4         = versionAtLeast ccVersion "16.0";
      }.${arch} or true
    else
      false;

  isGccTuneSupported = tune:
    # for x86 -mtune= takes the same values as -march, plus two more:
    if targetPlatform.isx86 then
      {
        generic = true;
        intel = true;
      }.${tune} or (isGccArchSupported tune)
    # on arm64, the -mtune= values are specific processors
    else if targetPlatform.isAarch64 then
      (if isGNU then
        {
          cortex-a53              = versionAtLeast ccVersion "4.8";  # gcc 8c075f
          cortex-a72              = versionAtLeast ccVersion "5.1";  # gcc d8f70d
          "cortex-a72.cortex-a53" = versionAtLeast ccVersion "5.1";  # gcc d8f70d
        }.${tune} or false
       else if isClang then
         {
           cortex-a53             = versionAtLeast ccVersion "3.9"; # llvm dfc5d1
         }.${tune} or false
       else false)
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
  findBestTuneApproximation = tune:
    let guess = if isClang
                then {
                  # clang does not tune for big.LITTLE chips
                  "cortex-a72.cortex-a53" = "cortex-a72";
                }.${tune} or tune
                else tune;
    in if isGccTuneSupported guess
       then guess
       else null;

  defaultHardeningFlags = bintools.defaultHardeningFlags or [];

  darwinPlatformForCC = optionalString stdenv.targetPlatform.isDarwin (
    if (targetPlatform.darwinPlatform == "macos" && isGNU) then "macosx"
    else targetPlatform.darwinPlatform
  );

  darwinMinVersion = optionalString stdenv.targetPlatform.isDarwin (
    stdenv.targetPlatform.darwinMinVersion
  );

  darwinMinVersionVariable = optionalString stdenv.targetPlatform.isDarwin
    stdenv.targetPlatform.darwinMinVersionVariable;
in

assert includeFortifyHeaders' -> fortify-headers != null;

# Ensure bintools matches
assert libc_bin == bintools.libc_bin;
assert libc_dev == bintools.libc_dev;
assert libc_lib == bintools.libc_lib;
assert nativeTools == bintools.nativeTools;
assert nativeLibc == bintools.nativeLibc;
assert nativePrefix == bintools.nativePrefix;

stdenv.mkDerivation {
  pname = targetPrefix
    + (if name != "" then name else "${ccName}-wrapper");
  version = optionalString (cc != null) ccVersion;

  preferLocalBuild = true;

  outputs = [ "out" ] ++ optionals propagateDoc [ "man" "info" ];

  passthru = {
    inherit targetPrefix suffixSalt;
    # "cc" is the generic name for a C compiler, but there is no one for package
    # providing the linker and related tools. The two we use now are GNU
    # Binutils, and Apple's "cctools"; "bintools" as an attempt to find an
    # unused middle-ground name that evokes both.
    inherit bintools;
    inherit cc libc libcxx nativeTools nativeLibc nativePrefix isGNU isClang;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/include"))
            (setenv "NIX_CFLAGS_COMPILE_${suffixSalt}" (concat (getenv "NIX_CFLAGS_COMPILE_${suffixSalt}") " -isystem " arg "/include"))))
        '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';

    inherit expand-response-params;

    inherit nixSupport;

    inherit defaultHardeningFlags;
  };

  dontBuild = true;
  dontConfigure = true;
  enableParallelBuilding = true;

  unpackPhase = ''
    src=$PWD
  '';

  wrapper = ./cc-wrapper.sh;

  installPhase =
    ''
      mkdir -p $out/bin $out/nix-support

      wrap() {
        local dst="$1"
        local wrapper="$2"
        export prog="$3"
        export use_response_file_by_default=${if isClang && !isCcache then "1" else "0"}
        substituteAll "$wrapper" "$out/bin/$dst"
        chmod +x "$out/bin/$dst"
      }
    ''

    + (if nativeTools then ''
      echo ${if targetPlatform.isDarwin then cc else nativePrefix} > $out/nix-support/orig-cc

      ccPath="${if targetPlatform.isDarwin then cc else nativePrefix}/bin"
    '' else ''
      echo $cc > $out/nix-support/orig-cc

      ccPath="${cc}/bin"
    '')

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
      # ../../development/tools/build-managers/gprbuild/{boot.nix, nixpkgs-gnat.xml}
      ln -sf ${cc} $out/nix-support/gprconfig-gnat-unwrapped
    ''

    + optionalString cc.langD or false ''
      wrap ${targetPrefix}gdc $wrapper $ccPath/${targetPrefix}gdc
    ''

    + optionalString cc.langFortran or false ''
      wrap ${targetPrefix}gfortran $wrapper $ccPath/${targetPrefix}gfortran
      ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}g77
      ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}f77
      export named_fc=${targetPrefix}gfortran
    ''

    + optionalString cc.langJava or false ''
      wrap ${targetPrefix}gcj $wrapper $ccPath/${targetPrefix}gcj
    ''

    + optionalString cc.langGo or false ''
      wrap ${targetPrefix}gccgo $wrapper $ccPath/${targetPrefix}gccgo
      wrap ${targetPrefix}go ${./go-wrapper.sh} $ccPath/${targetPrefix}go
    '';

  strictDeps = true;
  propagatedBuildInputs = [ bintools ] ++ extraTools ++ optionals cc.langD or cc.langJava or false [ zlib ];
  depsTargetTargetPropagated = optional (libcxx != null) libcxx ++ extraPackages;

  setupHooks = [
    ../setup-hooks/role.bash
  ] ++ lib.optional (cc.langC or true) ./setup-hook.sh
    ++ lib.optional (cc.langFortran or false) ./fortran-hook.sh
    ++ lib.optional (targetPlatform.isWindows) (stdenv.mkDerivation {
      name = "win-dll-hook.sh";
      dontUnpack = true;
      installPhase = ''
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib" > $out
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib64" >> $out
        echo addToSearchPath "LINK_DLL_FOLDERS" "${cc_solib}/lib32" >> $out
      '';
    });

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
    + ''
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
    + optionalString useGccForLibs ''
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
    + optionalString (isClang
                      && targetPlatform.isLinux
                      && !(stdenv.targetPlatform.useAndroidPrebuilt or false)
                      && !(stdenv.targetPlatform.useLLVM or false)
                      && gccForLibs != null) (''
      echo "--gcc-toolchain=${gccForLibs}" >> $out/nix-support/cc-cflags

      # Pull in 'cc.out' target to get 'libstdc++fs.a'. It should be in
      # 'cc.lib'. But it's a gcc package bug.
      # TODO(trofi): remove once gcc is fixed to move libraries to .lib output.
      echo "-L${gccForLibs}/${optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}"}/lib" >> $out/nix-support/cc-ldflags
    ''
    # this ensures that when clang passes -lgcc_s to lld (as it does
    # when building e.g. firefox), lld is able to find libgcc_s.so
    + concatMapStrings (libgcc: ''
      echo "-L${libgcc}/lib" >> $out/nix-support/cc-ldflags
    '') (lib.toList (gccForLibs.libgcc or [])))

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
    + optionalString (libc != null) (''
      touch "$out/nix-support/libc-cflags"
      touch "$out/nix-support/libc-ldflags"
      echo "-B${libc_lib}${libc.libdir or "/lib/"}" >> $out/nix-support/libc-crt1-cflags
    '' + optionalString (!(cc.langD or false)) ''
      echo "-idirafter ${libc_dev}${libc.incdir or "/include"}" >> $out/nix-support/libc-cflags
    '' + optionalString (isGNU && (!(cc.langD or false))) ''
      for dir in "${cc}"/lib/gcc/*/*/include-fixed; do
        echo '-idirafter' ''${dir} >> $out/nix-support/libc-cflags
      done
    '' + ''

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
      echo "-isystem ${fortify-headers}/include" >> $out/nix-support/libc-cflags
    '')

    ##
    ## General libc++ support
    ##

    # We have a libc++ directly, we have one via "smuggled" GCC, or we have one
    # bundled with the C compiler because it is GCC
    + optionalString (libcxx != null || (useGccForLibs && gccForLibs.langCC or false) || (isGNU && cc.langCC or false)) ''
      touch "$out/nix-support/libcxx-cxxflags"
      touch "$out/nix-support/libcxx-ldflags"
    ''
    # Adding -isystem flags should be done only for clang; gcc
    # already knows how to find its own libstdc++, and adding
    # additional -isystem flags will confuse gfortran (see
    # https://github.com/NixOS/nixpkgs/pull/209870#issuecomment-1500550903)
    + optionalString (libcxx == null && isClang && (useGccForLibs && gccForLibs.langCC or false)) ''
      for dir in ${gccForLibs}/include/c++/*; do
        echo "-isystem $dir" >> $out/nix-support/libcxx-cxxflags
      done
      for dir in ${gccForLibs}/include/c++/*/${targetPlatform.config}; do
        echo "-isystem $dir" >> $out/nix-support/libcxx-cxxflags
      done
    ''
    + optionalString (libcxx.isLLVM or false) ''
      echo "-isystem ${lib.getDev libcxx}/include/c++/v1" >> $out/nix-support/libcxx-cxxflags
      echo "-isystem ${lib.getDev libcxx.cxxabi}/include/c++/v1" >> $out/nix-support/libcxx-cxxflags
      echo "-stdlib=libc++" >> $out/nix-support/libcxx-ldflags
      echo "-l${libcxx.cxxabi.libName}" >> $out/nix-support/libcxx-ldflags
    ''

    ##
    ## Initial CFLAGS
    ##

    # GCC shows ${cc_solib}/lib in `gcc -print-search-dirs', but not
    # ${cc_solib}/lib64 (even though it does actually search there...)..
    # This confuses libtool.  So add it to the compiler tool search
    # path explicitly.
    + optionalString (!nativeTools) ''
      if [ -e "${cc_solib}/lib64" -a ! -L "${cc_solib}/lib64" ]; then
        ccLDFlags+=" -L${cc_solib}/lib64"
        ccCFlags+=" -B${cc_solib}/lib64"
      fi
      ccLDFlags+=" -L${cc_solib}/lib"
      ccCFlags+=" -B${cc_solib}/lib"

    '' + optionalString cc.langAda or false ''
      touch "$out/nix-support/gnat-cflags"
      touch "$out/nix-support/gnat-ldflags"
      basePath=$(echo $cc/lib/*/*/*)
      ccCFlags+=" -B$basePath -I$basePath/adainclude"
      gnatCFlags="-I$basePath/adainclude -I$basePath/adalib"

      echo "$gnatCFlags" >> $out/nix-support/gnat-cflags
    '' + ''
      echo "$ccLDFlags" >> $out/nix-support/cc-ldflags
      echo "$ccCFlags" >> $out/nix-support/cc-cflags
    '' + optionalString (targetPlatform.isDarwin && (libcxx != null) && (cc.isClang or false)) ''
      echo " -L${libcxx_solib}" >> $out/nix-support/cc-ldflags
    ''

    ##
    ## Man page and info support
    ##
    + optionalString propagateDoc ''
      ln -s ${cc.man} $man
      ln -s ${cc.info} $info
    '' + optionalString (cc.langD or cc.langJava or false) ''
      echo "-B${zlib}${zlib.libdir or "/lib/"}" >> $out/nix-support/libc-cflags
    ''

    ##
    ## Hardening support
    ##
    + ''
      export hardening_unsupported_flags="${builtins.concatStringsSep " " (cc.hardeningUnsupportedFlags or [])}"
    ''

    # Machine flags. These are necessary to support

    # TODO: We should make a way to support miscellaneous machine
    # flags and other gcc flags as well.

    # Always add -march based on cpu in triple. Sometimes there is a
    # discrepency (x86_64 vs. x86-64), so we provide an "arch" arg in
    # that case.
    # TODO: aarch64-darwin has mcpu incompatible with gcc
    + optionalString ((targetPlatform ? gcc.arch) && (isClang || !(stdenv.isDarwin && stdenv.isAarch64)) &&
                      isGccArchSupported targetPlatform.gcc.arch) ''
      echo "-march=${targetPlatform.gcc.arch}" >> $out/nix-support/cc-cflags-before
    ''

    # -mcpu is not very useful, except on PowerPC where it is used
    # instead of march. On all other platforms you should use mtune
    # and march instead.
    # TODO: aarch64-darwin has mcpu incompatible with gcc
    + optionalString ((targetPlatform ? gcc.cpu) && (isClang || !(stdenv.isDarwin && stdenv.isAarch64))) ''
      echo "-mcpu=${targetPlatform.gcc.cpu}" >> $out/nix-support/cc-cflags-before
    ''

    # -mfloat-abi only matters on arm32 but we set it here
    # unconditionally just in case. If the abi specifically sets hard
    # vs. soft floats we use it here.
    + optionalString (targetPlatform ? gcc.float-abi) ''
      echo "-mfloat-abi=${targetPlatform.gcc.float-abi}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? gcc.fpu) ''
      echo "-mfpu=${targetPlatform.gcc.fpu}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? gcc.mode) ''
      echo "-mmode=${targetPlatform.gcc.mode}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? gcc.thumb) ''
      echo "-m${if targetPlatform.gcc.thumb then "thumb" else "arm"}" >> $out/nix-support/cc-cflags-before
    ''
    + (let tune = if targetPlatform ? gcc.tune
                  then findBestTuneApproximation targetPlatform.gcc.tune
                  else null;
      in optionalString (tune != null) ''
      echo "-mtune=${tune}" >> $out/nix-support/cc-cflags-before
    '')

    # TODO: categorize these and figure out a better place for them
    + optionalString targetPlatform.isWindows ''
      hardening_unsupported_flags+=" pic"
    '' + optionalString targetPlatform.isMinGW ''
      hardening_unsupported_flags+=" stackprotector fortify"
    '' + optionalString targetPlatform.isAvr ''
      hardening_unsupported_flags+=" stackprotector pic"
    '' + optionalString (targetPlatform.libc == "newlib" || targetPlatform.libc == "newlib-nano") ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    '' + optionalString (targetPlatform.libc == "musl" && targetPlatform.isx86_32) ''
      hardening_unsupported_flags+=" stackprotector"
    '' + optionalString targetPlatform.isNetBSD ''
      hardening_unsupported_flags+=" stackprotector fortify"
    '' + optionalString cc.langAda or false ''
      hardening_unsupported_flags+=" format stackprotector strictoverflow"
    '' + optionalString cc.langD or false ''
      hardening_unsupported_flags+=" format"
    '' + optionalString cc.langFortran or false ''
      hardening_unsupported_flags+=" format"
    '' + optionalString targetPlatform.isWasm ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    '' + optionalString targetPlatform.isMicroBlaze ''
      hardening_unsupported_flags+=" stackprotector"
    ''

    + optionalString stdenv.targetPlatform.isDarwin ''
        echo "-arch ${targetPlatform.darwinArch}" >> $out/nix-support/cc-cflags
    ''

    + optionalString targetPlatform.isAndroid ''
      echo "-D__ANDROID_API__=${targetPlatform.sdkVer}" >> $out/nix-support/cc-cflags
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
    ''

    + optionalString cc.langAda or false ''
      substituteAll ${./add-gnat-extra-flags.sh} $out/nix-support/add-gnat-extra-flags.sh
    ''

    ##
    ## General Clang support
    ## Needs to go after ^ because the for loop eats \n and makes this file an invalid script
    ##
    + optionalString isClang ''
      export defaultTarget=${targetPlatform.config}
      substituteAll ${./add-clang-cc-cflags-before.sh} $out/nix-support/add-local-cc-cflags-before.sh
    ''

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands
    + lib.strings.concatStringsSep "; "
      (lib.attrsets.mapAttrsToList
        (name: value: "echo ${toString value} >> $out/nix-support/${name}")
        nixSupport);


  env = {
    inherit isClang;

    # for substitution in utils.bash
    expandResponseParams = "${expand-response-params}/bin/expand-response-params";
    shell = getBin shell + shell.shellPath or "";
    gnugrep_bin = optionalString (!nativeTools) gnugrep;
    # stdenv.cc.cc should not be null and we have nothing better for now.
    # if the native impure bootstrap is gotten rid of this can become `inherit cc;` again.
    cc = optionalString (!nativeTools) cc;
    wrapperName = "CC_WRAPPER";
    inherit suffixSalt coreutils_bin bintools;
    inherit libc_bin libc_dev libc_lib;
    inherit darwinPlatformForCC darwinMinVersion darwinMinVersionVariable;
    default_hardening_flags_str = builtins.toString defaultHardeningFlags;
  };

  meta =
    let cc_ = lib.optionalAttrs (cc != null) cc; in
    (lib.optionalAttrs (cc_ ? meta) (removeAttrs cc.meta ["priority"])) //
    { description =
        lib.attrByPath ["meta" "description"] "System C compiler" cc_
        + " (wrapper script)";
      priority = 10;
      mainProgram = if name != "" then name else ccName;
  };
}
