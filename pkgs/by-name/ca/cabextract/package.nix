{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cabextract";
  version = "1.12";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/cabextract-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-jzmtX5wHa5xixn3qT4ZJ513MFomaLYEiyjK6aCYstxM=";
  };

  # Remove vendored getopt.h in favor of stdenv's to fix non-gnu builds.
  postPatch = ''
    rm getopt.h
  '';

  # Let's assume that fnmatch works for cross-compilation, otherwise it gives an error:
  # undefined reference to `rpl_fnmatch'.
  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_func_fnmatch_works=yes"
  ];

  meta = {
    homepage = "https://www.cabextract.org.uk/";
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "cabextract";
  };
})
