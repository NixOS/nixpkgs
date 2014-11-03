{stdenv, fetchgit, bzip2, qt4, libX11}:

stdenv.mkDerivation rec {
  name = "evopedia-0.4.2";

  src = fetchgit {
    url = git://gitorious.org/evopedia/evopedia.git;
    rev = "v0.4.2" ;
    md5 = "a2f19ed6e4d936c28cee28d44387b682";
  };

  configurePhase = ''
    qmake PREFIX=$out
  '';

  buildInputs = [ bzip2 qt4 libX11 ];

  meta = {
    description = "Offline Wikipedia Viewer";
    homepage = http://www.evopedia.info;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
