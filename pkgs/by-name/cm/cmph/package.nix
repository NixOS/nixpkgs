{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmph";
  version = "2.0.2";

  src = fetchurl {
    url = "https://deac-ams.dl.sourceforge.net/project/cmph/v${finalAttrs.version}/cmph-${finalAttrs.version}.tar.gz";
    hash = "sha256-Nl8egFZADUYPHue/r9vzfV7mx46PRyO/SzwIHIlzPx4=";
  };

  meta = {
    description = "Free minimal perfect hash C library, providing several algorithms in the literature in a consistent, ease to use, API";
    homepage = "https://sourceforge.net/projects/cmph/";
    license = with lib.licenses; [
      gpl2
      mpl11
    ];
    mainProgram = "cmph";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
