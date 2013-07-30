{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn }:

stdenv.mkDerivation rec {
  name = "msmtp-1.4.31";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.bz2";
    sha256 = "0pr29kb7qsz4q6yfw5wvmw1wm4axi8kc97qhhmp50bx2bylzjyi4";
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
