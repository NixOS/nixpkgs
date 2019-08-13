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
  deblibsasl = callPackage ../deblibsasl {};
in stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "deblibldap";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/o/openldap/libldap-2.4-2_2.4.44+dfsg-5+deb9u2_amd64.deb";
    sha256 = "1nk9j4a92ab9wqz76vd74m4mfkp6h2qcaly8sp9zavlwbbrwvgsp";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    deblibsasl
    gnutls
  ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    mv $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/stretch/libldap-2.4-2";
    description = "These are the run-time libraries for the OpenLDAP (Lightweight Directory Access Protocol) servers and clients.";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.openldap;
  };
}
