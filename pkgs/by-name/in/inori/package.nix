{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inori";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kd04NXv07zJgvvJi+Fx4jbXmip++A2K7KPfEt3Fdkbs=";
  };

  cargoHash = "sha256-MlANGTStN1Z82eyFzWTwc678k0irlYuPf+i5fAES6v4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [
      stephen-huan
      esrh
    ];
  };
})
