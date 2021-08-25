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
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/omar-polo/telescope/releases/download/${version}/telescope-${version}.tar.gz";
    sha256 = "086zps4nslv5isfw1b5gvms7vp3fglm7x1a6ks0h0wxarzj350bl";
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
