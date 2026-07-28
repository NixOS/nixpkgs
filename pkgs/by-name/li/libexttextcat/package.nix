{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libexttextcat";
  version = "3.4.8";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libexttextcat/libexttextcat-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-k+uJ/U/I9WWAY1ThAOd4s6yaJOX8BMJOaoP7HptsnVk=";
  };

  meta = {
    description = "N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = "https://wiki.documentfoundation.org/Libexttextcat";
    license = lib.licenses.bsd3;
    mainProgram = "createfp";
    platforms = lib.platforms.all;
  };
})
