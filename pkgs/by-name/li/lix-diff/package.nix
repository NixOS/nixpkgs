{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mURA7fZ9RAhVtOx+gnEeJI48tyvi+zbKE+xUs5UMPY4=";
  };

  cargoHash = "sha256-yOVJjn/DaHDsBeSMKJ0bmav+I5JLa9HqII5RKFpc5Hw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
