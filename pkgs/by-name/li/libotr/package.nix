{ lib, stdenv, fetchurl, pkgsHostTarget, libgcrypt, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libotr";
  version = "4.1.1";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/libotr-${version}.tar.gz";
    sha256 = "1x8rliydhbibmzwdbyr7pd7n87m2jmxnqkpvaalnf4154hj1hfwb";
  };

  patches = [ ./fix-regtest-client.patch ];

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [
    autoreconfHook
    pkgsHostTarget.libgcrypt.dev # for libgcrypt-config
  ];
  propagatedBuildInputs = [ libgcrypt ];

  meta = with lib; {
    homepage = "http://www.cypherpunks.ca/otr/";
    license = licenses.lgpl21;
    description = "Library for Off-The-Record Messaging";
    platforms = platforms.unix;
  };
}
