{ stdenv, fetchgit, autoreconfHook, automake, fftw, ladspaH, libxml2, pkgconfig
, perl, perlPackages }:

stdenv.mkDerivation {
  name = "swh-plugins-git-2015-03-04";

  src = fetchgit {
    url = https://github.com/swh/ladspa.git;
    rev = "4b8437e8037cace3d5bf8ce6d1d1da0182aba686";
    sha256 = "7d9aa13a064903b330bd52e35c1f810f1c8a253ea5eb4e5a3a69a051af03150e";
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
