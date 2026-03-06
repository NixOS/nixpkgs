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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    tag = "harmonia-v${finalAttrs.version}";
    hash = "sha256-BovRI3p2KXwQ6RF49NqLc0uKP/Jk+yA8E0eqScaIP68=";
  };

  cargoHash = "sha256-X3A+gV32itmt0SqepioT64IGzHfrCdLsQjF6EDwCTbo=";

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
