{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lao";
  version = "0.0.20060226";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-lao/fonts-lao_${version}.orig.tar.xz";
    hash = "sha256-DlgdyfhxxzVkNIL+NGsQ+PRlNkCuG3v2OahkIEYx60o=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp Phetsarath_OT.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = {
    description = "TrueType font for Lao language";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
}
