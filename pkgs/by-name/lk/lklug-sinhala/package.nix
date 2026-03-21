{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lklug-sinhala";
  version = "0.6";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-lklug-sinhala/fonts-lklug-sinhala_${version}.orig.tar.xz";
    hash = "sha256-oPCCa01PMQcCK5fEILgXjrGzoDg+UvxkqK6AgeQaKio=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Unicode Sinhala font by Lanka Linux User Group";
    homepage = "http://www.lug.lk/fonts/lklug";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
}
