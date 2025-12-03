{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  sqlite,
  autoreconfHook,
}:

stdenv.mkDerivation rec {

  pname = "softhsm";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "softhsm";
    repo = "SoftHSMv2";
    rev = "${version}";
    hash = "sha256-sx0ceVY795JbtKbQGAVFllB9UJfTdgd242d6c+s1tBw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--with-crypto-backend=openssl"
    "--with-openssl=${lib.getDev openssl}"
    "--with-objectstore-backend-db"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
    # The configure script checks for the sqlite3 command, but never uses it.
    # Provide an arbitrary executable file for cross scenarios.
    "ac_cv_path_SQLITE3=/"
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  strictDeps = true;

  postInstall = "rm -rf $out/var";

  meta = with lib; {
    homepage = "https://www.softhsm.org/";
    description = "Cryptographic store accessible through a PKCS #11 interface";
    longDescription = "
      SoftHSM provides a software implementation of a generic
      cryptographic device with a PKCS#11 interface, which is of
      course especially useful in environments where a dedicated hardware
      implementation of such a device - for instance a Hardware
      Security Module (HSM) or smartcard - is not available.

      SoftHSM follows the OASIS PKCS#11 standard, meaning it should be
      able to work with many cryptographic products. SoftHSM is a
      programme of The Commons Conservancy.
    ";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
