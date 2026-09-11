{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harmonia";
  version = "3.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    tag = "harmonia-v${finalAttrs.version}";
    hash = "sha256-eA0bEXk1T82oZCaX4HS9aZpwE9locw0pA3I1qf4yoEs=";
  };

  cargoHash = "sha256-gHsLr2P900Pa236N4fNlJ0w9Pu10Yb0F18zufHuU/b0=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "harmonia-v(.*)"
      ];
    };
    tests = { inherit (nixosTests) harmonia; };
  };

  meta = {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    changelog = "https://github.com/nix-community/harmonia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "harmonia-cache";
  };
})
