{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "OCR-A";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/ocr-a-font/OCR-A/${finalAttrs.version}/OCRA.ttf";
    sha256 = "0kpmjjxwzm84z8maz6lq9sk1b0xv1zkvl28lwj7i0m2xf04qixd0";
  };

  dontUnpack = true;

  installPhase = ''
    install -D -m 0644 $src $out/share/fonts/truetype/OCRA.ttf
  '';

  meta = {
    description = "ANSI OCR font from the '60s. CYBER";
    homepage = "https://sourceforge.net/projects/ocr-a-font/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ V ];
  };
})
