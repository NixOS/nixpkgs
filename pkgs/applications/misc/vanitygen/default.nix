{ fetchurl, stdenv, openssl, pcre }:

stdenv.mkDerivation rec {
  version = "0.21";
  name = "vanitygen-${version}";

  src = fetchurl {
    name = "vanitygen-${version}.tar.gz";
    url = "https://github.com/samr7/vanitygen/tarball/0.21";
    sha256 = "1lj0gi08lg0pcby5pbpi08ysynzy24qa1n1065112shkpasi0kxv";
  };

  buildInputs = [ openssl pcre ];

  installPhase = ''
    ensureDir $out/bin
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
      license = "AGPLv3";
  };
}
