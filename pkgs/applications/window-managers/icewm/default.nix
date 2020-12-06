{ stdenv, fetchFromGitHub, cmake, gettext, perl, asciidoc
, libjpeg, libtiff, libungif, libpng, imlib, expat
, freetype, fontconfig, pkgconfig, gdk-pixbuf, gdk-pixbuf-xlib, glib
, mkfontdir, libX11, libXft, libXext, libXinerama
, libXrandr, libICE, libSM, libXpm, libXdmcp, libxcb
, libpthreadstubs, pcre, libXdamage, libXcomposite, libXfixes
, libsndfile, fribidi }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "icewm";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner  = "bbidulock";
    repo = pname;
    rev = version;
    sha256 = "16a9ikknjmhrrlc5r6z2ilkjj5vzyfk4ypwab39mg7vcmd7jzc41";
  };

  nativeBuildInputs = [ cmake pkgconfig perl asciidoc ];

  buildInputs = [
    gettext libjpeg libtiff libungif libpng imlib expat freetype fontconfig
    gdk-pixbuf gdk-pixbuf-xlib glib mkfontdir libX11 libXft libXext libXinerama
    libXrandr libICE libSM libXpm libXdmcp libxcb libpthreadstubs pcre
    libsndfile fribidi libXdamage libXcomposite libXfixes ];

  cmakeFlags = [ "-DPREFIX=$out" "-DCFGDIR=/etc/icewm" ];

  # install legacy themes
  postInstall = ''
    cp -r ../lib/themes/{gtk2,Natural,nice,nice2,warp3,warp4,yellowmotif} $out/share/icewm/themes/
  '';

  meta = {
    description = "A simple, lightweight X window manager";
    longDescription = ''
      IceWM is a window manager for the X Window System. The goal of
      IceWM is speed, simplicity, and not getting in the user's way.
    '';
    homepage = "https://www.ice-wm.org/";
    license = licenses.lgpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
