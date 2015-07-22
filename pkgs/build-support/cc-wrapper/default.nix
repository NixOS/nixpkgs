# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, nativeLibc, nativePrefix ? ""
, cc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null, extraPackages ? [], extraBuildCommands ? ""
, dyld ? null # TODO: should this be a setup-hook on dyld?
, isGNU ? false, isClang ? false
}:

with stdenv.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> cc != null && binutils != null && coreutils != null;
assert !nativeLibc -> libc != null;

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper.
assert cc.langVhdl or false -> zlib != null;

let

  ccVersion = (builtins.parseDrvName cc.name).version;
  ccName = (builtins.parseDrvName cc.name).name;

in

stdenv.mkDerivation {
  name =
    (if name != "" then name else ccName + "-wrapper") +
    (if cc != null && ccVersion != "" then "-" + ccVersion else "");

  preferLocalBuild = true;

  inherit cc shell;
  libc = if nativeLibc then null else libc;
  binutils = if nativeTools then null else binutils;
  # The wrapper scripts use 'cat', so we may need coreutils.
  coreutils = if nativeTools then null else coreutils;

  passthru = { inherit nativeTools nativeLibc nativePrefix isGNU isClang; };

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

    + optionalString (!nativeLibc) (if (!stdenv.isDarwin) then ''
      dynamicLinker="$libc/lib/$dynamicLinker"
      echo $dynamicLinker > $out/nix-support/dynamic-linker

      if [ -e $libc/lib/32/ld-linux.so.2 ]; then
        echo $libc/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
      fi

      # The dynamic linker is passed in `ldflagsBefore' to allow
      # explicit overrides of the dynamic linker by callers to gcc/ld
      # (the *last* value counts, so ours should come first).
      echo "-dynamic-linker" $dynamicLinker > $out/nix-support/libc-ldflags-before
    '' else ''
      echo $dynamicLinker > $out/nix-support/dynamic-linker

      echo "export LD_DYLD_PATH=\"$dynamicLinker\"" >> $out/nix-support/setup-hook
    '')

    + optionalString (!nativeLibc) ''
      # The "-B$libc/lib/" flag is a quick hack to force gcc to link
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
      echo "-B$libc/lib/ -idirafter $libc/include -idirafter $cc/lib/gcc/*/*/include-fixed" > $out/nix-support/libc-cflags

      echo "-L$libc/lib" > $out/nix-support/libc-ldflags

      echo $libc > $out/nix-support/orig-libc
    ''

    + (if nativeTools then ''
      ccPath="${if stdenv.isDarwin then cc else nativePrefix}/bin"
      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $cc > $out/nix-support/orig-cc

      # GCC shows $cc/lib in `gcc -print-search-dirs', but not
      # $cc/lib64 (even though it does actually search there...)..
      # This confuses libtool.  So add it to the compiler tool search
      # path explicitly.
      if [ -e "$cc/lib64" -a ! -L "$cc/lib64" ]; then
        ccLDFlags+=" -L$cc/lib64"
        ccCFlags+=" -B$cc/lib64"
      fi
      ccLDFlags+=" -L$cc/lib"

      ${optionalString cc.langVhdl or false ''
        ccLDFlags+=" -L${zlib}/lib"
      ''}

      # Find the gcc libraries path (may work only without multilib).
      ${optionalString cc.langAda or false ''
        basePath=`echo $cc/lib/*/*/*`
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

      ccPath="$cc/bin"
      ldPath="$binutils/bin"

      # Propagate the wrapped cc so that if you install the wrapper,
      # you get tools like gcov, the manpages, etc. as well (including
      # for binutils and Glibc).
      echo $cc $binutils $libc > $out/nix-support/propagated-user-env-packages

      echo ${toString extraPackages} > $out/nix-support/propagated-native-build-inputs
    ''

    + optionalString (stdenv.isSunOS && nativePrefix != "") ''
      # Solaris needs an additional ld wrapper.
      ldPath="${nativePrefix}/bin"
      ld="$out/bin/ld-solaris"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    + ''
      # Create a symlink to as (the assembler).  This is useful when a
      # cc-wrapper is installed in a user environment, as it ensures that
      # the right assembler is called.
      if [ -e $ldPath/as ]; then
        ln -s $ldPath/as $out/bin/as
      fi

      wrap ld ${./ld-wrapper.sh} ''${ld:-$ldPath/ld}

      if [ -e $binutils/bin/ld.gold ]; then
        wrap ld.gold ${./ld-wrapper.sh} $binutils/bin/ld.gold
      fi

      if [ -e $binutils/bin/ld.bfd ]; then
        wrap ld.bfd ${./ld-wrapper.sh} $binutils/bin/ld.bfd
      fi

      export real_cc=cc
      export real_cxx=c++
      export default_cxx_stdlib_compile="${
        if stdenv.isLinux && !(cc.isGNU or false)
          then "-isystem $(echo -n ${cc.gcc}/include/c++/*) -isystem $(echo -n ${cc.gcc}/include/c++/*)/$(${cc.gcc}/bin/gcc -dumpmachine)"
          else ""
      }"

      if [ -e $ccPath/gcc ]; then
        wrap gcc ${./cc-wrapper.sh} $ccPath/gcc
        ln -s gcc $out/bin/cc
        export real_cc=gcc
        export real_cxx=g++
      elif [ -e $ccPath/clang ]; then
        wrap clang ${./cc-wrapper.sh} $ccPath/clang
        ln -s clang $out/bin/cc
        export real_cc=clang
        export real_cxx=clang++
      fi

      if [ -e $ccPath/g++ ]; then
        wrap g++ ${./cc-wrapper.sh} $ccPath/g++
        ln -s g++ $out/bin/c++
      elif [ -e $ccPath/clang++ ]; then
        wrap clang++ ${./cc-wrapper.sh} $ccPath/clang++
        ln -s clang++ $out/bin/c++
      fi

      if [ -e $ccPath/cpp ]; then
        wrap cpp ${./cc-wrapper.sh} $ccPath/cpp
      fi
    ''

    + optionalString cc.langFortran or false ''
      wrap gfortran ${./cc-wrapper.sh} $ccPath/gfortran
      ln -sv gfortran $out/bin/g77
      ln -sv gfortran $out/bin/f77
    ''

    + optionalString cc.langJava or false ''
      wrap gcj ${./cc-wrapper.sh} $ccPath/gcj
    ''

    + optionalString cc.langGo or false ''
      wrap gccgo ${./cc-wrapper.sh} $ccPath/gccgo
    ''

    + optionalString cc.langAda or false ''
      wrap gnatgcc ${./cc-wrapper.sh} $ccPath/gnatgcc
      wrap gnatmake ${./gnat-wrapper.sh} $ccPath/gnatmake
      wrap gnatbind ${./gnat-wrapper.sh} $ccPath/gnatbind
      wrap gnatlink ${./gnatlink-wrapper.sh} $ccPath/gnatlink
    ''

    + optionalString cc.langVhdl or false ''
      ln -s $ccPath/ghdl $out/bin/ghdl
    ''

    + ''
      substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook.tmp
      cat $out/nix-support/setup-hook.tmp >> $out/nix-support/setup-hook
      rm $out/nix-support/setup-hook.tmp

      substituteAll ${./add-flags} $out/nix-support/add-flags.sh
      cp -p ${./utils.sh} $out/nix-support/utils.sh
    ''
    + extraBuildCommands;

  # The dynamic linker has different names on different Linux platforms.
  dynamicLinker =
    if !nativeLibc then
      (if stdenv.system == "i686-linux" then "ld-linux.so.2" else
       if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2" else
       # ARM with a wildcard, which can be "" or "-armhf".
       if stdenv.isArm then "ld-linux*.so.3" else
       if stdenv.system == "powerpc-linux" then "ld.so.1" else
       if stdenv.system == "mips64el-linux" then "ld.so.1" else
       if stdenv.system == "x86_64-darwin" then "${dyld}/lib/dyld" else
       abort "Don't know the name of the dynamic linker for this platform.")
    else "";

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
    libc = stdenv.ccCross.libc;
    coreutils = coreutils.crossDrv;
    binutils = binutils.crossDrv;
    cc = cc.crossDrv;
    #
    # This is not the best way to do this. I think the reference should be
    # the style in the gcc-cross-wrapper, but to keep a stable stdenv now I
    # do this sufficient if/else.
    dynamicLinker =
      (if stdenv.cross.arch == "arm" then "ld-linux.so.3" else
       if stdenv.cross.arch == "mips" then "ld.so.1" else
       if stdenv.lib.hasSuffix "pc-gnu" stdenv.cross.config then "ld.so.1" else
       abort "don't know the name of the dynamic linker for this platform");
  };

  meta =
    let cc_ = if cc != null then cc else {}; in
    (if cc_ ? meta then removeAttrs cc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" cc_
        + " (wrapper script)";
    };
}
