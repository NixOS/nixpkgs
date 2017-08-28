# The Nixpkgs CC is not directly usable, since it doesn't know where
# the C library and standard header files are. Therefore the compiler
# produced by that package cannot be installed directly in a user
# environment and used from the command line. So we use a wrapper
# script that sets up the right environment variables so that the
# compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, noLibc ? false, nativeLibc, nativePrefix ? ""
, binutils ? null, libc ? null
, coreutils ? null, shell ? stdenv.shell, gnugrep ? null
, extraPackages ? [], extraBuildCommands ? ""
, buildPackages ? {}
, useMacosReexportHack ? false
}:

with stdenv.lib;

assert nativeTools -> nativePrefix != "";
assert !nativeTools ->
  binutils != null && coreutils != null && gnugrep != null;
assert !(nativeLibc && noLibc);
assert (noLibc || nativeLibc) == (libc == null);

let
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  prefix = stdenv.lib.optionalString (targetPlatform != hostPlatform)
                                     (targetPlatform.config + "-");

  binutilsVersion = (builtins.parseDrvName binutils.name).version;
  binutilsName = (builtins.parseDrvName binutils.name).name;

  libc_bin = if libc == null then null else getBin libc;
  libc_dev = if libc == null then null else getDev libc;
  libc_lib = if libc == null then null else getLib libc;
  binutils_bin = if nativeTools then "" else getBin binutils;
  # The wrapper scripts use 'cat' and 'grep', so we may need coreutils.
  coreutils_bin = if nativeTools then "" else getBin coreutils;

  dashlessTarget = stdenv.lib.replaceStrings ["-"] ["_"] targetPlatform.config;

  # See description in cc-wrapper.
  infixSalt = dashlessTarget;

  # The dynamic linker has different names on different platforms. This is a
  # shell glob that ought to match it.
  dynamicLinker =
    /**/ if libc == null then null
    else if targetPlatform.system == "i686-linux"     then "${libc_lib}/lib/ld-linux.so.2"
    else if targetPlatform.system == "x86_64-linux"   then "${libc_lib}/lib/ld-linux-x86-64.so.2"
    # ARM with a wildcard, which can be "" or "-armhf".
    else if targetPlatform.isArm                      then "${libc_lib}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux"  then "${libc_lib}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux"  then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.system == "mips64el-linux" then "${libc_lib}/lib/ld.so.1"
    else if targetPlatform.system == "x86_64-darwin"  then "/usr/lib/dyld"
    else if stdenv.lib.hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1"
    else null;

  expand-response-params =
    if buildPackages.stdenv.cc or null != null && buildPackages.stdenv.cc != "/dev/null"
    then import ../expand-response-params { inherit (buildPackages) stdenv; }
    else "";

in

stdenv.mkDerivation {
  name = prefix
    + (if name != "" then name else "${binutilsName}-wrapper")
    + (stdenv.lib.optionalString (binutils != null && binutilsVersion != "") "-${binutilsVersion}");

  preferLocalBuild = true;

  inherit binutils_bin shell libc_bin libc_dev libc_lib coreutils_bin;
  gnugrep_bin = if nativeTools then "" else gnugrep;

  binPrefix = prefix;
  inherit infixSalt;

  outputs = [ "out" "man" ];

  passthru = {
    inherit libc nativeTools nativeLibc nativePrefix prefix;

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
      set -u

      mkdir -p $out/bin $out/nix-support $man/nix-support

      wrap() {
        local dst="$1"
        local wrapper="$2"
        export prog="$3"
        set +u
        substituteAll "$wrapper" "$out/bin/$dst"
        set -u
        chmod +x "$out/bin/$dst"
      }
    ''

    + (if nativeTools then ''
      echo ${nativePrefix} > $out/nix-support/orig-binutils

      ldPath="${nativePrefix}/bin"
    '' else ''
      echo $binutils_bin > $out/nix-support/orig-binutils

      ldPath="${binutils_bin}/bin"
    ''

    + optionalString (targetPlatform.isSunOS && nativePrefix != "") ''
      # Solaris needs an additional ld wrapper.
      ldPath="${nativePrefix}/bin"
      exec="$ldPath/${prefix}ld"
      wrap ld-solaris ${./ld-solaris-wrapper.sh}
    '')

    + ''
      # Create a symlink to as (the assembler).
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

      set +u
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

      if [ -n "$dynamicLinker" ]; then
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

      # Propagate the underling unwrapped binutils so that if you
      # install the wrapper, you get tools like objdump, the manpages,
      # etc. as well (same for any binaries of libc).
      printWords ${binutils_bin} ${if libc == null then "" else libc_bin} > $out/nix-support/propagated-user-env-packages
    ''

    + ''

      ##
      ## Hardening support
      ##

      # some linkers on some platforms don't support specific -z flags
      export hardening_unsupported_flags=""
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
      set +u
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${./add-hardening.sh} $out/nix-support/add-hardening.sh
      substituteAll ${../cc-wrapper/utils.sh} $out/nix-support/utils.sh

      ##
      ## Extra custom steps
      ##

    ''
    + extraBuildCommands;

  inherit dynamicLinker expand-response-params;

  # for substitution in utils.sh
  expandResponseParams = "${expand-response-params}/bin/expand-response-params";

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
  };

  meta =
    let binutils_ = if binutils != null then binutils else {}; in
    (if binutils_ ? meta then removeAttrs binutils.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System binary utilities" binutils_
        + " (wrapper script)";
  } // optionalAttrs useMacosReexportHack {
    platforms = stdenv.lib.platforms.darwin;
  };
}
