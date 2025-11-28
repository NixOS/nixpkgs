{
  lib,
  stdenvNoCC,
  fetchurl,
  msitools,
  icoutils,
  imagemagick,
  wine64,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ltspice";
  version = "24.1.10";
  src = fetchurl {
    url = "https://web.archive.org/web/20251117140534if_/https://ltspice.analog.com/software/LTspice64.msi";
    hash = "sha256-2t/6idUniSRHLdJQ+5OuvcRNGRIs2PR0iiezpZ0ovY8=";
  };
  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs = [
    msitools
    icoutils
    imagemagick
    copyDesktopItems
  ];

  postPatch = ''
    cp ${./ltspice.sh} ./ltspice.sh
    substituteInPlace ./ltspice.sh \
      --replace-fail wine ${lib.getExe wine64} \
      --replace-fail @outpath@ $out
  '';

  buildPhase = ''
    runHook preBuild
    msiextract $src
    mv -f "APPDIR:."/* .
    mv -f "LocalAppDataFolder/LTspice"/* .
    wrestool -x -t 14 LTspice.exe | magick ICO:- ltspice.png
    rm Remove.exe updater.exe
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm644 ltspice.png $out/share/pixmaps/ltspice.png

    install -m755 -d $out/libexec/ltspice
    install -m755 *.exe $out/libexec/ltspice
    install -m655 *.zip $out/libexec/ltspice

    install -Dm755 ltspice.sh $out/bin/ltspice
    runHook postInstall
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "ltspice";
      desktopName = "LTspice";
      comment = finalAttrs.meta.description;
      exec = "${finalAttrs.meta.mainProgram} %f";
      icon = "ltspice";
      mimeTypes = [
        "application/raw"
        "application/asc"
        "application/res"
        "application/asy"
        "application/bead"
        "application/bjt"
        "application/cap"
        "application/dio"
        "application/ind"
        "application/jft"
        "application/mos"
      ];
    })
  ];

  meta = {
    description = "SPICE simulator, schematic capture and waveform viewer";
    homepage = "https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html";
    license = lib.licenses.unfree;
    mainProgram = "ltspice";
    maintainers = [ lib.maintainers.zimward ];
    #technically windows too, but for that the builder would need some conditionals
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
