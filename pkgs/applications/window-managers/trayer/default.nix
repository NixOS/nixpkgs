{ stdenv, fetchFromGitHub, pkgconfig, gdk-pixbuf, gtk2 }:

stdenv.mkDerivation rec {
  name = "trayer-1.1.8";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gdk-pixbuf gtk2 ];

  src = fetchFromGitHub {
    owner = "sargon";
    repo = "trayer-srg";
    rev = name;
    sha256 = "1mvhwaqa9bng9wh3jg3b7y8gl7nprbydmhg963xg0r076jyzv0cg";
  };

  preConfigure = ''
    patchShebangs configure
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sargon/trayer-srg";
    license = licenses.mit;
    description = "A lightweight GTK2-based systray for UNIX desktop";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}

