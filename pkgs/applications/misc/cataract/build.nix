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

stdenv.mkDerivation rec {
  inherit version;
  name = "cataract-${version}";

  src = fetchgit {
    url = "git://git.bzatek.net/cataract";
    inherit sha256 rev;
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ glib libxml2 exiv2 imagemagick ];

  installPhase = ''
    mkdir $out/{bin,share} -p
    cp src/cgg{,-dirgen} $out/bin/
  '';

  meta = {
    homepage = http://cgg.bzatek.net/;
    description = "a simple static web photo gallery, designed to be clean and easily usable";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}


