{stdenv, fetchurl, pkgconfig, xorg, libpng, xineLib, readline, ncurses, curl
, lirc, shared-mime-info, libjpeg }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.10";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "0i3jzhiipfs5p1jbxviwh42zcfzag6iqc6yycaan0vrqm90an86a";
  };

  nativeBuildInputs = [ pkgconfig shared-mime-info ];

  buildInputs =
    [ xineLib libpng readline ncurses curl lirc libjpeg
      xorg.xlibsWrapper xorg.libXext xorg.libXv xorg.libXxf86vm xorg.libXtst xorg.xorgproto
      xorg.libXinerama xorg.libXi xorg.libXft
    ];

  patchPhase = ''sed -e '/curl\/types\.h/d' -i src/xitk/download.c'';

  configureFlags = [ "--with-readline=${readline.dev}" ];

  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";
#NIX_LDFLAGS = "-lXext -lgcc_s";

  meta = with stdenv.lib; {
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
