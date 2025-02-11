{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clzip";
  version = "1.15";

  src = fetchurl {
    url = "mirror://savannah/lzip/clzip/clzip-${finalAttrs.version}.tar.gz";
    hash = "sha256-KH6FFSaP+NFiRIeODi4tczwD2S3SsrhJFdde9N5sJh8=";
  };

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/clzip.html";
    description = "C language version of lzip";
    mainProgram = "clzip";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
})
