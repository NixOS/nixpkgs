# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? ""
, stdenvNoCC
, cc ? null, libc ? null, bintools, coreutils ? null, shell ? stdenvNoCC.shell
, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, propagateDoc ? cc != null && cc ? man
, extraPackages ? [], extraBuildCommands ? ""
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
  cc_solib = getLib cc;
  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = if nativeTools then "" else getBin coreutils;

  default_cxx_stdlib_compile = if (targetPlatform.isLinux && !(cc.isGNU or false) && !nativeTools && cc ? gcc) && !(targetPlatform.useLLVM or false) then
    "-isystem $(echo -n ${cc.gcc}/include/c++/*) -isystem $(echo -n ${cc.gcc}/include/c++/*)/$(${cc.gcc}/bin/gcc -dumpmachine)"
  else if targetPlatform.isDarwin && (libcxx != null) && (cc.isClang or false) && !(targetPlatform.useLLVM or false) then
    "-isystem ${libcxx}/include/c++/v1"
  else "";

  # The "infix salt" is a arbitrary string added in the middle of env vars
  # defined by cc-wrapper's hooks so that multiple cc-wrappers can be used
  # without interfering. For the moment, it is defined as the target triple,
  # adjusted to be a valid bash identifier. This should be considered an
  # unstable implementation detail, however.
  infixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

  expand-response-params =
    if buildPackages.stdenv.hasCC && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

  # older compilers (for example bootstrap's GCC 5) fail with -march=too-modern-cpu
  isGccArchSupported = arch:
    if cc.isGNU or false then
      { skylake        = versionAtLeast ccVersion "6.0";
        skylake-avx512 = versionAtLeast ccVersion "6.0";
        cannonlake     = versionAtLeast ccVersion "8.0";
        icelake-client = versionAtLeast ccVersion "8.0";
        icelake-server = versionAtLeast ccVersion "8.0";
        knm            = versionAtLeast ccVersion "8.0";
      }.${arch} or true
    else if cc.isClang or false then
      { cannonlake     = versionAtLeast ccVersion "5.0";
        icelake-client = versionAtLeast ccVersion "7.0";
        icelake-server = versionAtLeast ccVersion "7.0";
        knm            = versionAtLeast ccVersion "7.0";
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
  name = targetPrefix
    + (if name != "" then name else "${ccName}-wrapper")
    + (stdenv.lib.optionalString (cc != null && ccVersion != "") "-${ccVersion}");

  preferLocalBuild = true;

  inherit cc libc_bin libc_dev libc_lib bintools coreutils_bin;
  shell = getBin shell + shell.shellPath or "";
  gnugrep_bin = if nativeTools then "" else gnugrep;

  inherit targetPrefix infixSalt;

  outputs = [ "out" ] ++ optionals propagateDoc [ "man" "info" ];

  passthru = {
    # "cc" is the generic name for a C compiler, but there is no one for package
    # providing the linker and related tools. The two we use now are GNU
    # Binutils, and Apple's "cctools"; "bintools" as an attempt to find an
    # unused middle-ground name that evokes both.
    inherit bintools;
    inherit libc nativeTools nativeLibc nativePrefix isGNU isClang default_cxx_stdlib_compile;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/include"))
            (setenv "NIX_${infixSalt}_CFLAGS_COMPILE" (concat (getenv "NIX_${infixSalt}_CFLAGS_COMPILE") " -isystem " arg "/include"))))
        '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';
  };

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    src=$PWD
  '';

  installPhase =
    ''
      set -u

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

    + ''
      # Create symlinks to everything in the bintools wrapper.
      for bbin in $bintools/bin/*; do
        mkdir -p "$out/bin"
        ln -s "$bbin" "$out/bin/$(basename $bbin)"
      done

      # We export environment variables pointing to the wrapped nonstandard
      # cmds, lest some lousy configure script use those to guess compiler
      # version.
      export named_cc=${targetPrefix}cc
      export named_cxx=${targetPrefix}c++

      export default_cxx_stdlib_compile="${default_cxx_stdlib_compile}"

      if [ -e $ccPath/${targetPrefix}gcc ]; then
        wrap ${targetPrefix}gcc ${./cc-wrapper.sh} $ccPath/${targetPrefix}gcc
        ln -s ${targetPrefix}gcc $out/bin/${targetPrefix}cc
        export named_cc=${targetPrefix}gcc
        export named_cxx=${targetPrefix}g++
      elif [ -e $ccPath/clang ]; then
        wrap ${targetPrefix}clang ${./cc-wrapper.sh} $ccPath/clang
        ln -s ${targetPrefix}clang $out/bin/${targetPrefix}cc
        export named_cc=${targetPrefix}clang
        export named_cxx=${targetPrefix}clang++
      fi

      if [ -e $ccPath/${targetPrefix}g++ ]; then
        wrap ${targetPrefix}g++ ${./cc-wrapper.sh} $ccPath/${targetPrefix}g++
        ln -s ${targetPrefix}g++ $out/bin/${targetPrefix}c++
      elif [ -e $ccPath/clang++ ]; then
        wrap ${targetPrefix}clang++ ${./cc-wrapper.sh} $ccPath/clang++
        ln -s ${targetPrefix}clang++ $out/bin/${targetPrefix}c++
      fi

      if [ -e $ccPath/cpp ]; then
        wrap ${targetPrefix}cpp ${./cc-wrapper.sh} $ccPath/cpp
      fi
    ''

    + optionalString cc.langFortran or false ''
      wrap ${targetPrefix}gfortran ${./cc-wrapper.sh} $ccPath/${targetPrefix}gfortran
      ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}g77
      ln -sv ${targetPrefix}gfortran $out/bin/${targetPrefix}f77
    ''

    + optionalString cc.langJava or false ''
      wrap ${targetPrefix}gcj ${./cc-wrapper.sh} $ccPath/${targetPrefix}gcj
    ''

    + optionalString cc.langGo or false ''
      wrap ${targetPrefix}gccgo ${./cc-wrapper.sh} $ccPath/${targetPrefix}gccgo
    '';

  strictDeps = true;
  propagatedBuildInputs = [ bintools ];
  depsTargetTargetPropagated = extraPackages;

  wrapperName = "CC_WRAPPER";

  setupHooks = [
    ../setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postFixup =
    ''
      set -u

      # Backwards compatability for packages expecting this file, e.g. with
      # `$NIX_CC/nix-support/dynamic-linker`.
      #
      # TODO(@Ericson2314): Remove this after stable release and force
      # everyone to refer to bintools-wrapper directly.
      if [[ -f "$bintools/nix-support/dynamic-linker" ]]; then
        ln -s "$bintools/nix-support/dynamic-linker" "$out/nix-support"
      fi
      if [[ -f "$bintools/nix-support/dynamic-linker-m32" ]]; then
        ln -s "$bintools/nix-support/dynamic-linker-m32" "$out/nix-support"
      fi
    ''

    + optionalString (libc != null) ''
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
      echo "-B${libc_lib}${libc.libdir or "/lib/"} -idirafter ${libc_dev}${libc.incdir or "/include"} ${optionalString isGNU "-idirafter ${cc}/lib/gcc/*/*/include-fixed"}" > $out/nix-support/libc-cflags

      echo "${libc_lib}" > $out/nix-support/orig-libc
      echo "${libc_dev}" > $out/nix-support/orig-libc-dev
    ''

    + optionalString (!nativeTools) ''
      ##
      ## Initial CFLAGS
      ##

      # GCC shows ${cc_solib}/lib in `gcc -print-search-dirs', but not
      # ${cc_solib}/lib64 (even though it does actually search there...)..
      # This confuses libtool.  So add it to the compiler tool search
      # path explicitly.
      if [ -e "${cc_solib}/lib64" -a ! -L "${cc_solib}/lib64" ]; then
        ccLDFlags+=" -L${cc_solib}/lib64"
        ccCFlags+=" -B${cc_solib}/lib64"
      fi
      ccLDFlags+=" -L${cc_solib}/lib"
      ccCFlags+=" -B${cc_solib}/lib"

      echo "$ccLDFlags" > $out/nix-support/cc-ldflags
      echo "$ccCFlags" > $out/nix-support/cc-cflags
    '' + optionalString (targetPlatform.isDarwin && (libcxx != null) && (cc.isClang or false)) ''
      echo " -L${libcxx}/lib" >> $out/nix-support/cc-ldflags
    '' + optionalString propagateDoc ''
      ##
      ## Man page and info support
      ##

      ln -s ${cc.man} $man
      ln -s ${cc.info} $info
    ''

    + ''
      ##
      ## Hardening support
      ##

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
    ''

    + optionalString targetPlatform.isWasm ''
      hardening_unsupported_flags+=" stackprotector fortify pie pic"
    ''

    + optionalString (libc != null && targetPlatform.isAvr) ''
      for isa in avr5 avr3 avr4 avr6 avr25 avr31 avr35 avr51 avrxmega2 avrxmega4 avrxmega5 avrxmega6 avrxmega7 tiny-stack; do
        echo "-B${getLib libc}/avr/lib/$isa" >> $out/nix-support/libc-cflags
      done
    ''

    + ''
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${./add-hardening.sh} $out/nix-support/add-hardening.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash

      ##
      ## Extra custom steps
      ##
    ''

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
