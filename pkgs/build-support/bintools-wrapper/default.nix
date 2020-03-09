# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? ""
, stdenvNoCC
, bintools ? null, libc ? null, coreutils ? null, shell ? stdenvNoCC.shell, gnugrep ? null
, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, propagateDoc ? bintools != null && bintools ? man
, extraPackages ? [], extraBuildCommands ? ""
, buildPackages ? {}
, useMacosReexportHack ? false
}:

with stdenvNoCC.lib;

assert nativeTools -> !propagateDoc && nativePrefix != "";
assert !nativeTools ->
  bintools != null && coreutils != null && gnugrep != null;
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

  bintoolsVersion = stdenv.lib.getVersion bintools;
  bintoolsName = stdenv.lib.removePrefix targetPrefix (stdenv.lib.getName bintools);

  libc_bin = if libc == null then null else getBin libc;
  libc_dev = if libc == null then null else getDev libc;
  libc_lib = if libc == null then null else getLib libc;
  bintools_bin = if nativeTools then "" else getBin bintools;
  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = if nativeTools then "" else getBin coreutils;

  # See description in cc-wrapper.
  infixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

  # The dynamic linker has different names on different platforms. This is a
  # shell glob that ought to match it.
  dynamicLinker =
    /**/ if libc == null then null
    else if targetPlatform.libc == "musl"             then "${libc_lib}/lib/ld-musl-*"
    else if targetPlatform.libc == "bionic"           then "/system/bin/linker"
    else if targetPlatform.libc == "nblibc"           then "${libc_lib}/libexec/ld.elf_so"
    else if targetPlatform.system == "i686-linux"     then "${libc_lib}/lib/ld-linux.so.2"
    else if targetPlatform.system == "x86_64-linux"   then "${libc_lib}/lib/ld-linux-x86-64.so.2"
    # ARM with a wildcard, which can be "" or "-armhf".
    else if (with targetPlatform; isAarch32 && isLinux)   then "${libc_lib}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux"  then "${libc_lib}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux"  then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.isMips                     then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.isDarwin                   then "/usr/lib/dyld"
    else if stdenv.lib.hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1"
    else null;

  expand-response-params =
    if buildPackages ? stdenv && buildPackages.stdenv.hasCC && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

in

stdenv.mkDerivation {
  pname = targetPrefix
    + (if name != "" then name else "${bintoolsName}-wrapper");
  version = if bintools == null then null else bintoolsVersion;

  preferLocalBuild = true;

  inherit bintools_bin libc_bin libc_dev libc_lib coreutils_bin;
  shell = getBin shell + shell.shellPath or "";
  gnugrep_bin = if nativeTools then "" else gnugrep;

  inherit targetPrefix infixSalt;

  outputs = [ "out" ] ++ optionals propagateDoc [ "man" "info" ];

  passthru = {
    inherit bintools libc nativeTools nativeLibc nativePrefix;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/lib"))
            (setenv "NIX_${infixSalt}_LDFLAGS" (concat (getenv "NIX_${infixSalt}_LDFLAGS") " -L" arg "/lib")))
          (when (file-directory-p (concat arg "/lib64"))
            (setenv "NIX_${infixSalt}_LDFLAGS" (concat (getenv "NIX_${infixSalt}_LDFLAGS") " -L" arg "/lib64"))))
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
      echo ${nativePrefix} > $out/nix-support/orig-bintools

      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $bintools_bin > $out/nix-support/orig-bintools

      ldPath="${bintools_bin}/bin"
    ''

    + optionalString (targetPlatform.isSunOS && nativePrefix != "") ''
      # Solaris needs an additional ld wrapper.
      ldPath="${nativePrefix}/bin"
      exec="$ldPath/${targetPrefix}ld"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    + ''
      # Create a symlink to as (the assembler).
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

      for variant in ld.gold ld.bfd ld.lld; do
        local underlying=$ldPath/${targetPrefix}$variant
        [[ -e "$underlying" ]] || continue
        wrap ${targetPrefix}$variant ${./ld-wrapper.sh} $underlying
      done
    '';

  emulation = let
    fmt =
      /**/ if targetPlatform.isDarwin  then "mach-o"
      else if targetPlatform.isWindows then "pe"
      else "elf" + toString targetPlatform.parsed.cpu.bits;
    endianPrefix = if targetPlatform.isBigEndian then "big" else "little";
    sep = optionalString (!targetPlatform.isMips && !targetPlatform.isPower) "-";
    arch =
      /**/ if targetPlatform.isAarch64 then endianPrefix + "aarch64"
      else if targetPlatform.isAarch32     then endianPrefix + "arm"
      else if targetPlatform.isx86_64  then "x86-64"
      else if targetPlatform.isx86_32  then "i386"
      else if targetPlatform.isMips    then {
          mips     = "btsmipn32"; # n32 variant
          mipsel   = "ltsmipn32"; # n32 variant
          mips64   = "btsmip";
          mips64el = "ltsmip";
        }.${targetPlatform.parsed.cpu.name}
      else if targetPlatform.isPower then if targetPlatform.isBigEndian then "ppc" else "lppc"
      else if targetPlatform.isSparc then "sparc"
      else if targetPlatform.isMsp430 then "msp430"
      else if targetPlatform.isAvr then "avr"
      else if targetPlatform.isAlpha then "alpha"
      else if targetPlatform.isVc4 then "vc4"
      else throw "unknown emulation for platform: ${targetPlatform.config}";
    in if targetPlatform.useLLVM or false then ""
       else targetPlatform.platform.bfdEmulation or (fmt + sep + arch);

  strictDeps = true;
  depsTargetTargetPropagated = extraPackages;

  wrapperName = "BINTOOLS_WRAPPER";

  setupHooks = [
    ../setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postFixup =
    optionalString (libc != null) (''
      ##
      ## General libc support
      ##

      echo "-L${libc_lib}${libc.libdir or "/lib"}" > $out/nix-support/libc-ldflags

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
      # explicit overrides of the dynamic linker by callers to ld
      # (the *last* value counts, so ours should come first).
      printWords "''${ldflagsBefore[@]}" > $out/nix-support/libc-ldflags-before
    '')

    + optionalString (!nativeTools) ''
      ##
      ## User env support
      ##

      # Propagate the underling unwrapped bintools so that if you
      # install the wrapper, you get tools like objdump (same for any
      # binaries of libc).
      printWords ${bintools_bin} ${if libc == null then "" else libc_bin} > $out/nix-support/propagated-user-env-packages
    ''

    + optionalString propagateDoc ''
      ##
      ## Man page and info support
      ##

      ln -s ${bintools.man} $man
      ln -s ${bintools.info} $info
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

    + optionalString targetPlatform.isAvr ''
      hardening_unsupported_flags+=" relro bindnow"
    ''

    + optionalString (libc != null && targetPlatform.isAvr) ''
      for isa in avr5 avr3 avr4 avr6 avr25 avr31 avr35 avr51 avrxmega2 avrxmega4 avrxmega5 avrxmega6 avrxmega7 tiny-stack; do
        echo "-L${getLib libc}/avr/lib/$isa" >> $out/nix-support/libc-cflags
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

  inherit dynamicLinker expand-response-params;

  # for substitution in utils.bash
  expandResponseParams = "${expand-response-params}/bin/expand-response-params";

  meta =
    let bintools_ = if bintools != null then bintools else {}; in
    (if bintools_ ? meta then removeAttrs bintools.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System binary utilities" bintools_
        + " (wrapper script)";
      priority = 10;
  } // optionalAttrs useMacosReexportHack {
    platforms = stdenv.lib.platforms.darwin;
  };
}
