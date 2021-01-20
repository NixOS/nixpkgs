# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? ""
, stdenvNoCC
, cc ? null, libc ? null, bintools, coreutils ? null, shell ? stdenvNoCC.shell
, gccForLibs ? null
, zlib ? null
, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, propagateDoc ? cc != null && cc ? man
, extraTools ? [], extraPackages ? [], extraBuildCommands ? ""
, isGNU ? false, isClang ? cc.isClang or false, gnugrep ? null
, buildPackages ? {}
, libcxx ? null
}:

with stdenvNoCC.lib;

assert nativeTools -> !propagateDoc && nativePrefix != "";
assert !nativeTools ->
  cc != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

let
  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = stdenv.lib.optionalString (targetPlatform != hostPlatform)
                                           (targetPlatform.config + "-");

  ccVersion = stdenv.lib.getVersion cc;
  ccName = stdenv.lib.removePrefix targetPrefix (stdenv.lib.getName cc);

  libc_bin = if libc == null then null else getBin libc;
  libc_dev = if libc == null then null else getDev libc;
  libc_lib = if libc == null then null else getLib libc;
  cc_solib = getLib cc
    + optionalString (targetPlatform != hostPlatform) "/${targetPlatform.config}";

  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = if nativeTools then "" else getBin coreutils;

  # The "suffix salt" is a arbitrary string added in the end of env vars
  # defined by cc-wrapper's hooks so that multiple cc-wrappers can be used
  # without interfering. For the moment, it is defined as the target triple,
  # adjusted to be a valid bash identifier. This should be considered an
  # unstable implementation detail, however.
  suffixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

  expand-response-params =
    if (buildPackages.stdenv.hasCC or false) && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

  useGccForLibs = isClang
    && libcxx == null
    && !(stdenv.targetPlatform.useLLVM or false)
    && !(stdenv.targetPlatform.useAndroidPrebuilt or false)
    && gccForLibs != null;

  # older compilers (for example bootstrap's GCC 5) fail with -march=too-modern-cpu
  isGccArchSupported = arch:
    if isGNU then
      { # Intel
        skylake        = versionAtLeast ccVersion "6.0";
        skylake-avx512 = versionAtLeast ccVersion "6.0";
        cannonlake     = versionAtLeast ccVersion "8.0";
        icelake-client = versionAtLeast ccVersion "8.0";
        icelake-server = versionAtLeast ccVersion "8.0";
        cascadelake    = versionAtLeast ccVersion "9.0";
        cooperlake     = versionAtLeast ccVersion "10.0";
        tigerlake      = versionAtLeast ccVersion "10.0";
        knm            = versionAtLeast ccVersion "8.0";
        # AMD
        znver1         = versionAtLeast ccVersion "6.0";
        znver2         = versionAtLeast ccVersion "9.0";
        znver3         = versionAtLeast ccVersion "11.0";
      }.${arch} or true
    else if isClang then
      { # Intel
        cannonlake     = versionAtLeast ccVersion "5.0";
        icelake-client = versionAtLeast ccVersion "7.0";
        icelake-server = versionAtLeast ccVersion "7.0";
        knm            = versionAtLeast ccVersion "7.0";
        # AMD
        znver1         = versionAtLeast ccVersion "4.0";
        znver2         = versionAtLeast ccVersion "9.0";
      }.${arch} or true
    else
      false;

