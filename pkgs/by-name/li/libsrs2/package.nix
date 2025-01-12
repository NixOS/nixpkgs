{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libsrs2";
  version = "1.0.18";

  src = fetchurl {
    url = "https://www.libsrs2.org/srs/libsrs2-${version}.tar.gz";
    sha256 = "9d1191b705d7587a5886736899001d04168392bbb6ed6345a057ade50943a492";
  };

  meta = {
    description = "Next generation SRS library from the original designer of SRS";
    mainProgram = "srs";
    license = with lib.licenses; [
      gpl2
      bsd3
    ];
    homepage = "https://www.libsrs2.org/";
    platforms = lib.platforms.linux;
  };
}
