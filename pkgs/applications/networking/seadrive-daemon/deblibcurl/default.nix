{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, e2fsprogs
, krb5
, libssh2
, libpsl
, nghttp2
, openssl_1_1
, rtmpdump
}:

let
  deblibldap = callPackage ./deblibldap {};
in stdenv.mkDerivation rec {
  version = "7.64.0";
  pname = "deblibcurl";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/c/curl/libcurl4_7.64.0-4_amd64.deb";
    sha256 = "142cwmsl8iwq9hkh7w2lncywgf95i9nbja9a6kjbd6zfy4gi5gdi";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    e2fsprogs
    krb5
    libpsl
    libssh2
    nghttp2
    deblibldap
    openssl_1_1
    rtmpdump
  ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    cp $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/buster/libcurl4";
    description = "Easy-to-use client-side URL transfer library (OpenSSL flavour)";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.curl;
  };
}
