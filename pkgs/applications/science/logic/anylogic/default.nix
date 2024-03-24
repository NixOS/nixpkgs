{ lib
, stdenv
, fetchurl
, gnutar
, steam-run
, makeDesktopItem
, copyDesktopItems
, makeWrapper
,
}:
stdenv.mkDerivation rec {
  pname = "anylogic-ple";
  version = "8.8.6";

  src = fetchurl {
    url = "https://files.anylogic.com/${pname}-${version}.linux.x86_64.tgz.bin";
    hash = "sha256-4bmhD52/69lsfN5htpykKEYv+pxC49/fHVzJfsetIzw=";
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];
  buildInputs = [ steam-run ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    tail -n +386 $src > anylogic_extracted.tgz
    tar zxf anylogic_extracted.tgz
    rm anylogic_extracted.tgz
    cd ./anylogic
    pwd
    chmod -R a+wr plugins/com.anylogic.examples_*
    cd ..
    mkdir -p $out/opt
    mv anylogic $out/opt
    mkdir -p $out/share/icons
    ln -s $out/opt/anylogic/icon.xpm $out/share/icons/anylogic-ple.xpm

    mkdir -p $out/bin
    makeWrapper "${steam-run}/bin/steam-run" "$out/bin/anylogic" --add-flags "$out/opt/anylogic/anylogic"
    chmod +x $out/bin/anylogic

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem
      {
        desktopName = "AnyLogic Personal Learning Edition";
        genericName = "AnyLogic Personal Learning Edition - for beginners and students";
        categories = [ "Science" ];
        exec = "anylogic";
        name = "anylogic-ple";
        icon = "anylogic-ple";
      })
  ];

  meta = with lib;
    {
      homepage = "https://www.anylogic.com/";
      description = "AnyLogic Personal Learning Edition - for beginners and students";
      longDescription = "AnyLogic is a cross-platform multimethod simulation modeling tool developed by The AnyLogic Company (former XJ Technologies). It supports agent-based, discrete event, and system dynamics simulation methodologies";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
      maintainers = with maintainers; [ zahrun ];
    };
}
