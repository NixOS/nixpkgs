{ stdenv, coreutils, requireFile, patchelf, makeWrapper, openjdk, gtk2, xorg, glibcLocales }:

stdenv.mkDerivation rec {
  name = "cplex-${version}";
  version = "128";
  installer = "cplex_studio${version}.linux-x86-64.bin";
  
  src = requireFile rec {
    name = "${installer}";
    message = ''
      This nix expression requires that ${name} is
      already part of the store. Download it from IBM  
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "ce8a597a11c73a0a3d49f3fa82930c47b6ac2adf7bc6779ad197ff0355023838";
  };

  nativeBuildInputs = [ coreutils makeWrapper ];
  buildInputs = [ openjdk gtk2 xorg.libXtst glibcLocales ];

  phases = "installPhase";
  
  installPhase = ''
    sed -e 's|/usr/bin/tr"|tr"         |' $src > $installer
    sh $installer -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=$out

    interpreter=${stdenv.glibc}/lib/ld-linux-x86-64.so.2
    mkdir -p $out/bin

    for pgm in $out/opl/bin/x86-64_linux/oplrun $out/opl/bin/x86-64_linux/oplrunjava $out/opl/oplide/oplide;
    do
      patchelf --set-interpreter "$interpreter" $pgm;
      wrapProgram $pgm --prefix LD_LIBRARY_PATH : $out/opl/bin/x86-64_linux:${stdenv.lib.makeLibraryPath [ stdenv.cc.cc gtk2 xorg.libXtst ]} --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
      ln -s $pgm $out/bin;
    done

    for pgm in $out/cplex/bin/x86-64_linux/cplex $out/cpoptimizer/bin/x86-64_linux/cpoptimizer; 
    do
      patchelf --set-interpreter "$interpreter" $pgm;
      ln -s $pgm $out/bin;
    done

    for pgm in $out/opl/oplide/jre/bin/*; 
    do
      if grep ELF $pgm > /dev/null;
      then
        patchelf --set-interpreter "$interpreter" $pgm;
      fi
    done
  '';
  
  meta = with stdenv.lib; {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.ibm.com/be-en/marketplace/ibm-ilog-cplex";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}
