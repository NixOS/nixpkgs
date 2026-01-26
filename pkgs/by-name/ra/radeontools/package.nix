{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pciutils,
  pkg-config,
  libpciaccess,
}:

stdenv.mkDerivation rec {
  pname = "radeontool";
  version = "1.6.3";

  src = fetchurl {
    url = "https://people.freedesktop.org/~airlied/radeontool/${pname}-${version}.tar.gz";
    sha256 = "0mjk9wr9rsb17yy92j6yi16hfpa6v5r1dbyiy60zp4r125wr63za";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libpciaccess ];

  meta = {
    description = "Lowlevel tools to tweak register and dump state on radeon GPUs";
    homepage = "https://airlied.livejournal.com/";
    license = lib.licenses.zlib;
  };
}
