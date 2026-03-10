{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libraw1394";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/ieee1394/libraw1394-${finalAttrs.version}.tar.gz";
    sha256 = "0z5md84941ky5l7afayx2z6j0sk0mildxbjajq6niznd44ky7i6x";
  };

  meta = {
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = "https://ieee1394.wiki.kernel.org/index.php/Libraries#libraw1394";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
