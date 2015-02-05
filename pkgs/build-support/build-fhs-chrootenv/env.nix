{ nixpkgs, nixpkgs_i686, system
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
# If pkgs is defined buildFHSEnv will run in legacy mode. This means
# it will build all pkgs contained in pkgs and basePkgs and then just merge
# all of their contents together via buildEnv.
#
# The new way is to define both targetPkgs and multiPkgs. These two are
# functions which get a pkgs environment supplied and should then return a list
# of packages based this environment.
# For example: targetPkgs = pkgs: [ pkgs.nmap ];
#
# All packages (most likely programs) placed in targetPkgs will only be
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
  chosenGcc = if isMultiBuild then nixpkgs.gcc_multi else nixpkgs.gcc;
  basePkgs = with nixpkgs;
    [ (if isMultiBuild then glibc_multi else glibc)
      chosenGcc
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
  staticUsrProfileTarget = nixpkgs.buildEnv {
    name = "system-profile-target";
    paths = basePkgs ++ [ profilePkg ] ++ targetPaths;
  };

  staticUsrProfileMulti = nixpkgs.buildEnv {
    name = "system-profile-multi";
    paths = multiPaths;
  };

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
    cp -rsf ${chosenGcc.cc}/lib/*   lib/
    cp -rsf ${chosenGcc.cc}/lib64/* lib64/
  '';

in nixpkgs.stdenv.mkDerivation {
  name         = "${name}-fhs";
  buildCommand = ''
    mkdir -p $out
    cd $out
    ${setupTargetProfile}
    ${setupMultiProfile}
    cd $out
    ${extraBuildCommands}
    cd $out
    ${if isMultiBuild then extraBuildCommandsMulti else ""}
  '';
  preferLocalBuild = true;
  passthru = {
    pname = name;
  };
}
