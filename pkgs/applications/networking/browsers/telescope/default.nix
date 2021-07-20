{ stdenv
, lib
, fetchurl
, pkg-config
, bison
, libevent
, libressl
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "telescope";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/omar-polo/telescope/releases/download/${version}/telescope-${version}.tar.gz";
    sha256 = "11xrsh064ph1idhygh52y4mqapgwn1cqr0l3naj5n2a2p7lcsvvw";
  };

  nativeBuildInputs = [
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
