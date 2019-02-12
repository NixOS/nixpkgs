{ stdenv, fetchurl, pkgconfig
, freetype, fribidi
, libSM, libICE, libXt, libXaw, libXmu
, libXext, libXft, libXpm, libXrandr
, libXrender, xorgproto, libXinerama }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "oroborus-${version}";
  version = "2.0.20";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ freetype fribidi libSM libICE libXt libXaw libXmu libXext
                  libXft libXpm libXrandr libXrender xorgproto libXinerama ];

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/o/oroborus/oroborus_${version}.tar.gz";
    sha256 = "12bvk8x8rfnymbfbwmdcrd9g8m1zxbcq7rgvfdkjr0gnpi0aa82j";
  };

  meta = {
    description = "A really minimalistic X window manager";
    homepage = https://www.oroborus.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
