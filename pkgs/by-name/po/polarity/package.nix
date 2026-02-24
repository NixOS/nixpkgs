{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-12-09";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "fde43ec216e70022bcc6d637249c5ef093b73aaf";
    hash = "sha256-Kd1MMxdrTbV8M8h1MW4REsGf+ehLvb8bXm9OzwGqUDA=";
  };

  cargoHash = "sha256-Upnm79E7pwoZR/13TnDob0Hbd3GNixtbB8gbrkLYGFQ=";

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
