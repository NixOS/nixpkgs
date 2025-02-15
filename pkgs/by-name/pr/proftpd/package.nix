{
  stdenv,
  lib,
  fetchFromGitHub,
  glibc,
  libcap,
  libsodium,
  openssl,
  zlib,
  libxcrypt-legacy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proftpd";
  version = "1.3.8c";

  src = fetchFromGitHub {
    owner = "proftpd";
    repo = "proftpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wHcJJiGY8ULVIMo6RVEE7ne6YZM7gECt2IygPhX+3cU=";
  };

  buildInputs = [
    libcap
    libsodium
    openssl
    zlib
    libxcrypt-legacy
  ];

  patches = [ ./proftpd.patch ];

  configureFlags = [
    "--enable-openssl"
    "--with-modules=mod_sftp"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.proftpd.org/";
    maintainers = lib.teams.flyingcircus.members;
    license = lib.licenses.gpl2Plus;
    mainProgram = "proftpd";
    platforms = lib.platforms.unix;
    changelog = "http://proftpd.org/docs/RELEASE_NOTES-${finalAttrs.version}";
    description = "Highly configurable GPL-licensed FTP server software";
  };
})
