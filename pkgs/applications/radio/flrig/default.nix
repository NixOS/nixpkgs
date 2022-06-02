{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, eudev
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "1.4.5";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-Zj/LkP1nSm1zLKLxuGfaKuVuP8jaVlvK/TzX504VKHk=";
  };

  buildInputs = [
    fltk13
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
