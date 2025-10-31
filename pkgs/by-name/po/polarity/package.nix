{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-10-30";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "309532f08f8bac21b52708ccce0cedad42f0ab39";
    hash = "sha256-s/sDx9SWrsbNuidfDNQyXeJflvwvwwMH4IEiSQ6Fh24=";
  };

  cargoHash = "sha256-DyqK5cxdsZWMr79clw8oRHTAAlzGzP8i4Vu/UXH/ptE=";

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
