{
  lib,
  stdenv,
  fetchurl,
  libtool,
  pkg-config,
  libgphoto2,
  fuse,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "gphoto2fs";
  version = "0.5.0";
  src = fetchurl {
    url = "mirror://sourceforge/gphoto/gphotofs/${version}/gphotofs-0.5.tar.bz2";
    sha256 = "1k23ncbsbh64r7kz050bg31jqamchyswgg9izhzij758d7gc8vk7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgphoto2
    fuse
    glib
    libtool
  ];

  meta = {
    description = "Fuse FS to mount a digital camera";
    mainProgram = "gphotofs";
    homepage = "http://www.gphoto.org/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      lgpl2
      gpl2
    ];
  };
}
