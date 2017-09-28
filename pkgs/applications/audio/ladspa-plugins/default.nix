{ stdenv, fetchurl, autoreconfHook, automake, fftw, ladspaH, libxml2, pkgconfig
, perlPackages }:

stdenv.mkDerivation rec {
  name = "swh-plugins-${version}";
  version = "0.4.17";


  src = fetchurl {
    url = "https://github.com/swh/ladspa/archive/v${version}.tar.gz";
    sha256 = "1rqwh8xrw6hnp69dg4gy336bfbfpmbx4fjrk0nb8ypjcxkz91c6i";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fftw ladspaH libxml2 perlPackages.perl  perlPackages.XMLParser ];

  patchPhase = ''
    patchShebangs .
    patchShebangs ./metadata/
    cp ${automake}/share/automake-*/mkinstalldirs .
  '';

  meta = with stdenv.lib; {
    homepage = http://plugin.org.uk/;
    description = "LADSPA format audio plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
