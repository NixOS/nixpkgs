# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenvNoCC, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, cc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenvNoCC.shell
, zlib ? null, extraPackages ? [], extraBuildCommands ? ""
, isGNU ? false, isClang ? cc.isClang or false, gnugrep ? null
, buildPackages ? {}
, useMacosReexportHack ? false
}:

with stdenvNoCC.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools ->
  cc != null && binutils != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper.
assert cc.langVhdl or false -> zlib != null;

let
  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = stdenv.lib.optionalString (targetPlatform != hostPlatform)
                                           (targetPlatform.config + "-");

  ccVersion = (builtins.parseDrvName cc.name).version;
  ccName = (builtins.parseDrvName cc.name).name;

  libc_bin = if libc == null then null else getBin libc;
  libc_dev = if libc == null then null else getDev libc;
  libc_lib = if libc == null then null else getLib libc;
  cc_solib = getLib cc;
  binutils_bin = if nativeTools then "" else getBin binutils;
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

  # The dynamic linker has different names on different platforms. This is a
  # shell glob that ought to match it.
  dynamicLinker =
    /**/ if libc == null then null
    else if targetPlatform.system == "i686-linux"     then "${libc_lib}/lib/ld-linux.so.2"
    else if targetPlatform.system == "x86_64-linux"   then "${libc_lib}/lib/ld-linux-x86-64.so.2"
    # ARM with a wildcard, which can be "" or "-armhf".
    else if (with targetPlatform; isArm && isLinux)   then "${libc_lib}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux"  then "${libc_lib}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux"  then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.system == "mips64el-linux" then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.isDarwin                   then "/usr/lib/dyld"
    else if stdenv.lib.hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1"
    else null;

  expand-response-params =
    if buildPackages.stdenv.cc or null != null && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

in

