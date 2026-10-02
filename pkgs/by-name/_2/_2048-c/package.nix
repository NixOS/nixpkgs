{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "2048-c";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "mevdschee";
    repo = "2048.c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ohpHkxPytxH+De/OT0wY7Y2saJeQaT9NIujiOajOz0Y=";
  };

  doCheck = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Console version of the game 2048 implemented in C";
    homepage = "https://github.com/mevdschee/2048.c";
    changelog = "https://github.com/mevdschee/2048.c/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "2048";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
