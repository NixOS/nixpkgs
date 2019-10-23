{ stdenv
, fetchgit
, autoreconfHook
, glib
, pkgconfig
, libxml2
, exiv2
, imagemagick
, version
, sha256
, rev }:

stdenv.mkDerivation {
  inherit version;
  pname = "cataract";

  src = fetchgit {
    url = "git://git.bzatek.net/cataract";
    inherit sha256 rev;
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ glib libxml2 exiv2 imagemagick ];

  prePatch = ''
    sed -i 's|#include <exiv2/exif.hpp>|#include <exiv2/exiv2.hpp>|' src/jpeg-utils.cpp
  '';

  installPhase = ''
    mkdir $out/{bin,share} -p
    cp src/cgg{,-dirgen} $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = "http://cgg.bzatek.net/";
    description = "A simple static web photo gallery, designed to be clean and easily usable";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = with platforms; linux ++ darwin;
  };
}