stdenv.mkDerivation {
  name = targetPrefix
    + (if name != "" then name else "${ccName}-wrapper")
    + (stdenv.lib.optionalString (cc != null && ccVersion != "") "-${ccVersion}");

  preferLocalBuild = true;

  inherit cc libc_bin libc_dev libc_lib binutils_bin coreutils_bin;
  shell = getBin shell + shell.shellPath or "";
  gnugrep_bin = if nativeTools then "" else gnugrep;

  inherit targetPrefix infixSalt;

  outputs = [ "out" "man" ];

  passthru = {
    # "cc" is the generic name for a C compiler, but there is no one for package
    # providing the linker and related tools. The two we use now are GNU
    # Binutils, and Apple's "cctools"; "binutils" as an attempt to find an
    # unused middle-ground name that evokes both.
    bintools = binutils_bin;
    inherit libc nativeTools nativeLibc nativePrefix isGNU isClang default_cxx_stdlib_compile;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc (lambda (arg)
        (when (file-directory-p (concat arg "/include"))
          (setenv "NIX_${infixSalt}_CFLAGS_COMPILE" (concat (getenv "NIX_${infixSalt}_CFLAGS_COMPILE") " -isystem " arg "/include")))
        (when (file-directory-p (concat arg "/lib"))
          (setenv "NIX_${infixSalt}_LDFLAGS" (concat (getenv "NIX_${infixSalt}_LDFLAGS") " -L" arg "/lib")))
        (when (file-directory-p (concat arg "/lib64"))
          (setenv "NIX_${infixSalt}_LDFLAGS" (concat (getenv "NIX_${infixSalt}_LDFLAGS") " -L" arg "/lib64")))) '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
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
      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $cc > $out/nix-support/orig-cc

      ccPath="${cc}/bin"
      ldPath="${binutils_bin}/bin"
    ''

    + optionalString (targetPlatform.isSunOS && nativePrefix != "") ''
      # Solaris needs an additional ld wrapper.
      ldPath="${nativePrefix}/bin"
      exec="$ldPath/${targetPrefix}ld"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    + ''
      # Create a symlink to as (the assembler).  This is useful when a
      # cc-wrapper is installed in a user environment, as it ensures that
      # the right assembler is called.
      if [ -e $ldPath/${targetPrefix}as ]; then
        ln -s $ldPath/${targetPrefix}as $out/bin/${targetPrefix}as
      fi

    '' + (if !useMacosReexportHack then ''
      wrap ${targetPrefix}ld ${./ld-wrapper.sh} ''${ld:-$ldPath/${targetPrefix}ld}
    '' else ''
      ldInner="${targetPrefix}ld-reexport-delegate"
      wrap "$ldInner" ${./macos-sierra-reexport-hack.bash} ''${ld:-$ldPath/${targetPrefix}ld}
      wrap "${targetPrefix}ld" ${./ld-wrapper.sh} "$out/bin/$ldInner"
      unset ldInner
    '') + ''

      if [ -e ${binutils_bin}/bin/${targetPrefix}ld.gold ]; then
        wrap ${targetPrefix}ld.gold ${./ld-wrapper.sh} ${binutils_bin}/bin/${targetPrefix}ld.gold
      fi

      if [ -e ${binutils_bin}/bin/ld.bfd ]; then
        wrap ${targetPrefix}ld.bfd ${./ld-wrapper.sh} ${binutils_bin}/bin/${targetPrefix}ld.bfd
      fi

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
    ''

    + optionalString cc.langAda or false ''
      wrap ${targetPrefix}gnatgcc ${./cc-wrapper.sh} $ccPath/${targetPrefix}gnatgcc
      wrap ${targetPrefix}gnatmake ${./gnat-wrapper.sh} $ccPath/${targetPrefix}gnatmake
      wrap ${targetPrefix}gnatbind ${./gnat-wrapper.sh} $ccPath/${targetPrefix}gnatbind
      wrap ${targetPrefix}gnatlink ${./gnatlink-wrapper.sh} $ccPath/${targetPrefix}gnatlink
    ''

    + optionalString cc.langVhdl or false ''
      ln -s $ccPath/${targetPrefix}ghdl $out/bin/${targetPrefix}ghdl
    '';

  propagatedBuildInputs = extraPackages;

  setupHook = ./setup-hook.sh;

  postFixup =
    ''
      set -u
    ''

    + optionalString (libc != null) (''
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

      echo "-L${libc_lib}/lib" > $out/nix-support/libc-ldflags

      echo "${libc_lib}" > $out/nix-support/orig-libc
      echo "${libc_dev}" > $out/nix-support/orig-libc-dev

      ##
      ## Dynamic linker support
      ##

      if [[ -z ''${dynamicLinker+x} ]]; then
        echo "Don't know the name of the dynamic linker for platform '${targetPlatform.config}', so guessing instead." >&2
        local dynamicLinker="${libc_lib}/lib/ld*.so.?"
      fi

      # Expand globs to fill array of options
      dynamicLinker=($dynamicLinker)

      case ''${#dynamicLinker[@]} in
        0) echo "No dynamic linker found for platform '${targetPlatform.config}'." >&2;;
        1) echo "Using dynamic linker: '$dynamicLinker'" >&2;;
        *) echo "Multiple dynamic linkers found for platform '${targetPlatform.config}'." >&2;;
      esac

      if [ -n "''${dynamicLinker:-}" ]; then
        echo $dynamicLinker > $out/nix-support/dynamic-linker

    '' + (if targetPlatform.isDarwin then ''
        printf "export LD_DYLD_PATH=%q\n" "$dynamicLinker" >> $out/nix-support/setup-hook
    '' else ''
        if [ -e ${libc_lib}/lib/32/ld-linux.so.2 ]; then
          echo ${libc_lib}/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
        fi

        local ldflagsBefore=(-dynamic-linker "$dynamicLinker")
    '') + ''
      fi

      # The dynamic linker is passed in `ldflagsBefore' to allow
      # explicit overrides of the dynamic linker by callers to gcc/ld
      # (the *last* value counts, so ours should come first).
      printWords "''${ldflagsBefore[@]}" > $out/nix-support/libc-ldflags-before
    '')

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
      printWords ${cc} ${binutils_bin} ${if libc == null then "" else libc_bin} > $out/nix-support/propagated-user-env-packages
      printWords ${cc.man or ""}  > $man/nix-support/propagated-user-env-packages
    ''

    + ''

      ##
      ## Hardening support
      ##

      # some linkers on some platforms don't support specific -z flags
      export hardening_unsupported_flags=""
      if [[ "$($ldPath/${targetPrefix}ld -z now 2>&1 || true)" =~ un(recognized|known)\ option ]]; then
        hardening_unsupported_flags+=" bindnow"
      fi
      if [[ "$($ldPath/${targetPrefix}ld -z relro 2>&1 || true)" =~ un(recognized|known)\ option ]]; then
        hardening_unsupported_flags+=" relro"
      fi
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

  inherit dynamicLinker expand-response-params;

  # for substitution in utils.sh
  expandResponseParams = "${expand-response-params}/bin/expand-response-params";

  meta =
    let cc_ = if cc != null then cc else {}; in
    (if cc_ ? meta then removeAttrs cc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" cc_
        + " (wrapper script)";
  } // optionalAttrs useMacosReexportHack {
    platforms = stdenv.lib.platforms.darwin;
  };
}
