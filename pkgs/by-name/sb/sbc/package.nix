{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbc";
  version = "2.2";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/sbc-${finalAttrs.version}.tar.xz";
    hash = "sha256-oa2nbvNeWvnC+9BjdU3J43qNmJQXxusezrsImxODrp4=";
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
    changelog = "https://git.kernel.org/pub/scm/bluetooth/sbc.git/tree/ChangeLog?h=${finalAttrs.version}";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
