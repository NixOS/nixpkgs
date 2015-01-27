# The Nixpkgs GCC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, nativeLibc, nativePrefix ? ""
, gcc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null, extraPackages ? []
, setupHook ? ./setup-hook.sh
}:

with stdenv.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> gcc != null && binutils != null && coreutils != null;
assert !nativeLibc -> libc != null;

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper.
assert gcc.langVhdl or false -> zlib != null;

let

  gccVersion = (builtins.parseDrvName gcc.name).version;
  gccName = (builtins.parseDrvName gcc.name).name;

in

stdenv.mkDerivation {
  name =
    (if name != "" then name else gccName + "-wrapper") +
    (if gcc != null && gccVersion != "" then "-" + gccVersion else "");

  preferLocalBuild = true;

  inherit gcc shell;
  libc = if nativeLibc then null else libc;
  binutils = if nativeTools then null else binutils;
  # The wrapper scripts use 'cat', so we may need coreutils.
  coreutils = if nativeTools then null else coreutils;

  passthru = { inherit nativeTools nativeLibc nativePrefix; };

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

    + optionalString (!nativeLibc) ''
      dynamicLinker="$libc/lib/$dynamicLinker"
      echo $dynamicLinker > $out/nix-support/dynamic-linker

      if [ -e $libc/lib/32/ld-linux.so.2 ]; then
        echo $libc/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
      fi

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
      echo "-B$libc/lib/ -idirafter $libc/include -idirafter $gcc/lib/gcc/*/*/include-fixed" > $out/nix-support/libc-cflags

      echo "-L$libc/lib" > $out/nix-support/libc-ldflags

      # The dynamic linker is passed in `ldflagsBefore' to allow
      # explicit overrides of the dynamic linker by callers to gcc/ld
      # (the *last* value counts, so ours should come first).
      echo "-dynamic-linker" $dynamicLinker > $out/nix-support/libc-ldflags-before

      echo $libc > $out/nix-support/orig-libc
    ''

    + (if nativeTools then ''
      gccPath="${nativePrefix}/bin"
      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $gcc > $out/nix-support/orig-gcc

      # GCC shows $gcc/lib in `gcc -print-search-dirs', but not
      # $gcc/lib64 (even though it does actually search there...)..
      # This confuses libtool.  So add it to the compiler tool search
      # path explicitly.
      if [ -e "$gcc/lib64" -a ! -L "$gcc/lib64" ]; then
        gccLDFlags+=" -L$gcc/lib64"
        gccCFlags+=" -B$gcc/lib64"
      fi
      gccLDFlags+=" -L$gcc/lib"

      ${optionalString gcc.langVhdl or false ''
        gccLDFlags+=" -L${zlib}/lib"
      ''}

      # Find the gcc libraries path (may work only without multilib).
      ${optionalString gcc.langAda or false ''
        basePath=`echo $gcc/lib/*/*/*`
        gccCFlags+=" -B$basePath -I$basePath/adainclude"
        gnatCFlags="-aI$basePath/adainclude -aO$basePath/adalib"
        echo "$gnatCFlags" > $out/nix-support/gnat-cflags
      ''}

      echo "$gccLDFlags" > $out/nix-support/gcc-ldflags
      echo "$gccCFlags" > $out/nix-support/gcc-cflags

      gccPath="$gcc/bin"
      ldPath="$binutils/bin"

      # Propagate the wrapped gcc so that if you install the wrapper,
      # you get tools like gcov, the manpages, etc. as well (including
      # for binutils and Glibc).
      echo $gcc $binutils $libc > $out/nix-support/propagated-user-env-packages

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
      # gcc-wrapper is installed in a user environment, as it ensures that
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

      if [ -e $gccPath/gcc ]; then
        wrap gcc ${./gcc-wrapper.sh} $gccPath/gcc
        ln -s gcc $out/bin/cc
      elif [ -e $gccPath/clang ]; then
        wrap clang ${./gcc-wrapper.sh} $gccPath/clang
        ln -s clang $out/bin/cc
      fi

      if [ -e $gccPath/g++ ]; then
        wrap g++ ${./gcc-wrapper.sh} $gccPath/g++
        ln -s g++ $out/bin/c++
      elif [ -e $gccPath/clang++ ]; then
        wrap clang++ ${./gcc-wrapper.sh} $gccPath/clang++
        ln -s clang++ $out/bin/c++
      fi

      if [ -e $gccPath/cpp ]; then
        wrap cpp ${./gcc-wrapper.sh} $gccPath/cpp
      fi
    ''

    + optionalString gcc.langFortran or false ''
      wrap gfortran ${./gcc-wrapper.sh} $gccPath/gfortran
      ln -sv gfortran $out/bin/g77
      ln -sv gfortran $out/bin/f77
    ''

    + optionalString gcc.langJava or false ''
      wrap gcj ${./gcc-wrapper.sh} $gccPath/gcj
    ''

    + optionalString gcc.langGo or false ''
      wrap gccgo ${./gcc-wrapper.sh} $gccPath/gccgo
    ''

    + optionalString gcc.langAda or false ''
      wrap gnatgcc ${./gcc-wrapper.sh} $gccPath/gnatgcc
      wrap gnatmake ${./gnat-wrapper.sh} $gccPath/gnatmake
      wrap gnatbind ${./gnat-wrapper.sh} $gccPath/gnatbind
      wrap gnatlink ${./gnatlink-wrapper.sh} $gccPath/gnatlink
    ''

    + optionalString gcc.langVhdl or false ''
      ln -s $gccPath/ghdl $out/bin/ghdl
    ''

    + ''
      substituteAll ${setupHook} $out/nix-support/setup-hook
      substituteAll ${./add-flags} $out/nix-support/add-flags.sh
      cp -p ${./utils.sh} $out/nix-support/utils.sh

      if [ -e $out/bin/clang ]; then
        echo 'export CC; : ''${CC:=clang}' >> $out/nix-support/setup-hook
      fi

      if [ -e $out/bin/clang++ ]; then
        echo 'export CXX; : ''${CXX:=clang++}' >> $out/nix-support/setup-hook
      fi
    '';

  # The dynamic linker has different names on different Linux platforms.
  dynamicLinker =
    if !nativeLibc then
      (if stdenv.system == "i686-linux" then "ld-linux.so.2" else
       if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2" else
       # ARM with a wildcard, which can be "" or "-armhf".
       if stdenv.isArm then "ld-linux*.so.3" else
       if stdenv.system == "powerpc-linux" then "ld.so.1" else
       if stdenv.system == "mips64el-linux" then "ld.so.1" else
       abort "Don't know the name of the dynamic linker for this platform.")
    else "";

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
    libc = stdenv.ccCross.libc;
    coreutils = coreutils.crossDrv;
    binutils = binutils.crossDrv;
    gcc = gcc.crossDrv;
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
    let gcc_ = if gcc != null then gcc else {}; in
    (if gcc_ ? meta then removeAttrs gcc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" gcc_
        + " (wrapper script)";
    };
}
