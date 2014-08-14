{ stdenv, fetchFromGitHub, pkgconfig, gdk_pixbuf, gtk, libXmu }:

stdenv.mkDerivation rec {
  name = "trayer-1.1.6";

  buildInputs = [ pkgconfig gdk_pixbuf gtk libXmu ];

  src = fetchFromGitHub {
    owner = "sargon";
    repo = "trayer-srg";
    rev = name;
    sha256 = "0mmya7a1qh3zyqgvcx5fz2lvr9n0ilr490l1j3z4myahi4snk2mg";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://github.com/sargon/trayer-srg;
    license = licenses.mit;
    description = "A lightweight GTK2-based systray for UNIX desktop";
    platforms = platforms.linux;
    maintainer = with maintainers; [ pSub ];
  };
}

