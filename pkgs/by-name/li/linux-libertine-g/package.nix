{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linux-libertine-g";
  version = "20120116";

  src = fetchzip {
    url = "http://www.numbertext.org/linux/e7a384790b13c29113e22e596ade9687-LinLibertineG-${finalAttrs.version}.zip";
    hash = "sha256-UGTB7jsI6peivCtEt96RCSi5XHCrnjCSs0Ud5bF7uxk=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -r *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Graphite versions of Linux Libertine and Linux Biolinum font families for LibreOffice and OpenOffice.org";
    homepage = "https://numbertext.org/linux/";
    maintainers = with lib.maintainers; [ qweered ];
    license = lib.licenses.ofl;
  };
})
