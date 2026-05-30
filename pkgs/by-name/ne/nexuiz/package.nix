{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  darkplaces,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "2.5.2";

  version_short = lib.replaceStrings [ "." ] [ "" ] version;
in
stdenv.mkDerivation {
  pname = "nexuiz";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/nexuiz/nexuiz-${version_short}.zip";
    sha256 = "0010jrxc68qqinkvdh1qn2b8z3sa5v1kcd8d1m4llp3pr6y7xqm5";
  };

  nativeBuildInputs = [
    unzip
    copyDesktopItems
    makeBinaryWrapper
  ];

  postUnpack = ''
    cd Nexuiz/sources/
    unzip enginesource*.zip
    cd ../../
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -pv "$out/bin/"
    makeWrapper ${lib.getBin darkplaces}/bin/darkplaces $out/bin/nexuiz \
      --inherit-argv0 \
      --add-flags "-basedir $out/share/nexuiz"
    makeWrapper ${lib.getBin darkplaces}/bin/darkplaces-dedicated $out/bin/nexuiz-dedicated \
      --inherit-argv0 \
      --add-flags "-basedir $out/share/nexuiz"
    mkdir -pv "$out/share/nexuiz/"
    cp -rv data/ "$out/share/nexuiz/"
    mkdir -pv $out/share/icon/
    cp sources/darkplaces/nexuiz.ico $out/share/icon/nexuiz.ico
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Nexuiz";
      exec = "nexuiz";
      icon = "nexuiz";
      desktopName = "Nexuiz";
      comment = "A free first-person shooter video game developed and published by Alientrap";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  meta = {
    description = "Free fast-paced first-person shooter";
    homepage = "http://www.alientrap.org/games/nexuiz";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
