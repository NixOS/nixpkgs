{ stdenv, fetchFromGitHub, openssl, libX11, libgssglue, pkgconfig
, autoreconfHook }:

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.6";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "02sbhnqbasa54c75c86qw9w9h9sxxbnldj7bjv2gvn18lmq5rm20";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook];
  buildInputs = [openssl libX11 libgssglue];

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-smartcard"
  ];

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
})
