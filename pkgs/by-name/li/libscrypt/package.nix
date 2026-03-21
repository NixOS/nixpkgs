{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libscrypt";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "technion";
    repo = "libscrypt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QWWqC10bENemG5FYEog87tT7IxDaBJUDqu6j/sO3sYE=";
  };

  buildFlags = lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS= LDFLAGS_EXTRA= CFLAGS_EXTRA=";

  installFlags = [ "PREFIX=$(out)" ];
  installTargets = lib.optional stdenv.hostPlatform.isDarwin "install-osx";

  doCheck = true;

  meta = {
    description = "Shared library that implements scrypt() functionality";
    homepage = "https://lolware.net/2014/04/29/libscrypt.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ davidak ];
    platforms = lib.platforms.unix;
  };
})
