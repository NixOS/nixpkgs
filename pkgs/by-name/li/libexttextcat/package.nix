{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libexttextcat";
  version = "3.4.6";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libexttextcat/libexttextcat-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-bXfqziDp6hBsEzDiaO3nDJpKiXRN3CVxVoJ1TsozaN8=";
  };

  meta = {
    description = "N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = "https://wiki.documentfoundation.org/Libexttextcat";
    license = lib.licenses.bsd3;
    mainProgram = "createfp";
    platforms = lib.platforms.all;
  };
})
