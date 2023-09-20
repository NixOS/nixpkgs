{ lib, stdenv, makeWrapper, openjdk, gtk2, xorg, glibcLocales, releasePath ? null }:

# To use this package, you need to download your own cplex installer from IBM
# and override the releasePath attribute to point to the location of the file.
#
# Note: cplex creates an individual build for each license which screws
# somewhat with the use of functions like requireFile as the hash will be
# different for every user.

stdenv.mkDerivation rec {
  pname = "cplex";
  version = "128";

  src =
    if releasePath == null then
      throw ''
        This nix expression requires that the cplex installer is already
        downloaded to your machine. Get it from IBM:
        https://developer.ibm.com/docloud/blog/2017/12/20/cplex-optimization-studio-12-8-now-available/

        Set `cplex.releasePath = /path/to/download;` in your
        ~/.config/nixpkgs/config.nix for `nix-*` commands, or
        `config.cplex.releasePath = /path/to/download;` in your
        `configuration.nix` for NixOS.
      ''
    else
      releasePath;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openjdk gtk2 xorg.libXtst glibcLocales ];

  unpackPhase = "cp $src $name";

  patchPhase = ''
    sed -i -e 's|/usr/bin/tr"|tr"         |' $name
  '';

  buildPhase = ''
    sh $name -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s $out/opl/bin/x86-64_linux/oplrun\
      $out/opl/bin/x86-64_linux/oplrunjava\
      $out/opl/oplide/oplide\
      $out/cplex/bin/x86-64_linux/cplex\
      $out/cpoptimizer/bin/x86-64_linux/cpoptimizer\
      $out/bin
  '';

  fixupPhase =
  let
    libraryPath = lib.makeLibraryPath [ stdenv.cc.cc gtk2 xorg.libXtst ];
  in ''
    interpreter=${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2

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

  passthru = {
    libArch = "x86-64_linux";
    libSuffix = "${version}0";
  };

  meta = with lib; {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.ibm.com/be-en/marketplace/ibm-ilog-cplex";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}
