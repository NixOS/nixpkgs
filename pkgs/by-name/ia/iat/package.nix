{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iat";
  version = "0.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/iat.berlios/iat-${finalAttrs.version}.tar.gz";
    hash = "sha256-sl1X/eKKArLYfNSf0UeLA5rb2DY1GHmmVP6hTCd2SyE=";
  };

  meta = {
    description = "Tool for detecting the structure of many types of CD/DVD images";
    homepage = "https://www.berlios.de/software/iso9660-analyzer-tool/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
    mainProgram = "iat";
  };
})
