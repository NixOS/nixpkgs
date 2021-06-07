{ lib, stdenv, fetchurl, autoreconfHook, automake, fftw, ladspaH, libxml2, pkg-config
, perlPackages }:

stdenv.mkDerivation rec {
  pname = "swh-plugins";
  version = "0.4.17";


  src = fetchurl {
    url = "https://github.com/swh/ladspa/archive/v${version}.tar.gz";
    sha256 = "1rqwh8xrw6hnp69dg4gy336bfbfpmbx4fjrk0nb8ypjcxkz91c6i";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fftw ladspaH libxml2 perlPackages.perl  perlPackages.XMLParser ];

  patchPhase = ''
    patchShebangs .
    patchShebangs ./metadata/
    cp ${automake}/share/automake-*/mkinstalldirs .
  '';

  meta = with lib; {
    homepage = "http://plugin.org.uk/";
    description = "LADSPA format audio plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