in

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
  version = if cc == null then null else ccVersion;

  preferLocalBuild = true;

  inherit cc libc_bin libc_dev libc_lib bintools coreutils_bin;
  shell = getBin shell + shell.shellPath or "";
  gnugrep_bin = if nativeTools then "" else gnugrep;

  inherit targetPrefix suffixSalt;

  outputs = [ "out" ] ++ optionals propagateDoc [ "man" "info" ];

  passthru = {
    # "cc" is the generic name for a C compiler, but there is no one for package
    # providing the linker and related tools. The two we use now are GNU
    # Binutils, and Apple's "cctools"; "bintools" as an attempt to find an
    # unused middle-ground name that evokes both.
    inherit bintools;
    inherit libc nativeTools nativeLibc nativePrefix isGNU isClang;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/include"))
            (setenv "NIX_CFLAGS_COMPILE_${suffixSalt}" (concat (getenv "NIX_CFLAGS_COMPILE_${suffixSalt}") " -isystem " arg "/include"))))
        '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';
  };

  dontBuild = true;
  dontConfigure = true;

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

      if [ -e $ccPath/cpp ]; then
        wrap ${targetPrefix}cpp $wrapper $ccPath/cpp
      fi
    ''

    + optionalString cc.langAda or false ''
      wrap ${targetPrefix}gnatmake ${./gnat-wrapper.sh} $ccPath/${targetPrefix}gnatmake
      wrap ${targetPrefix}gnatbind ${./gnat-wrapper.sh} $ccPath/${targetPrefix}gnatbind
      wrap ${targetPrefix}gnatlink ${./gnat-wrapper.sh} $ccPath/${targetPrefix}gnatlink
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
    '';

  strictDeps = true;
  propagatedBuildInputs = [ bintools ] ++ extraTools ++ optionals cc.langD or false [ zlib ];
  depsTargetTargetPropagated = optional (libcxx != null) libcxx ++ extraPackages;

  wrapperName = "CC_WRAPPER";

  setupHooks = [
    ../setup-hooks/role.bash
  ] ++ stdenv.lib.optional (cc.langC or true) ./setup-hook.sh
    ++ stdenv.lib.optional (cc.langFortran or false) ./fortran-hook.sh;

  postFixup =
    # Ensure flags files exists, as some other programs cat them. (That these
    # are considered an exposed interface is a bit dubious, but fine for now.)
    ''
      touch "$out/nix-support/cc-cflags"
      touch "$out/nix-support/cc-ldflags"
    ''

    # Backwards compatability for packages expecting this file, e.g. with
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
    ## General Clang support
    ##
    + optionalString isClang ''

      echo "-target ${targetPlatform.config}" >> $out/nix-support/cc-cflags
    ''

    ##
    ## GCC libs for non-GCC support
    ##
    + optionalString useGccForLibs ''

      echo "-B${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}" >> $out/nix-support/cc-cflags
      echo "-L${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}" >> $out/nix-support/cc-ldflags
      echo "-L${gccForLibs.lib}/${targetPlatform.config}/lib" >> $out/nix-support/cc-ldflags
    ''

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
    + optionalString (libcxx == null && (useGccForLibs && gccForLibs.langCC or false)) ''
      for dir in ${gccForLibs}/include/c++/*; do
        echo "-isystem $dir" >> $out/nix-support/libcxx-cxxflags
      done
      for dir in ${gccForLibs}/include/c++/*/${targetPlatform.config}; do
        echo "-isystem $dir" >> $out/nix-support/libcxx-cxxflags
      done
    ''
    + optionalString (libcxx.isLLVM or false) (''
      echo "-isystem ${libcxx}/include/c++/v1" >> $out/nix-support/libcxx-cxxflags
      echo "-stdlib=libc++" >> $out/nix-support/libcxx-ldflags
    '' + stdenv.lib.optionalString stdenv.targetPlatform.isLinux ''
      echo "-lc++abi" >> $out/nix-support/libcxx-ldflags
    '')

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
      echo " -L${libcxx}/lib" >> $out/nix-support/cc-ldflags
    ''

    ##
    ## Man page and info support
    ##
    + optionalString propagateDoc ''
      ln -s ${cc.man} $man
      ln -s ${cc.info} $info
    '' + optionalString (cc.langD or false) ''
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
    + optionalString ((targetPlatform ? platform.gcc.arch) &&
                      isGccArchSupported targetPlatform.platform.gcc.arch) ''
      echo "-march=${targetPlatform.platform.gcc.arch}" >> $out/nix-support/cc-cflags-before
    ''

    # -mcpu is not very useful. You should use mtune and march
    # instead. It’s provided here for backwards compatibility.
    + optionalString (targetPlatform ? platform.gcc.cpu) ''
      echo "-mcpu=${targetPlatform.platform.gcc.cpu}" >> $out/nix-support/cc-cflags-before
    ''

    # -mfloat-abi only matters on arm32 but we set it here
    # unconditionally just in case. If the abi specifically sets hard
    # vs. soft floats we use it here.
    + optionalString (targetPlatform ? platform.gcc.float-abi) ''
      echo "-mfloat-abi=${targetPlatform.platform.gcc.float-abi}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? platform.gcc.fpu) ''
      echo "-mfpu=${targetPlatform.platform.gcc.fpu}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? platform.gcc.mode) ''
      echo "-mmode=${targetPlatform.platform.gcc.mode}" >> $out/nix-support/cc-cflags-before
    ''
    + optionalString (targetPlatform ? platform.gcc.tune &&
                      isGccArchSupported targetPlatform.platform.gcc.tune) ''
      echo "-mtune=${targetPlatform.platform.gcc.tune}" >> $out/nix-support/cc-cflags-before
    ''

    # TODO: categorize these and figure out a better place for them
    + optionalString hostPlatform.isCygwin ''
      hardening_unsupported_flags+=" pic"
    '' + optionalString targetPlatform.isMinGW ''
      hardening_unsupported_flags+=" stackprotector"
    '' + optionalString targetPlatform.isAvr ''
      hardening_unsupported_flags+=" stackprotector pic"
    '' + optionalString (targetPlatform.libc == "newlib") ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    '' + optionalString targetPlatform.isNetBSD ''
      hardening_unsupported_flags+=" stackprotector fortify"
    '' + optionalString cc.langAda or false ''
      hardening_unsupported_flags+=" format stackprotector strictoverflow"
    '' + optionalString cc.langD or false ''
      hardening_unsupported_flags+=" format"
    '' + optionalString targetPlatform.isWasm ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    ''

    + optionalString (libc != null && targetPlatform.isAvr) ''
      for isa in avr5 avr3 avr4 avr6 avr25 avr31 avr35 avr51 avrxmega2 avrxmega4 avrxmega5 avrxmega6 avrxmega7 tiny-stack; do
        echo "-B${getLib libc}/avr/lib/$isa" >> $out/nix-support/libc-crt1-cflags
      done
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

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands;

  inherit expand-response-params;

  # for substitution in utils.bash
  expandResponseParams = "${expand-response-params}/bin/expand-response-params";

  meta =
    let cc_ = if cc != null then cc else {}; in
    (if cc_ ? meta then removeAttrs cc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" cc_
        + " (wrapper script)";
      priority = 10;
  };
}
