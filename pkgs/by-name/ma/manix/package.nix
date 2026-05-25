{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "manix";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "manix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b/3NvY+puffiQFCQuhRMe81x2wm3vR01MR3iwe/gJkw=";
  };

  cargoHash = "sha256-6KkZg8MXQIewhwdLE8NiqllJifa0uvebU1/MqeE/bdI=";

  meta = {
    description = "Fast CLI documentation searcher for Nix";
    homepage = "https://github.com/nix-community/manix";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      lecoqjacob
    ];
    mainProgram = "manix";
  };
})
