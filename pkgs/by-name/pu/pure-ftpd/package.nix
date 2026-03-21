{
  lib,
  stdenv,
  fetchurl,
  openssl,
  pam,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pure-ftpd";
  version = "1.0.52";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ESbzqVhW0IiJ/4lwPLGqnsmSTZOdFU6WkEySDwXcPHQ=";
  };

  buildInputs = [
    openssl
    pam
    libxcrypt
  ];

  configureFlags = [ "--with-tls" ];

  meta = {
    description = "Free, secure, production-quality and standard-conformant FTP server";
    homepage = "https://www.pureftpd.org";
    license = lib.licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
