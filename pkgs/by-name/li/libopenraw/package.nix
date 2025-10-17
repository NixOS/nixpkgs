{
  stdenv,
  fetchurl,
  boost,
  gdk-pixbuf,
  glib,
  libjpeg,
  libxml2,
  lib,
  pkg-config,
  cargo,
  rustc,
}:

stdenv.mkDerivation rec {
  pname = "libopenraw";
  version = "0.3.7";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/libopenraw-${version}.tar.bz2";
    hash = "sha256-VRWyYQNh7zRYC2uXZjURn23ttPCnnVRmL6X+YYakXtU=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
  ];

  buildInputs = [
    boost
    gdk-pixbuf
    glib
    libjpeg
    libxml2
  ];

  postPatch = ''
    sed -i configure{,.ac} \
      -e "s,GDK_PIXBUF_DIR=.*,GDK_PIXBUF_DIR=$out/lib/gdk-pixbuf-2.0/2.10.0/loaders,"
  '';

  configureFlags = [
    "--with-boost=${lib.getDev boost}"
  ];

  meta = with lib; {
    description = "RAW camerafile decoding library";
    homepage = "https://libopenraw.freedesktop.org";
    license = licenses.lgpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.struan ];
  };
}
