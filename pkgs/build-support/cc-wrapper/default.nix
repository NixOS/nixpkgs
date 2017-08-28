# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, cc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null, extraPackages ? [], extraBuildCommands ? ""
, isGNU ? false, isClang ? cc.isClang or false, gnugrep ? null
, buildPackages ? {}
, useMacosReexportHack ? false
} @ args:

with stdenv.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools ->
  cc != null && binutils != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper.
assert cc.langVhdl or false -> zlib != null;

let
  inherit (stdenv) hostPlatform targetPlatform;

  binutils = import ../binutils-wrapper {
    inherit (args) binutils;
    inherit # name
      stdenv nativeTools noLibc nativeLibc nativePrefix
      libc
      coreutils shell gnugrep
      extraPackages extraBuildCommands
      buildPackages
      useMacosReexportHack;
  };

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  prefix = stdenv.lib.optionalString (targetPlatform != hostPlatform)
                                     (targetPlatform.config + "-");

  ccVersion = (builtins.parseDrvName cc.name).version;
  ccName = (builtins.parseDrvName cc.name).name;

  libc_bin = if libc == null then null else getBin libc;
  libc_dev = if libc == null then null else getDev libc;
  libc_lib = if libc == null then null else getLib libc;
  cc_solib = getLib cc;
  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = if nativeTools then "" else getBin coreutils;

  default_cxx_stdlib_compile=optionalString (targetPlatform.isLinux && !(cc.isGNU or false))
    "-isystem $(echo -n ${cc.gcc}/include/c++/*) -isystem $(echo -n ${cc.gcc}/include/c++/*)/$(${cc.gcc}/bin/gcc -dumpmachine)";

  dashlessTarget = stdenv.lib.replaceStrings ["-"] ["_"] targetPlatform.config;

  # The "infix salt" is a arbitrary string added in the middle of env vars
  # defined by cc-wrapper's hooks so that multiple cc-wrappers can be used
  # without interfering. For the moment, it is defined as the target triple,
  # adjusted to be a valid bash identifier. This should be considered an
  # unstable implementation detail, however.
  infixSalt = dashlessTarget;

  expand-response-params =
    if buildPackages.stdenv.cc or null != null && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

in

