{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clapboard";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vRIwdbt8f9/K7QAfFtBXrr4ezymlnzarq08W7J3aRiU=";
  };

  cargoHash = "sha256-w3VR6j1ZcMQsk8r9eDqMtRJrGS6+XRM8t/pf5GpTVFA=";

  meta = {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      bjesus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "clapboard";
  };
})
