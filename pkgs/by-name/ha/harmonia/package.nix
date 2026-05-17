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
  version = "3.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    tag = "harmonia-v${finalAttrs.version}";
    hash = "sha256-fm8PBugKnw72/dAXsRj84jf4EZK1BcVEdEWgtojIuA0=";
  };

  cargoHash = "sha256-qp4frhNsWDma8uYcRe3BXmfIu6btYb8IaoXhk4oI4qM=";

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
