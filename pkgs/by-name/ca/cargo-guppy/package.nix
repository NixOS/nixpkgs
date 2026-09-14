{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-guppy";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    tag = "guppy-${finalAttrs.version}";
    hash = "sha256-y/5t1Mr0CvT/wNwZ696Uahiei3rpyAF8XOMSbQbh06w=";
  };

  cargoHash = "sha256-tTX8cGY+6aL8MvZUgfKtMC8d+FKqAOpm5y6O9L3Gr5A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "-p"
    "cargo-guppy"
  ];

  cargoTestFlags = [
    "-p"
    "cargo-guppy"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=guppy-(.*)" ];
  };

  meta = {
    changelog = "https://github.com/guppy-rs/guppy/releases/tag/${finalAttrs.src.tag}";
    description = "Command-line frontend for guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    mainProgram = "cargo-guppy";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
