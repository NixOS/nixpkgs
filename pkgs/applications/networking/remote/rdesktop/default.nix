{stdenv, fetchFromGitHub, openssl, libX11, libgssglue, pkgconfig, autoreconfHook
, enableCredssp ? (!stdenv.isDarwin)
} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "02sbhnqbasa54c75c86qw9w9h9sxxbnldj7bjv2gvn18lmq5rm20";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook];
  buildInputs = [openssl libX11]
    ++ stdenv.lib.optional enableCredssp libgssglue;

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-smartcard"
  ] ++ stdenv.lib.optional (!enableCredssp) "--disable-credssp";

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.gpl2;
  };
})
