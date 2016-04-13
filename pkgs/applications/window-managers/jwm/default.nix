{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, which, xorg,
  libX11, libXext, libXinerama, libXpm, libXft, libXau, libXdmcp, libXmu,
  libpng, libjpeg, expat, xproto, xextproto, xineramaproto, librsvg, gettext,
  freetype, fontconfig }:

stdenv.mkDerivation rec {
  name = "jwm-${version}";
  version = "1495";
  
  src = fetchurl {
     url = "https://github.com/joewing/jwm/archive/s${version}.tar.gz";
     sha256 = "0sn9la3k36k1d9qyxab1sbv2mqicq2w7q4wgy4bj8d48zc8xjy6v";
  };

  nativeBuildInputs = [ pkgconfig automake autoconf libtool which gettext ];

  buildInputs = [ libX11 libXext libXinerama libXpm libXft xorg.libXrender
    libXau libXdmcp libXmu libpng libjpeg expat xproto xextproto xineramaproto
    librsvg freetype fontconfig ];

  enableParallelBuilding = true;

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "A window manager for X11 that requires only Xlib";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
