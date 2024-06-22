# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? ""
, lib
, stdenvNoCC
, runtimeShell
, bintools ? null, libc ? null, coreutils ? null, gnugrep ? null
, netbsd ? null, netbsdCross ? null
, sharedLibraryLoader ?
  if libc == null then
    null
  else if stdenvNoCC.targetPlatform.isNetBSD then
    if !(targetPackages ? netbsdCross) then
      netbsd.ld_elf_so
    else if libc != targetPackages.netbsdCross.headers then
      targetPackages.netbsdCross.ld_elf_so
    else
      null
  else
    lib.getLib libc
, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, propagateDoc ? bintools != null && bintools ? man
, extraPackages ? [], extraBuildCommands ? ""
, isGNU ? bintools.isGNU or false
, isLLVM ? bintools.isLLVM or false
, isCCTools ? bintools.isCCTools or false
, expand-response-params
, targetPackages ? {}
, useMacosReexportHack ? false
, wrapGas ? false

# Note: the hardening flags are part of the bintools-wrapper, rather than
# the cc-wrapper, because a few of them are handled by the linker.
, defaultHardeningFlags ? [
    "bindnow"
    "format"
    "fortify"
    "fortify3"
    "pic"
    "relro"
    "stackprotector"
    "strictoverflow"
  ] ++ lib.optional (with stdenvNoCC;
    # Musl-based platforms will keep "pie", other platforms will not.
    # If you change this, make sure to update section `{#sec-hardening-in-nixpkgs}`
    # in the nixpkgs manual to inform users about the defaults.
    targetPlatform.libc == "musl"
    # Except when:
    #    - static aarch64, where compilation works, but produces segfaulting dynamically linked binaries.
    #    - static armv7l, where compilation fails.
    && !(targetPlatform.isAarch && targetPlatform.isStatic)
  ) "pie"

# Darwin code signing support utilities
, postLinkSignHook ? null, signingUtils ? null
}:

assert propagateDoc -> bintools ? man;
assert nativeTools -> !propagateDoc && nativePrefix != "";
assert !nativeTools -> bintools != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

let
  inherit (lib)
    attrByPath
    concatStringsSep
    getBin
    getDev
    getLib
    getName
    getVersion
    hasSuffix
    optional
    optionalAttrs
    optionals
    optionalString
    platforms
    removePrefix
    replaceStrings
    ;

  inherit (stdenvNoCC) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = optionalString (targetPlatform != hostPlatform)
                                        (targetPlatform.config + "-");

  bintoolsVersion = getVersion bintools;
  bintoolsName = removePrefix targetPrefix (getName bintools);

  libc_bin = optionalString (libc != null) (getBin libc);
  libc_dev = optionalString (libc != null) (getDev libc);
  libc_lib = optionalString (libc != null) (getLib libc);
  bintools_bin = optionalString (!nativeTools) (getBin bintools);
  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = optionalString (!nativeTools) (getBin coreutils);

  # See description in cc-wrapper.
  suffixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

  # The dynamic linker has different names on different platforms. This is a
  # shell glob that ought to match it.
  dynamicLinker =
    /**/ if sharedLibraryLoader == null then ""
    else if targetPlatform.libc == "musl"             then "${sharedLibraryLoader}/lib/ld-musl-*"
    else if targetPlatform.libc == "uclibc"           then "${sharedLibraryLoader}/lib/ld*-uClibc.so.1"
    else if (targetPlatform.libc == "bionic" && targetPlatform.is32bit) then "/system/bin/linker"
    else if (targetPlatform.libc == "bionic" && targetPlatform.is64bit) then "/system/bin/linker64"
    else if targetPlatform.libc == "nblibc"           then "${sharedLibraryLoader}/libexec/ld.elf_so"
    else if targetPlatform.system == "i686-linux"     then "${sharedLibraryLoader}/lib/ld-linux.so.2"
    else if targetPlatform.system == "x86_64-linux"   then "${sharedLibraryLoader}/lib/ld-linux-x86-64.so.2"
    # ELFv1 (.1) or ELFv2 (.2) ABI
    else if targetPlatform.isPower64                  then "${sharedLibraryLoader}/lib/ld64.so.*"
    # ARM with a wildcard, which can be "" or "-armhf".
    else if (with targetPlatform; isAarch32 && isLinux)   then "${sharedLibraryLoader}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux"  then "${sharedLibraryLoader}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux"  then "${sharedLibraryLoader}/lib/ld.so.1"
    else if targetPlatform.isMips                     then "${sharedLibraryLoader}/lib/ld.so.1"
    # `ld-linux-riscv{32,64}-<abi>.so.1`
    else if targetPlatform.isRiscV                    then "${sharedLibraryLoader}/lib/ld-linux-riscv*.so.1"
    else if targetPlatform.isLoongArch64              then "${sharedLibraryLoader}/lib/ld-linux-loongarch*.so.1"
    else if targetPlatform.isDarwin                   then "/usr/lib/dyld"
    else if targetPlatform.isFreeBSD                  then "${sharedLibraryLoader}/libexec/ld-elf.so.1"
    else if hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1"
    else "";

