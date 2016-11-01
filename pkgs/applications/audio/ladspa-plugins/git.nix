{ stdenv, fetchgit, autoreconfHook, automake, fftw, ladspaH, libxml2, pkgconfig
, perl, perlPackages }:

stdenv.mkDerivation {
  name = "swh-plugins-git-2016-08-17";

  src = fetchgit {
    url = https://github.com/swh/ladspa.git;
    rev = "8b50f3434b8b30dff16020d17608ced9ee04477b";
    sha256 = "1c98z2xxz9pgcb4dg99gz8qrylh5cnag0j18a52d88ifsy24isvq";
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
