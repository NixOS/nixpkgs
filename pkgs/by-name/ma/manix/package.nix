{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "manix";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "manix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hniN0mc7Ud+5zDlOuf2F+/DKrtQ6grZF74ej0L6gMso=";
  };

  cargoHash = "sha256-FTrKdOuXTOqr7on4RzYl/UxgUJqh+Rk3KJXqsW0fuo0=";

  meta = {
    description = "Fast CLI documentation searcher for Nix";
    homepage = "https://github.com/nix-community/manix";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      lecoqjacob
      iogamaster
    ];
    mainProgram = "manix";
  };
})
