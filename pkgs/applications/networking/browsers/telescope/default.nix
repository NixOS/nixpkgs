{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, bison
, libevent
, libressl
, ncurses
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "telescope";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "sha256-AdbFJfoicQUgJ9kesIWZ9ygttyjjDeC0UHRI98GwoZ8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
  ];

  buildInputs = [
    libevent
    libressl
    ncurses
  ];

  meta = with lib; {
    description = "Telescope is a w3m-like browser for Gemini";
    homepage = "https://telescope.omarpolo.com/";
    license = licenses.isc;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.unix;
  };
}
