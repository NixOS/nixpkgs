{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "93721a14f3d473a2b8367e76c301780f863343d0";
    hash = "sha256-oLoYRs0tqsRcoB8IuiV+LVdTMH1qnilE75uH+Th8jJY=";
  };

  cargoHash = "sha256-cH+cgYIUPQTHgGCZmP562VzCxz+i6LkymHtnHJXnd+A=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
