with import <nixpkgs> {}; stdenv.mkDerivation {
  name = "iim";

  src = fetchgit {
    url = "https://github.com/c00kiemon5ter/iim";
    rev = "220958e4e00156cbf67bf3cb4d60af25094f5428";
    sha256 = "1db51bf6kj3718k3z4mwrh8p90ns1f2yxcyrj8ykkg0x61qzh5mz";
  };

  buildPhase = "make iim CFLAGS='-D_GNU_SOURCE -std=c99 -Os -Wall -Wextra -pedantic'";

  installPhase = ''
    mkdir -p $out/bin;
    cp iim $out/bin
  '';

  meta = {
    homepage = "https://github.com/c00kiemon5ter/iim";
    license = stdenv.lib.licenses.mit;
    description = "iim is as a complete rewrite of the original ii from suckless.org";
    platforms = stdenv.lib.platforms.unix;
  };
}
