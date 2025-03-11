{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacman-game";
  version = "0-unstable-2017-01-30";

  src = fetchFromGitHub {
    owner = "justinjo";
    repo = "pacman";
    rev = "974db44b655270e5a6532c309ffb0eb2d3962e99";
    hash = "sha256-2GwIv8XMbd8WZBaPp4tOblAzku49UilHmv6bG9A1y+4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 pacman $out/bin/pacman

    runHook postInstall
  '';

  meta = {
    description = "Command line pacman game";
    homepage = "https://github.com/justinjo/Pacman";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "pacman";
  };
})
