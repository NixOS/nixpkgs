{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "52211970b601db2e449ea6bc0a2e785d39c489c0";
    hash = "sha256-jDhkBrLbk9B9xeEZ4A7jp6at/Hp4q2A/egoFgY2xK8I=";
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
