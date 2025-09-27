{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "20a0394d99752947f78e152854efd19852616968";
    hash = "sha256-Gu9PwRqMjFzubFkyRRbxcfG6mmID8HIJclkW7sDDWYo=";
  };

  cargoHash = "sha256-EB6DlhD+0oneAGhLHi3bWnnFUIfNdKeW52umWHZEP7c=";

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
