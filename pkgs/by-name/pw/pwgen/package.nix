{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pwgen";
  version = "2.08";

  src = fetchFromGitHub {
    owner = "tytso";
    repo = "pwgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X2hNuQFiYhUv9ChfasTqxZzpE+kJpVmRlUR45lI1zMg=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [ "CFLAGS=-std=gnu17" ];

  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    homepage = "https://github.com/tytso/pwgen";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwgen";
    platforms = lib.platforms.all;
  };
})
