{ lib, stdenv
, fetchgit
, autoreconfHook
, glib
, pkg-config
, libxml2
, exiv2
, imagemagick6
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glib libxml2 exiv2 imagemagick6 ];

  prePatch = ''
    sed -i 's|#include <exiv2/exif.hpp>|#include <exiv2/exiv2.hpp>|' src/jpeg-utils.cpp
  '';

  installPhase = ''
    mkdir $out/{bin,share} -p
    cp src/cgg{,-dirgen} $out/bin/
  '';

  meta = with lib; {
    homepage = "http://cgg.bzatek.net/";
    description = "A simple static web photo gallery, designed to be clean and easily usable";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = with platforms; linux ++ darwin;
  };
}


