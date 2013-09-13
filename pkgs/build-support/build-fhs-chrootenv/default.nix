{stdenv, glibc, glibcLocales, gcc, coreutils, diffutils, findutils, gnused, gnugrep, gnutar, gzip, bzip2, 
bashInteractive, xz, shadow, gawk, less, buildEnv}:
{name, pkgs ? [], profile ? ""}:

let
  basePkgs = [ glibc glibcLocales gcc coreutils diffutils findutils gnused gnugrep gnutar gzip bzip2 
bashInteractive xz shadow gawk less ];

  # Compose a global profile for the chroot environment
  profilePkg = stdenv.mkDerivation {
    name = "${name}-chrootenv-profile";
    buildCommand = ''
      mkdir -p $out/etc
      cat >> $out/etc/profile << "EOF"
      export PS1='${name}-chrootenv:\u@\h:\w\$ '
      ${profile}
      EOF
    '';
  };

  paths = basePkgs ++ [ profilePkg ] ++ pkgs;

  # Composes a /usr like directory structure
  staticUsrProfile = buildEnv {
    name = "system-profile";
    inherit paths;
  };
  
  # References to shell scripts that set up or tear down the environment
  initSh = ./init.sh.in;
  mountSh = ./mount.sh.in;
  loadSh = ./load.sh.in;
  umountSh = ./umount.sh.in;
  destroySh = ./destroy.sh.in;                                                                                       
in                                                                                                                   
stdenv.mkDerivation {                                                                                                
  name = "${name}-chrootenv";                                                                                        
  buildCommand = ''                                                                                                  
    mkdir -p $out/sw                                                                                                 
    cd $out/sw                                                                                                       
                                                                                                                     
    for i in ${staticUsrProfile}/{etc,bin,lib{,32,64},sbin,var}                                                      
    do                                                                                                               
        if [ -x "$i" ]
        then
            ln -s "$i"
        fi
    done
    
    ln -s ${staticUsrProfile} usr
    
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
  '';
}
