{ stdenv, fetchurl, cmake, gettext
, libjpeg, libtiff, libungif, libpng, imlib, expat
, freetype, fontconfig, pkgconfig, gdk_pixbuf
, mkfontdir, libX11, libXft, libXext, libXinerama
, libXrandr, libICE, libSM, libXpm, libXdmcp, libxcb
, libpthreadstubs }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "icewm-${version}";
  version = "1.3.10";

  buildInputs =
  [ cmake gettext libjpeg libtiff libungif libpng imlib expat
    freetype fontconfig pkgconfig gdk_pixbuf mkfontdir libX11
    libXft libXext libXinerama libXrandr libICE libSM libXpm
    libXdmcp libxcb libpthreadstubs ];

  src = fetchurl {
    url = "https://github.com/bbidulock/icewm/archive/${version}.tar.gz";
    sha256 = "01i7a21gf810spmzjx32dxsmx4527qivs744rhvhaw4gr00amrns";
  };

  preConfigure = ''
    export cmakeFlags="-DPREFIX=$out"
  '';

  meta = {
    description = "A simple, lightweight X window manager";
    longDescription = ''
      IceWM is a window manager for the X Window System. The goal of
      IceWM is speed, simplicity, and not getting in the user's way.
    '';
    homepage = http://www.icewm.org/;
    license = licenses.lgpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
