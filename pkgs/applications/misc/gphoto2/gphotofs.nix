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

  meta = with stdenv.lib; {
    description = "Fuse FS to mount a digital camera";
    homepage = http://www.gphoto.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = with licenses; [ lgpl2 gpl2 ];
  };
}
