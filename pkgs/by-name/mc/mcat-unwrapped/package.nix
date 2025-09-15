{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcat-unwrapped";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URAgoarWC+GGCF+nUGqhmDmh1PX2/Ry5U8e8HrHFGHk=";
  };

  cargoHash = "sha256-c3OJURz6eObjIC6AHUP6l/a5zYFV0QZ3VIxShFCcm4U=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "cat command for documents / images / videos and more";
    homepage = "https://github.com/Skardyy/mcat";
    changelog = "https://github.com/Skardyy/mcat/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mcat";
    maintainers = with lib.maintainers; [
      louis-thevenet
    ];
  };
})
