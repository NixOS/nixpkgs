{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, gmp5
, libidn2
, libunistring
, libtasn1
, nettle
, p11-kit
}:

stdenv.mkDerivation rec {
  version = "3.6.7";
  pname = "debgnutls";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/g/gnutls28/libgnutls30_3.6.7-4_amd64.deb";
    sha256 = "1kjkn2hx1iakhyrdv8780h484vvm5akvk0pb87ffaaxi9wv4qxvc";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gmp5
    libidn2
    libunistring
    libtasn1
    nettle
    p11-kit
  ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    cp $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/buster/libgnutls30";
    description = "GnuTLS is a portable library which implements the Transport Layer Security (TLS 1.0, 1.1, 1.2, 1.3) and Datagram Transport Layer Security (DTLS 1.0, 1.2) protocols. ";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.openldap;
  };
}
