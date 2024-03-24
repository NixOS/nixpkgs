{
  lib,
  stdenv,
  fetchurl,
  gnutar,
  steam-run,
  makeDesktopItem,
  copyDesktopItems,
}: let
  desktopItem = makeDesktopItem {
    desktopName = "AnyLogic Personal Learning Edition";
    genericName = "AnyLogic Personal Learning Edition - for beginners and students";
    categories = ["Science"];
    exec = "anylogic";
    name = "anylogic-ple";
    icon = "anylogic-ple";
  };
in
  stdenv.mkDerivation rec {
    pname = "anylogic-ple";
    version = "8.8.2";

    src = fetchurl {
      url = "https://files.anylogic.com/${pname}-${version}.linux.x86_64.tgz.bin";
      sha256 = "0n372fq6q1pr0y3qxwdf5xxx9phmlyrjjgji861qilrqdg4cmzcp";
    };

    nativeBuildInputs = [ copyDesktopItems ];
    buildInputs = [ steam-run ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      tail -n +374 $src > anylogic_extracted.tgz
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
      cat > $out/bin/anylogic <<EOF
      #! $SHELL -e
      exec ${steam-run}/bin/steam-run $out/opt/anylogic/anylogic
      EOF
      chmod +x $out/bin/anylogic

      runHook postInstall
    '';

    desktopItems = [desktopItem];

    meta = with lib; {
      homepage = "https://www.anylogic.com/";
      description = "AnyLogic is a cross-platform multimethod simulation modeling tool developed by The AnyLogic Company (former XJ Technologies). It supports agent-based, discrete event, and system dynamics simulation methodologies";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.unfreeRedistributable;
      platforms = ["x86_64-linux" "x86_64-darwin"];
      maintainers = with maintainers; [ zahrun ];
    };
  }
