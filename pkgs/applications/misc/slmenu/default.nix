{lib, stdenv, fetchhg}:

stdenv.mkDerivation {
  pname = "slmenu";
  version = "hg-2012-02-01";

  src = fetchhg {
    url = "https://bitbucket.org/rafaelgg/slmenu/";
    rev = "7e74fa5db73e8b018da48d50dbbaf11cb5c62d13";
    sha256 = "0zb7mm8344d3xmvrl62psazcabfk75pp083jqkmywdsrikgjagv6";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  meta = with lib; {
    description = "A console dmenu-like tool";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
