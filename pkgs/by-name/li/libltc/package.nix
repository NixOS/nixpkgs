{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libltc";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/x42/libltc/releases/download/v${version}/libltc-${version}.tar.gz";
    sha256 = "sha256-Cm1CzWwh6SWif6Vg3EWsgAV9J18jNCECglkJwC07Ekk=";
  };

  meta = with lib; {
    homepage = "http://x42.github.io/libltc/";
    description = "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
