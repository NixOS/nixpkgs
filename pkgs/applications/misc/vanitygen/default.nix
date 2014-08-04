{ fetchgit, stdenv, openssl, pcre }:

stdenv.mkDerivation rec {
  version = "0.21";
  name = "vanitygen-${version}";

  src = fetchgit {
    url = "https://github.com/samr7/vanitygen";
    rev = "refs/tags/${version}";
    sha256  = "1vzfv74hhiyrrpvjca8paydx1ashgbgn5plzrx4swyzxy1xkamah";
  };

  buildInputs = [ openssl pcre ];

  installPhase = ''
    mkdir -p $out/bin
    cp vanitygen $out/bin
    cp keyconv $out/bin/vanitygen-keyconv
  '';

  meta = {
      description = "Bitcoin vanity address generator";
      longDescription= ''
        Vanitygen can search for exact prefixes or regular expression
        matches, so you can generate Bitcoin addresses that starts
        with the needed mnemonic.

        Vanitygen can generate regular bitcoin addresses, namecoin
        addresses, and testnet addresses.

        When searching for exact prefixes, vanitygen will ensure that
        the prefix is possible, will provide a difficulty estimate,
        and will run about 30% faster.
      '';
      homepage = "https://github.com/samr7/vanitygen";
      license = stdenv.lib.licenses.agpl3;
      platforms = stdenv.lib.platforms.all;
  };
}
