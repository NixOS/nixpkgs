# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, cc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null, extraPackages ? [], extraBuildCommands ? ""
, dyld ? null # TODO: should this be a setup-hook on dyld?
, isGNU ? false, isClang ? cc.isClang or false, gnugrep ? null
, buildPackages ? {}, hostPlatform, targetPlatform
, runCommand ? null
, useMacosReexportHack ? false
}:

with stdenv.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools ->
  cc != null && binutils != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

assert stdenv.targetPlatform != stdenv.hostPlatform -> runCommand != null;

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper.
assert cc.langVhdl or false -> zlib != null;

let
  inherit (stdenv) hostPlatform targetPlatform;

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
    else if targetPlatform.isArm32                    then "${libc_lib}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux"  then "${libc_lib}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux"  then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.system == "mips64el-linux" then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.system == "x86_64-darwin"  then "/usr/lib/dyld"
    else if stdenv.lib.hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1"
    else null;

  expand-response-params = if buildPackages.stdenv.cc or null != null && buildPackages.stdenv.cc != "/dev/null"
  then buildPackages.stdenv.mkDerivation {
    name = "expand-response-params";
    src = ./expand-response-params.c;
    buildCommand = ''
      # Work around "stdenv-darwin-boot-2 is not allowed to refer to path /nix/store/...-expand-response-params.c"
      cp "$src" expand-response-params.c
      "$CC" -std=c99 -O3 -o "$out" expand-response-params.c
    '';
  } else "";

in

stdenv.mkDerivation {
  name = prefix
    + (if name != "" then name else "${ccName}-wrapper")
    + (stdenv.lib.optionalString (cc != null && ccVersion != "") "-${ccVersion}");

  preferLocalBuild = true;

  inherit cc shell libc_bin libc_dev libc_lib binutils_bin coreutils_bin;
  gnugrep_bin = if nativeTools then "" else gnugrep;

  binPrefix = prefix;
  inherit infixSalt;

  passthru = {
    inherit libc nativeTools nativeLibc nativePrefix isGNU isClang default_cxx_stdlib_compile
            prefix;

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

  buildCommand =
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

    + optionalString (libc != null) (''
      if [[ -z ''${dynamicLinker+x} ]]; then
        echo "Don't know the name of the dynamic linker for platform '${targetPlatform.config}', so guessing instead." >&2
        dynamicLinker="${libc_lib}/lib/ld*.so.?"
      fi

      # Expand globs to fill array of options
      dynamicLinker=($dynamicLinker)

      case ''${#dynamicLinker[@]} in
        0) echo "No dynamic linker found for platform '${targetPlatform.config}'." >&2;;
        1) echo "Using dynamic linker: '$dynamicLinker'" >&2;;
        *) echo "Multiple dynamic linkers found for platform '${targetPlatform.config}'." >&2;;
      esac

      if [ -n "$dynamicLinker" ]; then
        echo $dynamicLinker > $out/nix-support/dynamic-linker

    '' + (if targetPlatform.isDarwin then ''
        printf "export LD_DYLD_PATH+=%q\n" "$dynamicLinker" >> $out/nix-support/setup-hook
    '' else ''
        if [ -e ${libc_lib}/lib/32/ld-linux.so.2 ]; then
          echo ${libc_lib}/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
        fi

        ldflagsBefore=(-dynamic-linker "$dynamicLinker")
    '') + ''
      fi

      # The dynamic linker is passed in `ldflagsBefore' to allow
      # explicit overrides of the dynamic linker by callers to gcc/ld
      # (the *last* value counts, so ours should come first).
      printWords "''${ldflagsBefore[@]}" > $out/nix-support/libc-ldflags-before
    '')

    + optionalString (libc != null) ''
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
    ''

    + (if nativeTools then ''
      ccPath="${if targetPlatform.isDarwin then cc else nativePrefix}/bin"
      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $cc > $out/nix-support/orig-cc

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

      if [ -e $ccPath/clang ]; then
        # Need files like crtbegin.o from gcc
        # It's unclear if these will ever be provided by an LLVM project
        ccCFlags="$ccCFlags -B$basePath"
        ccCFlags="$ccCFlags -isystem$cc/lib/clang/$ccVersion/include"
      fi

      echo "$ccLDFlags" > $out/nix-support/cc-ldflags
      echo "$ccCFlags" > $out/nix-support/cc-cflags

      ccPath="${cc}/bin"
      ldPath="${binutils_bin}/bin"

      # Propagate the wrapped cc so that if you install the wrapper,
      # you get tools like gcov, the manpages, etc. as well (including
      # for binutils and Glibc).
      printWords ${cc} ${cc.man or ""} ${binutils_bin} ${if libc == null then "" else libc_bin} > $out/nix-support/propagated-user-env-packages

      printWords ${toString extraPackages} > $out/nix-support/propagated-native-build-inputs
    ''

    + optionalString (targetPlatform.isSunOS && nativePrefix != "") ''
      # Solaris needs an additional ld wrapper.
      ldPath="${nativePrefix}/bin"
      exec="$ldPath/${prefix}ld"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    + ''
      # Create a symlink to as (the assembler).  This is useful when a
      # cc-wrapper is installed in a user environment, as it ensures that
      # the right assembler is called.
      if [ -e $ldPath/${prefix}as ]; then
        ln -s $ldPath/${prefix}as $out/bin/${prefix}as
      fi

    '' + (if !useMacosReexportHack then ''
      wrap ${prefix}ld ${./ld-wrapper.sh} ''${ld:-$ldPath/${prefix}ld}
    '' else ''
      ldInner="${prefix}ld-reexport-delegate"
      wrap "$ldInner" ${./macos-sierra-reexport-hack.bash} ''${ld:-$ldPath/${prefix}ld}
      wrap "${prefix}ld" ${./ld-wrapper.sh} "$out/bin/$ldInner"
      unset ldInner
    '') + ''

      if [ -e ${binutils_bin}/bin/${prefix}ld.gold ]; then
        wrap ${prefix}ld.gold ${./ld-wrapper.sh} ${binutils_bin}/bin/${prefix}ld.gold
      fi

      if [ -e ${binutils_bin}/bin/ld.bfd ]; then
        wrap ${prefix}ld.bfd ${./ld-wrapper.sh} ${binutils_bin}/bin/${prefix}ld.bfd
      fi

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
    ''

    + ''
      substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook.tmp
      cat $out/nix-support/setup-hook.tmp >> $out/nix-support/setup-hook
      rm $out/nix-support/setup-hook.tmp

      # some linkers on some platforms don't support specific -z flags
      hardening_unsupported_flags=""
      if [[ "$($ldPath/${prefix}ld -z now 2>&1 || true)" =~ un(recognized|known)\ option ]]; then
        hardening_unsupported_flags+=" bindnow"
      fi
      if [[ "$($ldPath/${prefix}ld -z relro 2>&1 || true)" =~ un(recognized|known)\ option ]]; then
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
    ''
    + extraBuildCommands;

  inherit dynamicLinker expand-response-params;

  expandResponseParams = expand-response-params; # for substitution in utils.sh

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
  };

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
