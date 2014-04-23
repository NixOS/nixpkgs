{ buildEnv, nixpkgs, nixpkgs_i686, system
, stdenv, glibc, glibc_multi, glibcLocales
, bashInteractive, coreutils, less, shadow, su
, gawk, gcc, diffutils, findutils, gnused, gnugrep
, gnutar, gzip, bzip2, xz
} :
{ name, pkgs ? [], profile ? ""
, targetPkgs ? null, multiPkgs ? null
, extraBuildCommands ? "", extraBuildCommandsMulti ? ""
}:

assert pkgs       != []   -> targetPkgs == null && multiPkgs == null;
assert targetPkgs != null -> multiPkgs  != null;
assert multiPkgs  != null -> targetPkgs != null;
assert targetPkgs != null -> pkgs       == [];

let
  is64Bit       = system == "x86_64-linux";
  # enable multi builds on x86_64 hosts if pakgs_target/multi are defined
  isMultiBuild  = is64Bit && targetPkgs != null;
  isNormalBuild = !isMultiBuild;

  # list of packages (usually programs) which will only be installed for the
  # hosts architecture
  targetPaths = if targetPkgs == null
                  then pkgs
                  else targetPkgs nixpkgs ++ multiPkgs nixpkgs;

  # list of pckages which should be build for both x86 and x86_64 on x86_64
  # systems
  multiPaths = if isMultiBuild
                  then multiPkgs nixpkgs_i686
                  else [];

  # base packages of the chroot
  # these match the hosts architecture, glibc_multi will be choosen
  # on multi builds
  basePkgs =
    [ (if isMultiBuild then glibc_multi else glibc)
      bashInteractive coreutils less shadow su
      gawk gcc diffutils findutils gnused gnugrep
      gnutar gzip bzip2 xz
    ];

  # Compose a global profile for the chroot environment
  profilePkg = nixpkgs.stdenv.mkDerivation {
    name         = "${name}-chrootenv-profile";
    buildCommand = ''
      mkdir -p $out/etc
      cat >> $out/etc/profile << "EOF"
      export PS1='${name}-chrootenv:\u@\h:\w\$ '
      ${profile}
      EOF
    '';
  };

  # Composes a /usr like directory structure
  staticUsrProfileTarget = buildEnv {
    name = "system-profile-target";
    paths = basePkgs ++ [ profilePkg ] ++ targetPaths;
  };

  staticUsrProfileMulti = buildEnv {
    name = "system-profile-multi";
    paths = multiPaths;
  };

  # References to shell scripts that set up or tear down the environment
  initSh    = ./init.sh.in;
  mountSh   = ./mount.sh.in;
  loadSh    = ./load.sh.in;
  umountSh  = ./umount.sh.in;
  destroySh = ./destroy.sh.in;

  linkProfile = profile: ''
    for i in ${profile}/{etc,bin,lib{,32,64},sbin,share,var}; do
        if [ -x "$i" ]
        then
            ln -s "$i"
        fi
    done
  '';

  # the target profile is the actual profile that will be used for the chroot
  setupTargetProfile = ''
    ${linkProfile staticUsrProfileTarget}
    mkdir -m0755 usr
    cd usr
    ${linkProfile staticUsrProfileTarget}
    cd ..
  '';

  # this will happen on x86_64 host:
  # /x86         -> links to the whole profile defined by multiPaths
  # /lib, /lib32 -> links to 32bit binaries
  # /lib64       -> links to 64bit binaries
  # /usr/lib*    -> same as above
  setupMultiProfile = if isNormalBuild then "" else ''
    mkdir -m0755 x86
    cd x86
    ${linkProfile staticUsrProfileMulti}
    cd ..

    ${setupLibDirs}

    cd usr
    ${setupLibDirs}
    cd ..
  '';

  setupLibDirs = ''
    rm -f lib lib32 lib64
    mkdir -m0755 lib
    # copy glibc stuff
    cp -rs  ${staticUsrProfileTarget}/lib/32/* lib/
    # copy contents of multiPaths
    cp -rsf ${staticUsrProfileMulti}/lib/*     lib/

    ln -s lib lib32
    ln -s ${staticUsrProfileTarget}/lib lib64
  '';

in stdenv.mkDerivation {
  name         = "${name}-chrootenv";
  buildCommand = ''
    mkdir -p "$out/sw"
    cd "$out/sw"
    ${setupTargetProfile}
    ${setupMultiProfile}
    cd ..

    mkdir -p bin
    cd bin

    sed -e "s|@chrootEnv@|$out|g" \
        -e "s|@name@|${name}|g" \
        -e "s|@shell@|${stdenv.shell}|g" \
        ${initSh} > init-${name}-chrootenv
    chmod +x init-${name}-chrootenv

    sed -e "s|@shell@|${stdenv.shell}|g" \
        -e "s|@name@|${name}|g" \
        ${mountSh} > mount-${name}-chrootenv
    chmod +x mount-${name}-chrootenv

    sed -e "s|@shell@|${stdenv.shell}|g" \
        -e "s|@name@|${name}|g" \
        ${loadSh} > load-${name}-chrootenv
    chmod +x load-${name}-chrootenv

    sed -e "s|@shell@|${stdenv.shell}|g" \
        -e "s|@name@|${name}|g" \
        ${umountSh} > umount-${name}-chrootenv
    chmod +x umount-${name}-chrootenv

    sed -e "s|@chrootEnv@|$out|g" \
        -e "s|@shell@|${stdenv.shell}|g" \
        -e "s|@name@|${name}|g" \
        ${destroySh} > destroy-${name}-chrootenv
    chmod +x destroy-${name}-chrootenv

    cd ..

    cd "$out/sw"
    ${extraBuildCommands}
    cd "$out/sw"
    ${extraBuildCommandsMulti}
    cd ..
  '';
}
