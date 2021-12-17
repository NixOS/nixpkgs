{ lib, stdenv, fetchurl, pkg-config
, freetype, fribidi
, libSM, libICE, libXt, libXaw, libXmu
, libXext, libXft, libXpm, libXrandr
, libXrender, xorgproto, libXinerama }:

with lib;
stdenv.mkDerivation rec {

  pname = "oroborus";
  version = "2.0.20";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ freetype fribidi libSM libICE libXt libXaw libXmu libXext
                  libXft libXpm libXrandr libXrender xorgproto libXinerama ];

  src = fetchurl {
    url = "mirror://debian/pool/main/o/oroborus/oroborus_${version}.tar.gz";
    sha256 = "12bvk8x8rfnymbfbwmdcrd9g8m1zxbcq7rgvfdkjr0gnpi0aa82j";
  };

  meta = {
    description = "A really minimalistic X window manager";
    homepage = "https://www.oroborus.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
