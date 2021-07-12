{ lib, stdenv, fetchFromGitHub
, guile, pkg-config, glib, loudmouth, gmp, libidn, readline, libtool
, libunwind, ncurses, curl, jansson, texinfo
, automake, autoconf }:
stdenv.mkDerivation rec {
  pname = "freetalk";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "GNUFreetalk";
    repo = "freetalk";
    rev = "v${version}";
    sha256 = "09jwk2i8qd8c7wrn9xbqcwm32720dwxis22kf3jpbg8mn6w6i757";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ pkg-config texinfo autoconf automake ];
  buildInputs = [
    guile glib loudmouth gmp libidn readline libtool
    libunwind ncurses curl jansson
  ];

  meta = with lib; {
    description =  "Console XMPP client";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    downloadPage = "https://www.gnu.org/software/freetalk/";
  };
}
