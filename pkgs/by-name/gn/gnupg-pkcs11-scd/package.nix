{
  lib,
  stdenv,
  fetchurl,
  libgpg-error,
  libassuan,
  libgcrypt,
  pkcs11helper,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "gnupg-pkcs11-scd";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-${version}/gnupg-pkcs11-scd-${version}.tar.bz2";
    hash = "sha256-lUeH5WLys9kpQhLDLdDYGizTesolDmaFAC0ok7uVkIc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libassuan
    libgcrypt
    libgpg-error
    pkcs11helper
    openssl
  ];

  configureFlags = [
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
  ];

  meta = {
    changelog = "https://github.com/alonbl/gnupg-pkcs11-scd/blob/gnupg-pkcs11-scd-${version}/ChangeLog";
    description = "Smart-card daemon to enable the use of PKCS#11 tokens with GnuPG";
    mainProgram = "gnupg-pkcs11-scd";
    longDescription = ''
      gnupg-pkcs11 is a project to implement a BSD-licensed smart-card
      daemon to enable the use of PKCS#11 tokens with GnuPG.
    '';
    homepage = "https://gnupg-pkcs11.sourceforge.net/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      philandstuff
    ];
    platforms = lib.platforms.unix;
  };
}
