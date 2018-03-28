{ stdenv, fetchurl, cmake, gettext
, libjpeg, libtiff, libungif, libpng, imlib, expat
, freetype, fontconfig, pkgconfig, gdk_pixbuf
, mkfontdir, libX11, libXft, libXext, libXinerama
, libXrandr, libICE, libSM, libXpm, libXdmcp, libxcb
, libpthreadstubs, pcre }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "icewm-${version}";
  version = "1.4.2";

  buildInputs =
  [ cmake gettext libjpeg libtiff libungif libpng imlib expat
    freetype fontconfig pkgconfig gdk_pixbuf mkfontdir libX11
    libXft libXext libXinerama libXrandr libICE libSM libXpm
    libXdmcp libxcb libpthreadstubs pcre ];

  src = fetchurl {
    url = "https://github.com/bbidulock/icewm/archive/${version}.tar.gz";
    sha256 = "05chzjjnb4n4j05ld2gmhhr07c887qb4j9inwg9izhvml51af1bw";
  };

  preConfigure = ''
    export cmakeFlags="-DPREFIX=$out -DCFGDIR=/etc/icewm"
  '';

  patches = [ ./fix-strlcat_strlcpy.patch ] ++
    stdenv.lib.optional stdenv.hostPlatform.isMusl ./musl.patch;

  patchFlags = [ "-p0" ];

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
