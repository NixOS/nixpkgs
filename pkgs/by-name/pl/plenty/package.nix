{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "plenty";
  version = "0.1.0-unstable-2025-10-30";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "pcarrier";
    repo = "plenty";
    rev = "d4d5eda28578d1c8e01bfef60235ed435989bd99";
    hash = "sha256-tyGJS0M+6zuAGrtgJ6vgbAxkzcAI7yOEcoobpxb0K5M=";
  };

  cargoHash = "sha256-2QmmF6KWyvZw3oRv8sJhb4HYfEQyPFnLBixKTQyUYJo=";

  nativeBuildInputs = [
    pkg-config
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "fish shells unified history";
    homepage = "https://github.com/pcarrier/plenty";
    license = lib.licenses.unfree;
    mainProgram = "plenty";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.linux;
  };
})
