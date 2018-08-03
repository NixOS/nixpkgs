{ stdenv, coreutils, requireFile, patchelf, makeWrapper, openjdk, gtk2, xorg, glibcLocales, releasePath ? null }:

# To use this package, you need to download your own cplex installer from IBM
# and override the releasePath attribute to point to the location of the file.  
#
# Note: cplex creates an individual build for each license which screws
# somewhat with the use of functions like requireFile as the hash will be
# different for every user.

stdenv.mkDerivation rec {
  name = "cplex-${version}";
  version = "128";
  
  src =
    if builtins.isNull releasePath then
      throw ''
        This nix expression requires that the cplex installer is already
        downloaded to your machine. Get it from IBM and override the
        releasePath attribute to point to the location of the file. 
      ''
    else
      releasePath;

  nativeBuildInputs = [ coreutils makeWrapper ];
  buildInputs = [ openjdk gtk2 xorg.libXtst glibcLocales ];

  phases = "patchPhase buildPhase installPhase fixupPhase";

  patchPhase = ''
    sed -e 's|/usr/bin/tr"|tr"         |' $src > $name
  '';

  buildPhase = ''
    sh $name -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    for pgm in $out/opl/bin/x86-64_linux/oplrun $out/opl/bin/x86-64_linux/oplrunjava $out/opl/oplide/oplide $out/cplex/bin/x86-64_linux/cplex $out/cpoptimizer/bin/x86-64_linux/cpoptimizer;
    do
      ln -s $pgm $out/bin;
    done
  '';

  fixupPhase = 
  let 
    libraryPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc gtk2 xorg.libXtst ];
  in ''
    interpreter=${stdenv.glibc}/lib/ld-linux-x86-64.so.2

    for pgm in $out/opl/bin/x86-64_linux/oplrun $out/opl/bin/x86-64_linux/oplrunjava $out/opl/oplide/oplide;
    do
      patchelf --set-interpreter "$interpreter" $pgm;
      wrapProgram $pgm \
        --prefix LD_LIBRARY_PATH : $out/opl/bin/x86-64_linux:${libraryPath} \
        --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
    done

    for pgm in $out/cplex/bin/x86-64_linux/cplex $out/cpoptimizer/bin/x86-64_linux/cpoptimizer $out/opl/oplide/jre/bin/*; 
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
