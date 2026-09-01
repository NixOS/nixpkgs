{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libraw1394,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.0";
  pname = "libiec61883";

  src = fetchurl {
    url = "mirror://debian/pool/main/libi/libiec61883/libiec61883_${finalAttrs.version}.orig.tar.gz";
    name = "libiec61883-${finalAttrs.version}.tar.gz";
    sha256 = "7c7879c6b9add3148baea697dfbfdcefffbc8ac74e8e6bcf46125ec1d21b373a";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ libraw1394 ];

  meta = {
    homepage = "https://www.linux1394.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
