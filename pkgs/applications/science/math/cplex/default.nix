{ lib, stdenv, autoPatchelfHook, makeDesktopItem, copyDesktopItems, makeWrapper, alsa-lib, openjdk, sqlite, unixODBC, gtk2, xorg, glibcLocales, releasePath ? null }:

# To use this package, you need to download your own cplex installer from IBM
# and override the releasePath attribute to point to the location of the file.
#
# Note: cplex creates an individual build for each license which screws
# somewhat with the use of functions like requireFile as the hash will be
# different for every user.

stdenv.mkDerivation rec {
  pname = "cplex";
  version = "22.11";

  src =
    if releasePath == null then
      throw ''
        This nix expression requires that the cplex installer is already
        downloaded to your machine. Get it from IBM:
        https://www.ibm.com/support/pages/downloading-ibm-ilog-cplex-optimization-studio-2211

        Set `cplex.releasePath = /path/to/download;` in your
        ~/.config/nixpkgs/config.nix for `nix-*` commands, or
        `config.cplex.releasePath = /path/to/download;` in your
        `configuration.nix` for NixOS.
      ''
    else
      releasePath;

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems makeWrapper openjdk ];
  buildInputs = [ alsa-lib gtk2 sqlite unixODBC xorg.libXtst glibcLocales ];

  unpackPhase = "cp $src $name";

  postPatch = ''
    sed -i -e 's|/usr/bin/tr"|tr"         |' $name
  '';

  buildPhase = ''
    runHook preBuild

     export JAVA_TOOL_OPTIONS=-Djdk.util.zip.disableZip64ExtraFieldValidation=true
    sh $name LAX_VM "$(command -v java)" -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=$out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/opl/bin/x86-64_linux/oplrun\
      $out/opl/bin/x86-64_linux/oplrunjava\
      $out/opl/oplide/oplide\
      $out/cplex/bin/x86-64_linux/cplex\
      $out/cpoptimizer/bin/x86-64_linux/cpoptimizer\
      $out/bin

    mkdir -p $out/share/pixmaps
    ln -s $out/opl/oplide/icon.xpm $out/share/pixmaps/oplide.xpm

    mkdir -p $out/share/doc
    mv $out/doc $out/share/doc/$name

    mkdir -p $out/share/licenses
    mv $out/license $out/share/licenses/$name

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "oplide";
      desktopName = "IBM ILOG CPLEX Optimization Studio";
      genericName = "Optimization Software";
      icon = "oplide";
      exec = "oplide";
      categories = [ "Development" "IDE" "Math" "Science" ];
    })
  ];

  fixupPhase =
  let
    libraryPath = lib.makeLibraryPath [ stdenv.cc.cc gtk2 xorg.libXtst ];
  in ''
    runHook preFixup

    rm -r $out/Uninstall

    for pgm in $out/opl/bin/x86-64_linux/oplrun $out/opl/bin/x86-64_linux/oplrunjava $out/opl/oplide/oplide;
    do
      wrapProgram $pgm \
        --prefix LD_LIBRARY_PATH : $out/opl/bin/x86-64_linux:${libraryPath} \
        --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
    done

    runHook postFixup
  '';

  passthru = {
    libArch = "x86-64_linux";
    libSuffix = "${version}0";
  };

  meta = with lib; {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.ibm.com/be-en/marketplace/ibm-ilog-cplex";
    mainProgram = "cplex";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}
