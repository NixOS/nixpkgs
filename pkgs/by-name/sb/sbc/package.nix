{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbc";
  version = "2.1";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/sbc-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-QmYzyr18eYI2RDUW36gzW0fgBLDvN/8Qfgx+rTKZ/MI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  meta = {
    description = "SubBand Codec Library";
    homepage = "https://www.bluez.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
