{ lib, stdenv, fetchurl, jre, makeWrapper, copyDesktopItems, makeDesktopItem, unzip }:

stdenv.mkDerivation rec {
  pname = "logisim";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/circuit/${lib.versions.majorMinor version}.x/${version}/logisim-generic-${version}.jar";
    sha256 = "1hkvc9zc7qmvjbl9579p84hw3n8wl3275246xlzj136i5b0phain";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems unzip ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Logisim";
      exec = "logisim";
      icon = "logisim";
      comment = meta.description;
      categories = [ "Education" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim --add-flags "-jar $src"

    # Create icons
    unzip $src "resources/logisim/img/*"
    for size in 16 20 24 48 64 128
    do
      install -D "./resources/logisim/img/logisim-icon-$size.png" "$out/share/icons/hicolor/''${size}x''${size}/apps/logisim.png"
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.cburch.com/logisim/";
    description = "Educational tool for designing and simulating digital logic circuits";
    maintainers = with maintainers; [ emilytrau ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
