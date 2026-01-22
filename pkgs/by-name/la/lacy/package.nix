{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lacy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "timothebot";
    repo = "lacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3LFJpzuL2ULnStFwW165gH/S8Hjh49QE4R6c0NyKRSI=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-OJW29CopdO7lbkr0F2KVnfbRGEGIf8J8Vu8YChjeElY=";

  meta = {
    description = "Fast magical cd alternative for lacy terminal navigators";
    homepage = "https://github.com/timothebot/lacy";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "lacy";
    maintainers = with lib.maintainers; [ Srylax ];
  };
})
