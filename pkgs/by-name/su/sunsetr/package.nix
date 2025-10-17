{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ds5z/Um7NaewS4f5n2xVpr+EFile6Nz6P6sVW+XcnRo=";
  };

  cargoHash = "sha256-fbSN52WOIxxISaP90UQ6YGSqPqFqEcUSH88xDkvLGlM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sunsetr";
    description = "Automatic blue light filter for Hyprland, Niri, and everything Wayland";
    homepage = "https://github.com/psi4j/sunsetr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.DoctorDalek1963 ];
  };
})