stdenv.mkDerivation {
  name = prefix
    + (if name != "" then name else "${ccName}-wrapper")
    + (stdenv.lib.optionalString (cc != null && ccVersion != "") "-${ccVersion}");

  preferLocalBuild = true;

  inherit cc shell libc_bin libc_dev libc_lib binutils coreutils_bin;
  gnugrep_bin = if nativeTools then "" else gnugrep;

  binPrefix = prefix;
  inherit infixSalt;

  outputs = [ "out" "man" ];

  passthru = {
    inherit libc nativeTools nativeLibc nativePrefix isGNU isClang default_cxx_stdlib_compile
            prefix;

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

      mkdir -p $out/bin $out/nix-support $man/nix-support

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
      # Create symlinks to everything in the binutils wrapper.
      for bbin in $binutils/bin/*; do
        mkdir -p "$out/bin"
        ln -s "$bbin" "$out/bin/$(basename $bbin)"
      done

      # We export environment variables pointing to the wrapped nonstandard
      # cmds, lest some lousy configure script use those to guess compiler
      # version.
      export named_cc=${prefix}cc
      export named_cxx=${prefix}c++

      export default_cxx_stdlib_compile="${default_cxx_stdlib_compile}"

      if [ -e $ccPath/${prefix}gcc ]; then
        wrap ${prefix}gcc ${./cc-wrapper.sh} $ccPath/${prefix}gcc
        ln -s ${prefix}gcc $out/bin/${prefix}cc
        export named_cc=${prefix}gcc
        export named_cxx=${prefix}g++
      elif [ -e $ccPath/clang ]; then
        wrap ${prefix}clang ${./cc-wrapper.sh} $ccPath/clang
        ln -s ${prefix}clang $out/bin/${prefix}cc
        export named_cc=${prefix}clang
        export named_cxx=${prefix}clang++
      fi

      if [ -e $ccPath/${prefix}g++ ]; then
        wrap ${prefix}g++ ${./cc-wrapper.sh} $ccPath/${prefix}g++
        ln -s ${prefix}g++ $out/bin/${prefix}c++
      elif [ -e $ccPath/clang++ ]; then
        wrap ${prefix}clang++ ${./cc-wrapper.sh} $ccPath/clang++
        ln -s ${prefix}clang++ $out/bin/${prefix}c++
      fi

      if [ -e $ccPath/cpp ]; then
        wrap ${prefix}cpp ${./cc-wrapper.sh} $ccPath/cpp
      fi
    ''

    + optionalString cc.langFortran or false ''
      wrap ${prefix}gfortran ${./cc-wrapper.sh} $ccPath/${prefix}gfortran
      ln -sv ${prefix}gfortran $out/bin/${prefix}g77
      ln -sv ${prefix}gfortran $out/bin/${prefix}f77
    ''

    + optionalString cc.langJava or false ''
      wrap ${prefix}gcj ${./cc-wrapper.sh} $ccPath/${prefix}gcj
    ''

    + optionalString cc.langGo or false ''
      wrap ${prefix}gccgo ${./cc-wrapper.sh} $ccPath/${prefix}gccgo
    ''

    + optionalString cc.langAda or false ''
      wrap ${prefix}gnatgcc ${./cc-wrapper.sh} $ccPath/${prefix}gnatgcc
      wrap ${prefix}gnatmake ${./gnat-wrapper.sh} $ccPath/${prefix}gnatmake
      wrap ${prefix}gnatbind ${./gnat-wrapper.sh} $ccPath/${prefix}gnatbind
      wrap ${prefix}gnatlink ${./gnatlink-wrapper.sh} $ccPath/${prefix}gnatlink
    ''

    + optionalString cc.langVhdl or false ''
      ln -s $ccPath/${prefix}ghdl $out/bin/${prefix}ghdl
    '';

  propagatedBuildInputs = [ binutils ] ++ extraPackages;

  setupHook = ./setup-hook.sh;

  postFixup =
    ''
      set -u
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
      echo "-B${libc_lib}/lib/ -idirafter ${libc_dev}/include -idirafter ${cc}/lib/gcc/*/*/include-fixed" > $out/nix-support/libc-cflags

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

      ${optionalString cc.langVhdl or false ''
        ccLDFlags+=" -L${zlib.out}/lib"
      ''}

      # Find the gcc libraries path (may work only without multilib).
      ${optionalString cc.langAda or false ''
        basePath=`echo ${cc_solib}/lib/*/*/*`
        ccCFlags+=" -B$basePath -I$basePath/adainclude"
        gnatCFlags="-aI$basePath/adainclude -aO$basePath/adalib"
        echo "$gnatCFlags" > $out/nix-support/gnat-cflags
      ''}

      echo "$ccLDFlags" > $out/nix-support/cc-ldflags
      echo "$ccCFlags" > $out/nix-support/cc-cflags

      ##
      ## User env support
      ##

      # Propagate the wrapped cc so that if you install the wrapper,
      # you get tools like gcov, the manpages, etc. as well (including
      # for binutils and Glibc).
      printWords ${cc.man or ""}  > $man/nix-support/propagated-user-env-packages
    ''

    + ''

      ##
      ## Hardening support
      ##

      export hardening_unsupported_flags=""
    ''

    + optionalString hostPlatform.isCygwin ''
      hardening_unsupported_flags+=" pic"
    ''

    + ''
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${./add-hardening.sh} $out/nix-support/add-hardening.sh
      substituteAll ${./utils.sh} $out/nix-support/utils.sh

      ##
      ## Extra custom steps
      ##

    ''
    + extraBuildCommands;

  inherit expand-response-params;

  # for substitution in utils.sh
  expandResponseParams = "${expand-response-params}/bin/expand-response-params";

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
  };

  meta =
    let cc_ = if cc != null then cc else {}; in
    (if cc_ ? meta then removeAttrs cc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" cc_
        + " (wrapper script)";
  };
}
