{stdenv, fetchgit, bzip2, qt4, libX11}:

stdenv.mkDerivation rec {
  name = "evopedia-${version}";
  version = "0.4.4";

  src = fetchgit {
    url = https://github.com/evopedia/evopedia_qt;
    rev = "refs/tags/v${version}";
    sha256 = "1biq9zaj8nhxx1pixidsn97iwp9qy1yslgl0znpa4d4p35jcg48g";
  };

  configurePhase = ''
    qmake PREFIX=$out
  '';

  buildInputs = [ bzip2 qt4 libX11 ];

  meta = {
    description = "Offline Wikipedia Viewer";
    homepage = http://www.evopedia.info;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ qknight ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
