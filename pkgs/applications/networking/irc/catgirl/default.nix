{ ctags, fetchurl, lib, libressl, ncurses, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "catgirl";
  version = "1.9a";

  src = fetchurl {
    url = "https://git.causal.agency/catgirl/snapshot/${pname}-${version}.tar.gz";
    sha256 = "sha256-MEm5mrrWfNp+mBHFjGSOGvvfvBJ+Ho/K+mPUxzJDkV0=";
  };

  nativeBuildInputs = [ ctags pkg-config ];
  buildInputs = [ libressl ncurses ];
  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.gpl3Plus;
    description = "A TLS-only terminal IRC client";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
