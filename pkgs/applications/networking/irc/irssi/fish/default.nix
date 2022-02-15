{ lib, stdenv, fetchFromGitHub, irssi, gmp, automake, autoconf, libtool, openssl, glib, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fish-irssi";
  version = "unstable-2013-04-13";

  src = fetchFromGitHub {
    owner = "falsovsky";
    repo = "FiSH-irssi";
    rev = "e98156bebd8c150bf100b3a0356e7103bb5c20e6";
    sha256 = "0mqq7q3rnkzx4j352g1l8sv3g687d76ikjl9c7g6xw96y91kqvdp";
  };

  preConfigure = ''
    cp -a "${irssi.src}" "./${irssi.name}"
    configureFlags="$configureFlags --with-irssi-source=`pwd`/${irssi.name}"

    ./regen.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/irssi/modules
    cp src/.libs/libfish.so $out/lib/irssi/modules
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gmp automake autoconf libtool openssl glib ];

  meta = {
    homepage = "https://github.com/falsovsky/FiSH-irssi";
    license = lib.licenses.unfree; # I can't find any mention of license
    maintainers = with lib.maintainers; [viric];
  };
}
