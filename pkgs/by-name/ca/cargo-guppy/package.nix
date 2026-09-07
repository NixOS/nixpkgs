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
  version = "0.17.26";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    tag = "guppy-${finalAttrs.version}";
    hash = "sha256-y1P8w1nM//72afZeehsj8aQhjylL84FabAxw3iqvx0g=";
  };

  cargoHash = "sha256-Pb0hXjuPoCoGDgoOyiyXG3DZNKRJ1ZIP8w38/KFRYHM=";

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
