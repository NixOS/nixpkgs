{ stdenv, fetchurl, libtool, pkgconfig, libgphoto2, fuse, glib }:

stdenv.mkDerivation rec {
  name = "gphoto2fs-${version}";
  version = "0.5.0";
  src = fetchurl {
    url="mirror://sourceforge/gphoto/gphotofs/${version}/gphotofs-0.5.tar.bz2";
    sha256 = "1k23ncbsbh64r7kz050bg31jqamchyswgg9izhzij758d7gc8vk7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libgphoto2 fuse glib libtool
  ];

  meta = {
    description = "Fuse FS to mount a digital camera";
    maintainers = [
      stdenv.lib.maintainers.raskin
    ];
    platforms = stdenv.lib.platforms.linux;
  };
}
