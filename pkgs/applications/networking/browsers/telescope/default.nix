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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "0dd09r7b2gm9nv1q67yq4zk9f4v0fwqr5lw51crki9ii82gmj2h8";
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
