{ lib, stdenv, fetchurl, jre, makeWrapper, copyDesktopItems, makeDesktopItem, unzip }:

stdenv.mkDerivation rec {
  pname = "logisim-evolution";
  version = "3.5.0";

  src = fetchurl {
    url = "https://github.com/logisim-evolution/logisim-evolution/releases/download/v${version}/logisim-evolution-${version}-all.jar";
    sha256 = "1r6im4gmjbnckx8jig6bxi5lxv06lwdnpxkyfalsfmw4nybd5arw";
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
      categories = "Education;";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim-evolution --add-flags "-jar $src"

    unzip $src resources/logisim/img/logisim-icon.svg
    install -D resources/logisim/img/logisim-icon.svg $out/share/pixmaps/logisim-evolution.svg

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/logisim-evolution/logisim-evolution";
    description = "Digital logic designer and simulator";
    maintainers = with maintainers; [ angustrau ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
