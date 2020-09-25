{ stdenv, fetchgit, ncurses }:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.02";

  src = fetchgit {
    url = "git://bitreich.org/sacc";
    rev = "c0a79c0424a99180ed4c79e3335dc3f7ced2322c";
    sha256 = "1jcv7sv0ws9n323k8bl56q5f76yz2prsji6bxic0k8qksl65j901";
  };

  makeFlags = [ "PREFIX=$(out)" "sacc" ];
  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace config.mk --replace curses tinfo;
  '';

  meta = with stdenv.lib; {
    homepage = gopher://bitreich.org:70/1/scm/sacc/;
    description = "A terminal gopher client";
    license = licenses.isc;
    maintainers = with maintainers; [ solene ];
    platforms = platforms.all;
  };
}
