{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "sbc";
  version = "2.0";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "sha256-jxI2jh279V4UU2UgRzz7M4yEs5KTnMm2Qpg2D9SgeZI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  meta = with lib; {
    description = "SubBand Codec Library";
    homepage = "http://www.bluez.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
