{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn }:
stdenv.mkDerivation rec {
  name = "msmtp-1.4.30";

  src = fetchurl {
    url = "mirror://sourceforge/msmtp/${name}.tar.bz2";
    sha256 = "11lq82byx9xyfkf4nrcfjjfv5k8gk3bf8zlw0kml1qrndqlvjlpi";
  };

  buildInputs = [ openssl pkgconfig gnutls gsasl libidn ];

  meta = {
      description = "a MUA";
      homepage = "http://msmtp.sourceforge.net/";
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
}
