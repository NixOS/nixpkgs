{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "c04a05ebaf7488a44d227c66a53b17c7f670f9ad";
    hash = "sha256-DKHaHVuxq/ZjOa0jz/2mMiqptELx+h671M20eByrBHY=";
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
