{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn }:

stdenv.mkDerivation rec {
  version = "1.6.1";
  name = "msmtp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.xz";
    sha256 = "1ws6hdpm8vfq4vwxjwgd8xndx5ax1ppnmxn0fhzlwj3pvkr4fpf4";
  };

  buildInputs = [ openssl pkgconfig gnutls gsasl libidn ];

  postInstall = ''
    cp scripts/msmtpq/msmtp-queue scripts/msmtpq/msmtpq $prefix/bin/
    chmod +x $prefix/bin/msmtp-queue $prefix/bin/msmtpq
  '';

  meta = {
      description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
      homepage = "http://msmtp.sourceforge.net/";
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
}
