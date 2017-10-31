{ stdenv, fetchFromGitHub, bzip2, qt4, qmake4Hook, libX11 }:

stdenv.mkDerivation rec {
  name = "evopedia-${version}";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "evopedia";
    repo = "evopedia_qt";
    rev = "v${version}";
    sha256 = "0snp5qiywj306kfaywvkl7j34fivgxcb8dids1lzmbqq5xcpqqvc";
  };

  buildInputs = [ bzip2 qt4 libX11 ];
  nativeBuildInputs = [ qmake4Hook ];

  meta = with stdenv.lib; {
    description = "Offline Wikipedia Viewer";
    homepage = http://www.evopedia.info;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.qknight ];
    platforms = platforms.linux;
  };
}
