{
  lib,
  stdenv,
  runCommandLocal,
  buildEnv,
  writeText,
  writeShellScriptBin,
  pkgs,
  pkgsHostTarget,
}:

{
  profile ? "",
  targetPkgs ? pkgs: [ ],
  multiPkgs ? pkgs: [ ],
  multiArch ? false, # Whether to include 32bit packages
  includeClosures ? false, # Whether to include closures of all packages
  nativeBuildInputs ? [ ],
  extraBuildCommands ? "",
  extraBuildCommandsMulti ? "",
  extraOutputsToInstall ? [ ],
  ... # for name, or pname+version
}@args:

# HOWTO:
# All packages (most likely programs) returned from targetPkgs will only be
# installed once--matching the host's architecture (64bit on x86_64 and 32bit on
# x86).
#
# Packages (most likely libraries) returned from multiPkgs are installed
# once on x86 systems and twice on x86_64 systems.
# On x86 they are merged with packages from targetPkgs.
# On x86_64 they are added to targetPkgs and in addition their 32bit
# versions are also installed. The final directory structure looks as
# follows:
# /lib32 will include 32bit libraries from multiPkgs
# /lib64 will include 64bit libraries from multiPkgs and targetPkgs
# /lib will link to /lib64

let
  # The splicing code does not handle `pkgsi686Linux` well, so we have to be
  # explicit about which package set it's coming from.
  inherit (pkgsHostTarget) pkgsi686Linux;

  name = if (args ? pname && args ? version) then "${args.pname}-${args.version}" else args.name;

  # "use of glibc_multi is only supported on x86_64-linux"
  isMultiBuild = multiArch && stdenv.system == "x86_64-linux";

  # list of packages (usually programs) which match the host's architecture
  # (which includes stuff from multiPkgs)
  targetPaths = targetPkgs pkgs ++ (if multiPkgs == null then [ ] else multiPkgs pkgs);

  # list of packages which are for x86 (only multiPkgs, only for x86_64 hosts)
  multiPaths = multiPkgs pkgsi686Linux;

  # base packages of the fhsenv
  # these match the host's architecture, glibc_multi is used for multilib
  # builds. glibcLocales must be before glibc or glibc_multi as otherwiese
  # the wrong LOCALE_ARCHIVE will be used where only C.UTF-8 is available.
  baseTargetPaths = with pkgs; [
    glibcLocales
    (if isMultiBuild then glibc_multi else glibc)
    gcc.cc.lib
    bashInteractiveFHS
    coreutils
    less
    shadow
    su
    gawk
    diffutils
    findutils
    gnused
    gnugrep
    gnutar
    gzip
    bzip2
    xz
  ];
  baseMultiPaths = with pkgsi686Linux; [
    gcc.cc.lib
  ];

  ldconfig = writeShellScriptBin "ldconfig" ''
    # due to a glibc bug, 64-bit ldconfig complains about patchelf'd 32-bit libraries, so we use 32-bit ldconfig when we have them
    exec ${
      if isMultiBuild then pkgsi686Linux.glibc.bin else pkgs.glibc.bin
    }/bin/ldconfig -f /etc/ld.so.conf -C /etc/ld.so.cache "$@"
  '';

  etcProfile = pkgs.writeTextFile {
    name = "${name}-fhsenv-profile";
    destination = "/etc/profile";
    text = ''
      export PS1='${name}-fhsenv:\u@\h:\w\$ '
      export LOCALE_ARCHIVE="''${LOCALE_ARCHIVE:-/usr/lib/locale/locale-archive}"
      export PATH="/run/wrappers/bin:/usr/bin:/usr/sbin:$PATH"
      export TZDIR='/etc/zoneinfo'

      # XDG_DATA_DIRS is used by pressure-vessel (steam proton) and vulkan loaders to find the corresponding icd
      export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}/run/opengl-driver/share:/run/opengl-driver-32/share

      # Following XDG spec [1], XDG_DATA_DIRS should default to "/usr/local/share:/usr/share".
      # In nix, it is commonly set without containing these values, so we add them as fallback.
      #
      # [1] <https://specifications.freedesktop.org/basedir-spec/latest>
      case ":$XDG_DATA_DIRS:" in
        *:/usr/local/share:*) ;;
        *) export XDG_DATA_DIRS="$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}/usr/local/share" ;;
      esac
      case ":$XDG_DATA_DIRS:" in
        *:/usr/share:*) ;;
        *) export XDG_DATA_DIRS="$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}/usr/share" ;;
      esac

      # Force compilers and other tools to look in default search paths
      unset NIX_ENFORCE_PURITY
      export NIX_BINTOOLS_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt}=1
      export NIX_CC_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt}=1
      export NIX_CFLAGS_COMPILE='-idirafter /usr/include'
      export NIX_CFLAGS_LINK='-L/usr/lib -L/usr/lib32'
      export NIX_LDFLAGS='-L/usr/lib -L/usr/lib32'
      export PKG_CONFIG_PATH=/usr/lib/pkgconfig
      export ACLOCAL_PATH=/usr/share/aclocal

      # GStreamer searches for plugins relative to its real binary's location
      # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/bd97973ce0f2c5495bcda5cccd4f7ef7dcb7febc
      export GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0:/usr/lib32/gstreamer-1.0

      ${profile}
    '';
  };

  ensureGsettingsSchemasIsDirectory =
    runCommandLocal "fhsenv-ensure-gsettings-schemas-directory" { }
      ''
        mkdir -p $out/share/glib-2.0/schemas
        touch $out/share/glib-2.0/schemas/.keep
      '';

  # Shamelessly stolen (and cleaned up) from original buildEnv.
  # Should be semantically equivalent, except we also take
  # a list of default extra outputs that will be installed
  # for derivations that don't explicitly specify one.
  # Note that this is not the same as `extraOutputsToInstall`,
  # as that will apply even to derivations with an output
  # explicitly specified, so this does change the behavior
  # very slightly for that particular edge case.
  pickOutputs =
    let
      pickOutputsOne =
        outputs: drv:
        let
          isSpecifiedOutput = drv.outputSpecified or false;
          outputsToInstall = drv.meta.outputsToInstall or null;
          pickedOutputs =
            if isSpecifiedOutput || outputsToInstall == null then
              [ drv ]
            else
              map (out: drv.${out} or null) (outputsToInstall ++ outputs);
          extraOutputs = map (out: drv.${out} or null) extraOutputsToInstall;
          cleanOutputs = lib.filter (o: o != null) (pickedOutputs ++ extraOutputs);
        in
        {
          paths = cleanOutputs;
          priority = drv.meta.priority or lib.meta.defaultPriority;
        };
    in
    paths: outputs: map (pickOutputsOne outputs) paths;

  paths =
    let
      basePaths = [
        etcProfile
        # ldconfig wrapper must come first so it overrides the original ldconfig
        ldconfig
        # magic package that just creates a directory, to ensure that
        # the entire directory can't be a symlink, as we will write
        # compiled schemas to it
        ensureGsettingsSchemasIsDirectory
      ]
      ++ baseTargetPaths
      ++ targetPaths;
    in
    pickOutputs basePaths [
      "out"
      "lib"
      "bin"
    ];

  paths32 = lib.optionals isMultiBuild (
    let
      basePaths = baseMultiPaths ++ multiPaths;
    in
    pickOutputs basePaths [
      "out"
      "lib"
    ]
  );

  allPaths = paths ++ paths32;

  rootfs-builder = pkgs.buildPackages.rustPlatform.buildRustPackage {
    name = "fhs-rootfs-bulder";
    src = ./rootfs-builder;
    cargoLock.lockFile = ./rootfs-builder/Cargo.lock;
    doCheck = false;
  };

  rootfs =
    pkgs.runCommand "${name}-fhsenv-rootfs"
      {
        __structuredAttrs = true;
        exportReferencesGraph.graph = lib.concatMap (p: p.paths) allPaths;
        inherit
          paths
          paths32
          isMultiBuild
          includeClosures
          ;
        nativeBuildInputs = [ pkgs.jq ];
      }
      ''
        ${rootfs-builder}/bin/rootfs-builder

        # create a bunch of symlinks for usrmerge
        ln -s /usr/bin $out/bin
        ln -s /usr/sbin $out/sbin
        ln -s /usr/lib $out/lib
        ln -s /usr/lib32 $out/lib32
        ln -s /usr/lib64 $out/lib64
        ln -s /usr/lib64 $out/usr/lib
        ln -s /usr/libexec $out/libexec

        # symlink 32-bit ld-linux so it's visible in /lib
        if [ -e $out/usr/lib32/ld-linux.so.2 ]; then
          ln -s /usr/lib32/ld-linux.so.2 $out/usr/lib64/ld-linux.so.2
        fi

        # symlink /etc/mtab -> /proc/mounts (compat for old userspace progs)
        ln -s /proc/mounts $out/etc/mtab

        if [[ -d $out/usr/share/gsettings-schemas/ ]]; then
          for d in $out/usr/share/gsettings-schemas/*; do
            # Force symlink, in case there are duplicates
            ln -fsr $d/glib-2.0/schemas/*.xml $out/usr/share/glib-2.0/schemas
            ln -fsr $d/glib-2.0/schemas/*.gschema.override $out/usr/share/glib-2.0/schemas
          done
          ${pkgs.pkgsBuildBuild.glib.dev}/bin/glib-compile-schemas $out/usr/share/glib-2.0/schemas
        fi

        ${extraBuildCommands}
        ${lib.optionalString isMultiBuild extraBuildCommandsMulti}
      '';
in
rootfs
