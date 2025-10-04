{
  lib,
  stdenv,
  fetchurl,
  pam,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "duo-unix";
  version = "2.2.0";

  src = fetchurl {
    url = "https://dl.duosecurity.com/duo_unix-${version}.tar.gz";
    sha256 = "sha256-o5myAUg2tf+Yu7tB93EU/gZkGAHYtrEh6zyCiVJ2pmY=";
  };

  buildInputs = [
    pam
    openssl
    zlib
  ];
  configureFlags = [
    "--with-pam=$(out)/lib/security"
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc/duo"
    "--with-openssl=${openssl.dev}"
    "--enable-lib64=no"
  ];

  meta = {
    description = "Duo Security Unix login integration";
    homepage = "https://duosecurity.com";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
