{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprscratch";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "sashetophizika";
    repo = "hyprscratch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bWjEAPhAtsg+NC+rzcwfC15P3EJYi405KmpmRZ14Lrs=";
  };

  cargoHash = "sha256-NhXRs4lU+veoe2+hnpyXNcE0czJtIh0EBfEZRPV+fIc=";

  doCheck = false;

  meta = {
    description = "Improved scratchpad functionality for Hyprland";
    homepage = "https://github.com/sashetophizika/hyprscratch";
    mainProgram = "hyprscratch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pierreborine ];
  };
})
