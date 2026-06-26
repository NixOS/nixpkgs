{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "khmeros";
  version = "5.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-khmeros/fonts-khmeros_${version}.orig.tar.xz";
    hash = "sha256-gBcM9YHSuhbxvwfQTvywH/5kN921GOyvGtkROcmcBiw=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Unicode fonts for the Khmer language";
    homepage = "http://www.khmeros.info/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
}
