{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "sangyo_ttf";
  version = "20250205";

  src = fetchurl {
    url = "https://dl.dafont.com/dl/?f=sangyo";
    hash = "sha256-YHObGmWSkYtIwOXb1IzPLFXBSRhq6vQ9rtOkQiAzP3A=";
    name = "sangyo.zip";
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip "$src"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Blocky Cyrillic font";
    homepage = "https://ggbot.itch.io/sangyo-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ gigahawk ];
  };
}
