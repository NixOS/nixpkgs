{ ctags, fetchurl, lib, libressl, man, ncurses, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "catgirl";
  version = "1.9";

  src = fetchurl {
    url = "https://git.causal.agency/catgirl/snapshot/${pname}-${version}.tar.gz";
    sha256 = "182l7yryqm1ffxqgz3i4lcnzwzpbpm2qvadddmj0xc8dh8513s0w";
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
