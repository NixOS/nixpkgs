{ stdenv } : { env, extraInstallCommands ? "" } :

let
  # References to shell scripts that set up or tear down the environment
  initSh    = ./init.sh.in;
  mountSh   = ./mount.sh.in;
  loadSh    = ./load.sh.in;
  umountSh  = ./umount.sh.in;
  destroySh = ./destroy.sh.in;

  name = env.pname;

in stdenv.mkDerivation {
  name = "${name}-chrootenv";
  preferLocalBuild = true;
  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin

    sed -e "s|@chrootEnv@|${env}|g" \
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

    sed -e "s|@chrootEnv@|${env}|g" \
        -e "s|@shell@|${stdenv.shell}|g" \
        -e "s|@name@|${name}|g" \
        ${destroySh} > destroy-${name}-chrootenv
    chmod +x destroy-${name}-chrootenv
    ${extraInstallCommands}
  '';
}
