{ buildEnv, nixpkgs, nixpkgs_i686, system
, stdenv, glibc, glibc_multi, glibcLocales
, bashInteractive, coreutils, less, shadow, su
, gawk, gcc, gcc_multi, diffutils, findutils, gnused, gnugrep
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


# HOWTO:
# If pkgs is defined buildFHSChrootEnv will run in legacy mode. This means
# it will build all pkgs contained in pkgs and basePkgs and then just merge
# all of their contents together via buildEnv.
#
# The new way is to define both targetPkgs and multiPkgs. These two are
# functions which get a pkgs environment supplied and should then return a list
# of packages based this environment.
# For example: targetPkgs = pkgs: [ pkgs.nmap ];
#
# All packages (most likeley programs) placed in targetPkgs will only be
# installed once--matching the hosts architecture (64bit on x86_64 and 32bit on
# x86). These packages will populate the chroot directory tree.
#
# Packages (most likeley libraries) defined in multiPkgs will be installed once
# on x86 systems and twice on x86_64 systems.
# On x86 they will just be merge with the packages defined in targetPkgs.
# On x86_64 they will be added to targetPkgs and in addition their 32bit
# versions will also be installed. The final directory should look as follows:
# /lib will include 32bit libraries from multiPkgs
# /lib32 will link to /lib
# /lib64 will include 64bit libraries from multiPkgs and targetPkgs
# /x86 will contain a complete 32bit environment composed by multiPkgs

let
  is64Bit       = system == "x86_64-linux";
  # enable multi builds on x86_64 hosts if pakgs_target/multi are defined
  isMultiBuild  = is64Bit && targetPkgs != null;
  isTargetBuild = !isMultiBuild;

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
  # these match the hosts architecture, gcc/glibc_multi will be choosen
  # on multi builds
  choosenGcc = if isMultiBuild then gcc_multi else gcc;
  basePkgs =
    [ (if isMultiBuild then glibc_multi else glibc)
      choosenGcc
      bashInteractive coreutils less shadow su
      gawk diffutils findutils gnused gnugrep
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
    for i in ${profile}/{etc,bin,sbin,share,var}; do
        if [ -x "$i" ]
        then
            ln -s "$i"
        fi
    done
  '';

  # the target profile is the actual profile that will be used for the chroot
  setupTargetProfile = ''
    ${linkProfile staticUsrProfileTarget}
    ${setupLibDirs}

    mkdir -m0755 usr
    cd usr
    ${linkProfile staticUsrProfileTarget}
    ${setupLibDirs}
    cd ..
  '';

  # this will happen on x86_64 host:
  # /x86         -> links to the whole profile defined by multiPaths
  # /lib, /lib32 -> links to 32bit binaries
  # /lib64       -> links to 64bit binaries
  # /usr/lib*    -> same as above
  setupMultiProfile = if isTargetBuild then "" else ''
    mkdir -m0755 x86
    cd x86
    ${linkProfile staticUsrProfileMulti}
    cd ..
  '';

  setupLibDirs = if isTargetBuild then setupLibDirs_target
                                  else setupLibDirs_multi;

  # setup library paths only for the targeted architecture
  setupLibDirs_target = ''
    mkdir -m0755 lib

    # copy content of targetPaths
    cp -rsf ${staticUsrProfileTarget}/lib/* lib/
  '';

  # setup /lib, /lib32 and /lib64
  setupLibDirs_multi = ''
    mkdir -m0755 lib
    mkdir -m0755 lib64
    ln -s lib lib32

    # copy glibc stuff
    cp -rsf ${staticUsrProfileTarget}/lib/32/* lib/

    # copy content of multiPaths (32bit libs)
    cp -rsf ${staticUsrProfileMulti}/lib/* lib/

    # copy content of targetPaths (64bit libs)
    cp -rsf ${staticUsrProfileTarget}/lib/* lib64/

    # most 64bit only libs put their stuff into /lib
    # some pkgs (like gcc_multi) put 32bit libs into and /lib 64bit libs into /lib64
    # by overwriting these we will hopefully catch all these cases
    # in the end /lib should only contain 32bit and /lib64 only 64bit libs
    cp -rsf ${staticUsrProfileTarget}/lib64/* lib64/

    # copy gcc libs (and may overwrite exitsting wrongly placed libs)
    cp -rsf ${choosenGcc.gcc}/lib/*   lib/
    cp -rsf ${choosenGcc.gcc}/lib64/* lib64/
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
    ${if isMultiBuild then extraBuildCommandsMulti else ""}
    cd ..
  '';
}
