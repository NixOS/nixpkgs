{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, gnutls
}:

let
  deblibc = callPackage ./deblibc {};
  deblibsasl = callPackage ./deblibsasl {};
in stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "deblibldap";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg-3_amd64.deb";
    sha256 = "074wba8iq08wa78ry1ys904l2rd7hv02g7qvp6b9b6s49c40jkaa";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    deblibc
    deblibsasl
    gnutls
  ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    cp $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/buster/libldap-2.4-2";
    description = "These are the run-time libraries for the OpenLDAP (Lightweight Directory Access Protocol) servers and clients.";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.openldap;
  };
}
