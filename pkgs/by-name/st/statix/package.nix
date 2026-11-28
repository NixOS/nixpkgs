{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0.6.0-unstable-2026-11-20";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "c31c2cb294a60de6eeb6ef6e15c814b0960b06cd";
    hash = "sha256-Hy9iwiAPmIbuCOY6CwgOPIeFpyQGw35ky3IMF79UqEU=";
  };

  cargoHash = "sha256-VkxBhBv0GtRZ3YMctYBQ3194+HXukfdRv9bEqdvsFz8=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/molybdenumsoftware/statix";
    license = lib.licenses.mit;
    mainProgram = "statix";
    maintainers = with lib.maintainers; [
      mightyiam
      nerdypepper
      progrm_jarvis
    ];
  };
})
