{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x2Ec3Pm80IvTzl3gw0mwWRbW1nLZ2V70KegahSDNwH0=";
  };

  cargoHash = "sha256-1HjmS5wvlX4gGf6AZQnN+37Y3Nf8HVSOHWG2kZCVg1Y=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
