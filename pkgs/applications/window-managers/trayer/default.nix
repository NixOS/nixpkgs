{ stdenv, fetchFromGitHub, pkgconfig, gdk_pixbuf, gtk2 }:

stdenv.mkDerivation rec {
  name = "trayer-1.1.7";

  buildInputs = [ pkgconfig gdk_pixbuf gtk2 ];

  src = fetchFromGitHub {
    owner = "sargon";
    repo = "trayer-srg";
    rev = name;
    sha256 = "06lpgralggh5546qgvpilzxh4anshli2za41x68x2zbaizyqb09a";
  };

  preConfigure = ''
    patchShebangs configure
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://github.com/sargon/trayer-srg;
    license = licenses.mit;
    description = "A lightweight GTK2-based systray for UNIX desktop";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}

