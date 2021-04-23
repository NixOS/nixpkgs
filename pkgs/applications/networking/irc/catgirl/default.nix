{ ctags, fetchurl, lib, libressl, man, ncurses, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "catgirl";
  version = "1.6";

  src = fetchurl {
    url = "https://git.causal.agency/catgirl/snapshot/${pname}-${version}.tar.gz";
    sha256 = "0shg02zidqqmvywqqsaazlgg9rd5lhhrvjx6n0lzmdfaawxywciv";
  };

  nativeBuildInputs = [ ctags pkg-config ];
  buildInputs = [ libressl man ncurses ];
  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.gpl3Plus;
    description = "A TLS-only terminal IRC client";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
