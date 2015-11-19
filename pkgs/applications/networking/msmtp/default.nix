{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

stdenv.mkDerivation rec {
  version = "1.6.2";
  name = "msmtp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.xz";
    sha256 = "12c7ljahb06pgn8yvvw526xvr11vnr6d4nr0apylixddpxycsvig";
  };

  buildInputs = [ openssl pkgconfig gnutls gsasl libidn ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  configureFlags =
    stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  postInstall = ''
    cp scripts/msmtpq/msmtp-queue scripts/msmtpq/msmtpq $prefix/bin/
    chmod +x $prefix/bin/msmtp-queue $prefix/bin/msmtpq
  '';

  meta = {
      description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
      homepage = "http://msmtp.sourceforge.net/";
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.unix;
    };
}
