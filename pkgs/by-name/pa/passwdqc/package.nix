{ lib
, stdenv
, fetchFromGitHub
, libxcrypt
, pam
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passwdqc";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "passwdqc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EgPeccqS+DDDMBVMc4bd70EMnXFuyglftxuqoaYHwNY=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    pam
  ];

  strictDeps = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [
    # Yet another software that does not use GNUInstallDirs Convention...
    "BINDIR=$(out)/bin"
    "CONFDIR=$(out)/etc"
    "DEVEL_LIBDIR=$(out)/lib"
    "INCLUDEDIR=$(out)/include"
    "LOCALEDIR=$(out)/share/locale"
    "MANDIR=$(man)/man"
    "PKGCONFIGDIR=$(out)/lib/pkgconfig"
    "SECUREDIR=$(out)/lib/security"
    "SHARED_LIBDIR=$(out)/lib"
    "SHARED_LIBDIR_REL=$(out)/lib"
  ];

  meta = {
    homepage = "https://www.openwall.com/passwdqc/";
    description = "Passphrase strength checking and enforcement";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "passwdqc";
    platforms = lib.platforms.unix;
  };
})
