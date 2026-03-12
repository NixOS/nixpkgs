{
  lib,
  stdenv,
  fetchurl,
  id3lib,
  groff,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "id3v2";
  version = "0.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/id3v2/id3v2-${finalAttrs.version}.tar.gz";
    sha256 = "1gr22w8gar7zh5pyyvdy7cy26i47l57jp1l1nd60xfwx339zl1c1";
  };

  nativeBuildInputs = [ groff ];
  buildInputs = [
    id3lib
    zlib
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [
    "clean"
    "all"
  ];

  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';

  meta = {
    description = "Command line editor for id3v2 tags";
    homepage = "https://id3v2.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    mainProgram = "id3v2";
  };
})
