{ lib, stdenv }:
stdenv.mkDerivation {
  name = "iim";

  src = builtins.fetchGit {
    url = "https://github.com/c00kiemon5ter/iim";
    rev = "220958e4e00156cbf67bf3cb4d60af25094f5428";
  };

  buildPhase = "make iim CFLAGS='-D_GNU_SOURCE -std=c99 -Os -Wall -Wextra -pedantic'";

  installPhase = "install -D iim $out/bin/iim";

  meta = with lib; {
    homepage = "https://github.com/c00kiemon5ter/iim";
    license = licenses.mit;
    description = "iim is as a complete rewrite of the original ii from suckless.org";
    platforms = platforms.unix;
  };
}
