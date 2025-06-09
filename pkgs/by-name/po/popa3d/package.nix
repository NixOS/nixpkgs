{
  lib,
  stdenv,
  fetchurl,
  openssl,
  libxcrypt,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "popa3d";
  version = "1.0.3";

  src = fetchurl {
    url = "http://www.openwall.com/popa3d/popa3d-${finalAttrs.version}.tar.gz";
    hash = "sha256-A7hT2vnyQm/RjUENM76C7zofCcFQ0spNIhRiTU5jiLw=";
  };

  patches = [
    ./fix-mail-spool-path.patch
    ./use-openssl.patch
    ./use-glibc-crypt.patch
    ./enable-standalone-mode.patch
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
  ];

  buildInputs = [
    openssl
    libxcrypt
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    homepage = "http://www.openwall.com/popa3d/";
    description = "Tiny POP3 daemon with security as the primary goal";
    mainProgram = "popa3d";
    platforms = lib.platforms.linux;
  };
})
