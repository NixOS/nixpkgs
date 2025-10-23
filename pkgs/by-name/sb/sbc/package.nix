{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "sbc";
  version = "2.1";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "sha256-QmYzyr18eYI2RDUW36gzW0fgBLDvN/8Qfgx+rTKZ/MI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  meta = with lib; {
    description = "SubBand Codec Library";
    homepage = "https://www.bluez.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
