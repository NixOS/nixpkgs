{ stdenv, buildEnv, writeText, pkgs, pkgsi686Linux, system }:

{ name, profile ? ""
, targetPkgs ? pkgs: [], multiPkgs ? pkgs: []
, extraBuildCommands ? "", extraBuildCommandsMulti ? ""
, extraOutputsToInstall ? []
}:

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
  is64Bit = system == "x86_64-linux";
  isMultiBuild  = multiPkgs != null && is64Bit;
  isTargetBuild = !isMultiBuild;

  # list of packages (usually programs) which are only be installed for the
  # host's architecture
  targetPaths = targetPkgs pkgs ++ (if multiPkgs == null then [] else multiPkgs pkgs);

  # list of packages which are installed for both x86 and x86_64 on x86_64
  # systems
  multiPaths = multiPkgs pkgsi686Linux;

  # base packages of the chroot
  # these match the host's architecture, glibc_multi is used for multilib
  # builds.
  basePkgs = with pkgs;
    [ (if isMultiBuild then glibc_multi else glibc)
      (toString gcc.cc.lib) bashInteractive coreutils less shadow su
      gawk diffutils findutils gnused gnugrep
      gnutar gzip bzip2 xz glibcLocales
    ];
  baseMultiPkgs = with pkgsi686Linux;
    [ (toString gcc.cc.lib)
    ];

  etcProfile = writeText "profile" ''
    export PS1='${name}-chrootenv:\u@\h:\w\$ '
    export LOCALE_ARCHIVE='/usr/lib/locale/locale-archive'
    export LD_LIBRARY_PATH='/run/opengl-driver/lib:/run/opengl-driver-32/lib:/usr/lib:/usr/lib32'
    export PATH='/var/setuid-wrappers:/usr/bin:/usr/sbin'
    export PKG_CONFIG_PATH=/usr/lib/pkgconfig

    # Force compilers to look in default search paths
    export NIX_CFLAGS_COMPILE='-idirafter /usr/include'
    export NIX_LDFLAGS_BEFORE='-L/usr/lib -L/usr/lib32'

    ${profile}
  '';

  # Compose /etc for the chroot environment
  etcPkg = stdenv.mkDerivation {
    name         = "${name}-chrootenv-etc";
    buildCommand = ''
      mkdir -p $out/etc
      cd $out/etc

      # environment variables
      ln -s ${etcProfile} profile

      # compatibility with NixOS
      ln -s /host/etc/static static

      # symlink some NSS stuff
      ln -s /host/etc/passwd passwd
      ln -s /host/etc/group group
      ln -s /host/etc/shadow shadow
      ln -s /host/etc/hosts hosts
      ln -s /host/etc/resolv.conf resolv.conf
      ln -s /host/etc/nsswitch.conf nsswitch.conf

      # symlink sudo and su stuff
      ln -s /host/etc/login.defs login.defs
      ln -s /host/etc/sudoers sudoers
      ln -s /host/etc/sudoers.d sudoers.d

      # symlink other core stuff
      ln -s /host/etc/localtime localtime
      ln -s /host/etc/machine-id machine-id
      ln -s /host/etc/os-release os-release

      # symlink PAM stuff
      ln -s /host/etc/pam.d pam.d

      # symlink fonts stuff
      ln -s /host/etc/fonts fonts

      # symlink ALSA stuff
      ln -s /host/etc/asound.conf asound.conf

      # symlink SSL certs
      mkdir -p ssl
      ln -s /host/etc/ssl/certs ssl/certs

      # symlink /etc/mtab -> /proc/mounts (compat for old userspace progs)
      ln -s /proc/mounts mtab
    '';
  };

  # Composes a /usr-like directory structure
  staticUsrProfileTarget = buildEnv {
    name = "${name}-usr-target";
    paths = [ etcPkg ] ++ basePkgs ++ targetPaths;
    extraOutputsToInstall = [ "out" "lib" "bin" ] ++ extraOutputsToInstall;
    ignoreCollisions = true;
  };

  staticUsrProfileMulti = buildEnv {
    name = "${name}-usr-multi";
    paths = baseMultiPkgs ++ multiPaths;
    extraOutputsToInstall = [ "out" "lib" ] ++ extraOutputsToInstall;
    ignoreCollisions = true;
  };

  # setup library paths only for the targeted architecture
  setupLibDirs_target = ''
    # link content of targetPaths
    cp -rsHf ${staticUsrProfileTarget}/lib lib
    ln -s lib lib${if is64Bit then "64" else "32"}
  '';

  # setup /lib, /lib32 and /lib64
  setupLibDirs_multi = ''
    mkdir -m0755 lib32
    mkdir -m0755 lib64
    ln -s lib64 lib

    # copy glibc stuff
    cp -rsHf ${staticUsrProfileTarget}/lib/32/* lib32/ && chmod u+w -R lib32/

    # copy content of multiPaths (32bit libs)
    [ -d ${staticUsrProfileMulti}/lib ] && cp -rsHf ${staticUsrProfileMulti}/lib/* lib32/ && chmod u+w -R lib32/

    # copy content of targetPaths (64bit libs)
    cp -rsHf ${staticUsrProfileTarget}/lib/* lib64/ && chmod u+w -R lib64/

    # symlink 32-bit ld-linux.so
    ln -Ls ${staticUsrProfileTarget}/lib/32/ld-linux.so.2 lib/
  '';

  setupLibDirs = if isTargetBuild then setupLibDirs_target
                                  else setupLibDirs_multi;

  # the target profile is the actual profile that will be used for the chroot
  setupTargetProfile = ''
    mkdir -m0755 usr
    cd usr
    ${setupLibDirs}
    for i in bin sbin share include; do
      if [ -d "${staticUsrProfileTarget}/$i" ]; then
        cp -rsHf "${staticUsrProfileTarget}/$i" "$i"
      fi
    done
    cd ..

    for i in var etc; do
      if [ -d "${staticUsrProfileTarget}/$i" ]; then
        cp -rsHf "${staticUsrProfileTarget}/$i" "$i"
      fi
    done
    for i in usr/{bin,sbin,lib,lib32,lib64}; do
      if [ -d "$i" ]; then
        ln -s "$i"
      fi
    done
  '';

in stdenv.mkDerivation {
  name         = "${name}-fhs";
  buildCommand = ''
    mkdir -p $out
    cd $out
    ${setupTargetProfile}
    cd $out
    ${extraBuildCommands}
    cd $out
    ${if isMultiBuild then extraBuildCommandsMulti else ""}
  '';
  preferLocalBuild = true;
}
