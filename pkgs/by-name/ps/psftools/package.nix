{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "psftools";
  version = "1.1.2";
  src = fetchurl {
    url = "https://www.seasip.info/Unix/PSF/psftools-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-d/XlKPqYy9x8KNT+8G6zv9ST/uU53Tg4pYrlA17Jh94=";
  };
  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ];

  meta = {
    homepage = "https://www.seasip.info/Unix/PSF";
    description = "Conversion tools for .PSF fonts";
    longDescription = ''
      The PSFTOOLS are designed to manipulate fixed-width bitmap fonts,
      such as DOS or Linux console fonts. Both the PSF1 (8 pixels wide)
      and PSF2 (any width) formats are supported; the default output
      format is PSF2.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
