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
, openssl-chacha
, rtmpdump
}:

let
  deblibldap = callPackage ./deblibldap {};
  deblibssl = callPackage ../deblibssl {};
in stdenv.mkDerivation rec {
  version = "7.52.1";
  pname = "deblibcurl";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/c/curl/libcurl3_7.52.1-5+deb9u9_amd64.deb";
    sha256 = "0dwn9b6l6z9saig4il64apxqwgcln76p5wm0hf65i4vnm545gigq";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    deblibldap
    deblibssl
    e2fsprogs
    krb5
    libpsl
    libssh2
    nghttp2
    #openssl-chacha
    rtmpdump
  ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    cp $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/stretch/libcurl3";
    description = "Easy-to-use client-side URL transfer library (OpenSSL flavour)";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.curl;
  };
}