in

stdenvNoCC.mkDerivation {
  pname = targetPrefix
    + (if name != "" then name else "${bintoolsName}-wrapper");
  version = optionalString (bintools != null) bintoolsVersion;

  preferLocalBuild = true;

  outputs = [ "out" ] ++ optionals propagateDoc ([ "man" ] ++ optional (bintools ? info) "info");

  passthru = {
    inherit targetPrefix suffixSalt;
    inherit bintools libc nativeTools nativeLibc nativePrefix isGNU isLLVM;

    emacsBufferSetup = pkgs: ''
      ; We should handle propagation here too
      (mapc
        (lambda (arg)
          (when (file-directory-p (concat arg "/lib"))
            (setenv "NIX_LDFLAGS_${suffixSalt}" (concat (getenv "NIX_LDFLAGS_${suffixSalt}") " -L" arg "/lib")))
          (when (file-directory-p (concat arg "/lib64"))
            (setenv "NIX_LDFLAGS_${suffixSalt}" (concat (getenv "NIX_LDFLAGS_${suffixSalt}") " -L" arg "/lib64"))))
        '(${concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';

    inherit defaultHardeningFlags;
  };

  dontBuild = true;
  dontConfigure = true;

  enableParallelBuilding = true;

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
        export use_response_file_by_default=${if isCCTools then "1" else "0"}
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

    # Solaris needs an additional ld wrapper.
    + optionalString (targetPlatform.isSunOS && nativePrefix != "") ''
      ldPath="${nativePrefix}/bin"
      exec="$ldPath/${targetPrefix}ld"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    # If we are asked to wrap `gas` and this bintools has it,
    # then symlink it (`as` will be symlinked next).
    # This is mainly for the wrapped gnat-bootstrap on x86-64 Darwin,
    # as it must have both the GNU assembler from cctools (installed as `gas`)
    # and the Clang integrated assembler (installed as `as`).
    # See pkgs/os-specific/darwin/binutils/default.nix for details.
    + optionalString wrapGas ''
      if [ -e $ldPath/${targetPrefix}gas ]; then
        ln -s $ldPath/${targetPrefix}gas $out/bin/${targetPrefix}gas
      fi
    ''

    # Create symlinks for rest of the binaries.
    + ''
      for binary in objdump objcopy size strings as ar nm gprof dwp c++filt addr2line \
          ranlib readelf elfedit dlltool dllwrap windmc windres; do
        if [ -e $ldPath/${targetPrefix}''${binary} ]; then
          ln -s $ldPath/${targetPrefix}''${binary} $out/bin/${targetPrefix}''${binary}
        fi
      done

    '' + (if !useMacosReexportHack then ''
      if [ -e ''${ld:-$ldPath/${targetPrefix}ld} ]; then
        wrap ${targetPrefix}ld ${./ld-wrapper.sh} ''${ld:-$ldPath/${targetPrefix}ld}
      fi
    '' else ''
      ldInner="${targetPrefix}ld-reexport-delegate"
      wrap "$ldInner" ${./macos-sierra-reexport-hack.bash} ''${ld:-$ldPath/${targetPrefix}ld}
      wrap "${targetPrefix}ld" ${./ld-wrapper.sh} "$out/bin/$ldInner"
      unset ldInner
    '') + ''

      for variant in $ldPath/${targetPrefix}ld.*; do
        basename=$(basename "$variant")
        wrap $basename ${./ld-wrapper.sh} $variant
      done
    '';

  strictDeps = true;
  depsTargetTargetPropagated = extraPackages;

  setupHooks = [
    ../setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postFixup =
    ##
    ## General libc support
    ##
    optionalString (libc != null) (''
      touch "$out/nix-support/libc-ldflags"
      echo "-L${libc_lib}${libc.libdir or "/lib"}" >> $out/nix-support/libc-ldflags

      echo "${libc_lib}" > $out/nix-support/orig-libc
      echo "${libc_dev}" > $out/nix-support/orig-libc-dev
    ''

    ##
    ## Dynamic linker support
    ##
    + optionalString (sharedLibraryLoader != null) ''
      if [[ -z ''${dynamicLinker+x} ]]; then
        echo "Don't know the name of the dynamic linker for platform '${targetPlatform.config}', so guessing instead." >&2
        local dynamicLinker="${sharedLibraryLoader}/lib/ld*.so.?"
      fi
    ''

    # Expand globs to fill array of options
    + ''
      dynamicLinker=($dynamicLinker)

      case ''${#dynamicLinker[@]} in
        0) echo "No dynamic linker found for platform '${targetPlatform.config}'." >&2;;
        1) echo "Using dynamic linker: '$dynamicLinker'" >&2;;
        *) echo "Multiple dynamic linkers found for platform '${targetPlatform.config}'." >&2;;
      esac

      if [ -n "''${dynamicLinker-}" ]; then
        echo $dynamicLinker > $out/nix-support/dynamic-linker

        ${if targetPlatform.isDarwin then ''
          printf "export LD_DYLD_PATH=%q\n" "$dynamicLinker" >> $out/nix-support/setup-hook
        '' else optionalString (sharedLibraryLoader != null) ''
          if [ -e ${sharedLibraryLoader}/lib/32/ld-linux.so.2 ]; then
            echo ${sharedLibraryLoader}/lib/32/ld-linux.so.2 > $out/nix-support/dynamic-linker-m32
          fi
          touch $out/nix-support/ld-set-dynamic-linker
        ''}
      fi
    '')

    ##
    ## User env support
    ##

    # Propagate the underling unwrapped bintools so that if you
    # install the wrapper, you get tools like objdump (same for any
    # binaries of libc).
    + optionalString (!nativeTools) ''
      printWords ${bintools_bin} ${optionalString (libc != null) libc_bin} > $out/nix-support/propagated-user-env-packages
    ''

    ##
    ## Man page and info support
    ##
    + optionalString propagateDoc (''
      ln -s ${bintools.man} $man
    '' + optionalString (bintools ? info) ''
      ln -s ${bintools.info} $info
    '')

    ##
    ## Hardening support
    ##

    # some linkers on some platforms don't support specific -z flags
    + ''
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

    + optionalString (targetPlatform.isAvr || targetPlatform.isWindows) ''
      hardening_unsupported_flags+=" relro bindnow"
    ''

    + optionalString (libc != null && targetPlatform.isAvr) ''
      for isa in avr5 avr3 avr4 avr6 avr25 avr31 avr35 avr51 avrxmega2 avrxmega4 avrxmega5 avrxmega6 avrxmega7 tiny-stack; do
        echo "-L${getLib libc}/avr/lib/$isa" >> $out/nix-support/libc-cflags
      done
    ''

    + optionalString targetPlatform.isDarwin ''
      echo "-arch ${targetPlatform.darwinArch}" >> $out/nix-support/libc-ldflags
    ''

    ##
    ## GNU specific extra strip flags
    ##

    # TODO(@sternenseemann): make a generic strip wrapper?
    + optionalString (bintools.isGNU or false) ''
      wrap ${targetPrefix}strip ${./gnu-binutils-strip-wrapper.sh} \
        "${bintools_bin}/bin/${targetPrefix}strip"
    ''

    ###
    ### Remove certain timestamps from final binaries
    ###
    + optionalString (targetPlatform.isDarwin && !(bintools.isGNU or false)) ''
      echo "export ZERO_AR_DATE=1" >> $out/nix-support/setup-hook
    ''

    + ''
      for flags in "$out/nix-support"/*flags*; do
        substituteInPlace "$flags" --replace $'\n' ' '
      done

      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${./add-hardening.sh} $out/nix-support/add-hardening.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash
    ''

    ###
    ### Ensure consistent LC_VERSION_MIN_MACOSX
    ###
    + optionalString targetPlatform.isDarwin (
      let
        inherit (targetPlatform)
          darwinPlatform darwinSdkVersion
          darwinMinVersion darwinMinVersionVariable;
      in ''
        export darwinPlatform=${darwinPlatform}
        export darwinMinVersion=${darwinMinVersion}
        export darwinSdkVersion=${darwinSdkVersion}
        export darwinMinVersionVariable=${darwinMinVersionVariable}
        substituteAll ${./add-darwin-ldflags-before.sh} $out/nix-support/add-local-ldflags-before.sh
      ''
    )

    ##
    ## Code signing on Apple Silicon
    ##
    + optionalString (targetPlatform.isDarwin && targetPlatform.isAarch64) ''
      echo 'source ${postLinkSignHook}' >> $out/nix-support/post-link-hook

      export signingUtils=${signingUtils}

      wrap \
        ${targetPrefix}install_name_tool \
        ${./darwin-install_name_tool-wrapper.sh} \
        "${bintools_bin}/bin/${targetPrefix}install_name_tool"

      wrap \
        ${targetPrefix}strip ${./darwin-strip-wrapper.sh} \
        "${bintools_bin}/bin/${targetPrefix}strip"
    ''

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands;

  env = {
    # for substitution in utils.bash
    # TODO(@sternenseemann): invent something cleaner than passing in "" in case of absence
    expandResponseParams = "${expand-response-params}/bin/expand-response-params";
    # TODO(@sternenseemann): rename env var via stdenv rebuild
    shell = (getBin runtimeShell + runtimeShell.shellPath or "");
    gnugrep_bin = optionalString (!nativeTools) gnugrep;
    wrapperName = "BINTOOLS_WRAPPER";
    inherit dynamicLinker targetPrefix suffixSalt coreutils_bin;
    inherit bintools_bin libc_bin libc_dev libc_lib;
    default_hardening_flags_str = builtins.toString defaultHardeningFlags;
  };

  meta =
    let bintools_ = optionalAttrs (bintools != null) bintools; in
    (optionalAttrs (bintools_ ? meta) (removeAttrs bintools.meta ["priority"])) //
    { description =
        attrByPath ["meta" "description"] "System binary utilities" bintools_
        + " (wrapper script)";
      priority = 10;
  } // optionalAttrs useMacosReexportHack {
    platforms = platforms.darwin;
  };
}
