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
  version = "1.0.54";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-3JFAQg7ET3gpV5WR/zeKpjlrRgS5xq6uhHNo4PNb17I=";
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
