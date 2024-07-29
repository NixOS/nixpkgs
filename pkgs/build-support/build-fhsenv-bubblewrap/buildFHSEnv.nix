{ lib
, stdenv
, runCommandLocal
, buildEnv
, writeText
, writeShellScriptBin
, pkgs
, pkgsi686Linux
}:

{ profile ? ""
, targetPkgs ? pkgs: []
, multiPkgs ? pkgs: []
, multiArch ? false # Whether to include 32bit packages
, extraBuildCommands ? ""
, extraBuildCommandsMulti ? ""
, extraOutputsToInstall ? []
, ... # for name, or pname+version
} @ args:

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
# /lib will link to /lib32

let
  inherit (stdenv) is64bit;

  name = if (args ? pname && args ? version)
    then "${args.pname}-${args.version}"
    else args.name;

  # "use of glibc_multi is only supported on x86_64-linux"
  isMultiBuild = multiArch && stdenv.system == "x86_64-linux";
  isTargetBuild = !isMultiBuild;

  # list of packages (usually programs) which match the host's architecture
  # (which includes stuff from multiPkgs)
  targetPaths = targetPkgs pkgs ++ (if multiPkgs == null then [] else multiPkgs pkgs);

  # list of packages which are for x86 (only multiPkgs, only for x86_64 hosts)
  multiPaths = multiPkgs pkgsi686Linux;

  # base packages of the fhsenv
  # these match the host's architecture, glibc_multi is used for multilib
  # builds. glibcLocales must be before glibc or glibc_multi as otherwiese
  # the wrong LOCALE_ARCHIVE will be used where only C.UTF-8 is available.
  baseTargetPaths = with pkgs; [
    glibcLocales
    (if isMultiBuild then glibc_multi else glibc)
    (toString gcc.cc.lib)
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
    (toString gcc.cc.lib)
  ];

  ldconfig = writeShellScriptBin "ldconfig" ''
    # due to a glibc bug, 64-bit ldconfig complains about patchelf'd 32-bit libraries, so we use 32-bit ldconfig when we have them
    exec ${if isMultiBuild then pkgsi686Linux.glibc.bin else pkgs.glibc.bin}/bin/ldconfig -f /etc/ld.so.conf -C /etc/ld.so.cache "$@"
  '';

  etcProfile = writeText "profile" ''
    export PS1='${name}-fhsenv:\u@\h:\w\$ '
    export LOCALE_ARCHIVE='/usr/lib/locale/locale-archive'
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export PATH="/run/wrappers/bin:/usr/bin:/usr/sbin:$PATH"
    export TZDIR='/etc/zoneinfo'

    # XDG_DATA_DIRS is used by pressure-vessel (steam proton) and vulkan loaders to find the corresponding icd
    export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}/run/opengl-driver/share:/run/opengl-driver-32/share

    # Following XDG spec [1], XDG_DATA_DIRS should default to "/usr/local/share:/usr/share".
    # In nix, it is commonly set without containing these values, so we add them as fallback.
    #
    # [1] <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>
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

  # Compose /etc for the fhs environment
  etcPkg = runCommandLocal "${name}-fhs-etc" { } ''
    mkdir -p $out/etc
    pushd $out/etc

    # environment variables
    ln -s ${etcProfile} profile

    # symlink /etc/mtab -> /proc/mounts (compat for old userspace progs)
    ln -s /proc/mounts mtab
  '';

  # Composes a /usr-like directory structure
  staticUsrProfileTarget = buildEnv {
    name = "${name}-usr-target";
    # ldconfig wrapper must come first so it overrides the original ldconfig
    paths = [ etcPkg ldconfig ] ++ baseTargetPaths ++ targetPaths;
    extraOutputsToInstall = [ "out" "lib" "bin" ] ++ extraOutputsToInstall;
    ignoreCollisions = true;
    postBuild = ''
      if [[ -d  $out/share/gsettings-schemas/ ]]; then
          # Recreate the standard schemas directory if its a symlink to make it writable
          if [[ -L $out/share/glib-2.0 ]]; then
              target=$(readlink $out/share/glib-2.0)
              rm $out/share/glib-2.0
              mkdir $out/share/glib-2.0
              ln -fs $target/* $out/share/glib-2.0
          fi

          if [[ -L $out/share/glib-2.0/schemas ]]; then
              target=$(readlink $out/share/glib-2.0/schemas)
              rm $out/share/glib-2.0/schemas
              mkdir $out/share/glib-2.0/schemas
              ln -fs $target/* $out/share/glib-2.0/schemas
          fi

          mkdir -p $out/share/glib-2.0/schemas

          for d in $out/share/gsettings-schemas/*; do
              # Force symlink, in case there are duplicates
              ln -fs $d/glib-2.0/schemas/*.xml $out/share/glib-2.0/schemas
              ln -fs $d/glib-2.0/schemas/*.gschema.override $out/share/glib-2.0/schemas
          done

          # and compile them
          ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
      fi
    '';
  };

  staticUsrProfileMulti = buildEnv {
    name = "${name}-usr-multi";
    paths = baseMultiPaths ++ multiPaths;
    extraOutputsToInstall = [ "out" "lib" ] ++ extraOutputsToInstall;
    ignoreCollisions = true;
  };

  # setup library paths only for the targeted architecture
  setupLibDirsTarget = ''
    # link content of targetPaths
    cp -rsHf ${staticUsrProfileTarget}/lib lib
    ln -s lib lib${if is64bit then "64" else "32"}
  '';

  # setup /lib, /lib32 and /lib64
  setupLibDirsMulti = ''
    mkdir -m0755 lib32
    mkdir -m0755 lib64
    ln -s lib64 lib

    # copy glibc stuff
    cp -rsHf ${staticUsrProfileTarget}/lib/32/* lib32/
    chmod u+w -R lib32/

    # copy content of multiPaths (32bit libs)
    if [ -d ${staticUsrProfileMulti}/lib ]; then
      cp -rsHf ${staticUsrProfileMulti}/lib/* lib32/
      chmod u+w -R lib32/
    fi

    # copy content of targetPaths (64bit libs)
    cp -rsHf ${staticUsrProfileTarget}/lib/* lib64/
    chmod u+w -R lib64/

    # symlink 32-bit ld-linux.so
    ln -Ls ${staticUsrProfileTarget}/lib/32/ld-linux.so.2 lib/
  '';

  setupLibDirs = if isTargetBuild
                 then setupLibDirsTarget
                 else setupLibDirsMulti;

  # the target profile is the actual profile that will be used for the fhs
  setupTargetProfile = ''
    mkdir -m0755 usr
    pushd usr

    ${setupLibDirs}

    '' + lib.optionalString isMultiBuild ''
    if [ -d "${staticUsrProfileMulti}/share" ]; then
      cp -rLf ${staticUsrProfileMulti}/share share
    fi
    '' + ''
    if [ -d "${staticUsrProfileTarget}/share" ]; then
      if [ -d share ]; then
        chmod -R 755 share
        cp -rLTf ${staticUsrProfileTarget}/share share
      else
        cp -rsHf ${staticUsrProfileTarget}/share share
      fi
    fi
    for i in bin sbin include; do
      if [ -d "${staticUsrProfileTarget}/$i" ]; then
        cp -rsHf "${staticUsrProfileTarget}/$i" "$i"
      fi
    done
    cd ..

    for i in var etc opt; do
      if [ -d "${staticUsrProfileTarget}/$i" ]; then
        cp -rsHf "${staticUsrProfileTarget}/$i" "$i"
      fi
    done
    for i in usr/{bin,sbin,lib,lib32,lib64}; do
      if [ -d "$i" ]; then
        ln -s "$i"
      fi
    done

    popd
  '';

in runCommandLocal "${name}-fhs" {
  passthru = {
    inherit args baseTargetPaths targetPaths baseMultiPaths ldconfig isMultiBuild;
  };
} ''
  mkdir -p $out
  pushd $out

  ${setupTargetProfile}
  ${extraBuildCommands}
  ${lib.optionalString isMultiBuild extraBuildCommandsMulti}
''
