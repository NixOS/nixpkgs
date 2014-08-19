{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn }:

stdenv.mkDerivation rec {
  name = "msmtp-1.4.32";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.bz2";
    sha256 = "122z38pv4q03w3mbnhrhg4w85a51258sfdg2ips0b6cgwz3wbw1b";
  };

  buildInputs = [ openssl pkgconfig gnutls gsasl libidn ];

  meta = {
      description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
      homepage = "http://msmtp.sourceforge.net/";
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
}
