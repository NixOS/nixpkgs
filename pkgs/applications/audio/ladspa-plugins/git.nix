{ stdenv, fetchgit, autoreconfHook, automake, fftw, ladspaH, libxml2, pkgconfig
, perl, perlPackages }:

stdenv.mkDerivation {
  name = "swh-plugins-git-2015-03-04";

  src = fetchgit {
    url = https://github.com/swh/ladspa.git;
    rev = "4b8437e8037cace3d5bf8ce6d1d1da0182aba686";
    sha256 = "1rmqm4780dhp0pj2scl3k7m8hpp1x6w6ln4wwg954zb9570rqaxx";
  };

  buildInputs = [ autoreconfHook fftw ladspaH libxml2 pkgconfig perl perlPackages.XMLParser ];

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
