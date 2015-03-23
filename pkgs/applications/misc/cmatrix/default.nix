{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "cmatrix-${version}";
  version = "1.2a";

  src = fetchurl {
    url = "http://www.asty.org/cmatrix/dist/cmatrix-${version}.tar.gz";
    md5 = "ebfb5733104a258173a9ccf2669968a1";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "A curses-based scrolling 'Matrix'-like screen";
    homepage = "http://www.asty.org/cmatrix/";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl2;
  };
}
