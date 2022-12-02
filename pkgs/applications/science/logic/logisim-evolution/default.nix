{ lib, stdenv, fetchurl, jre, makeWrapper, copyDesktopItems, makeDesktopItem, unzip }:

stdenv.mkDerivation rec {
  pname = "logisim-evolution";
  version = "3.7.2";

  src = fetchurl {
    url = "https://github.com/logisim-evolution/logisim-evolution/releases/download/v${version}/logisim-evolution-${version}-all.jar";
    sha256 = "sha256-RI+ioOHj13UAGuPzseAAy3oQBQYkja/ucjj4QMeRZhw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems unzip ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Logisim-evolution";
      exec = "logisim-evolution";
      icon = "logisim-evolution";
      comment = meta.description;
      categories = [ "Education" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim-evolution --add-flags "-jar $src"

    # Create icons
    unzip $src "resources/logisim/img/*"
    for size in 16 32 48 128 256; do
      install -D "./resources/logisim/img/logisim-icon-$size.png" "$out/share/icons/hicolor/''${size}x''${size}/apps/logisim-evolution.png"
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/logisim-evolution/logisim-evolution";
    description = "Digital logic designer and simulator";
    maintainers = with maintainers; [ emilytrau ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
