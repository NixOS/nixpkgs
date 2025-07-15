{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-07-06";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "f95159a91c712984a51103ea6b6f32ed7f59f4df";
    hash = "sha256-iKhxvJtVeTIFQUgtlLPBH9Swvw8om61FxwahOov9xDs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bQVZEYQ9KRiG+DAl1XAEjhuXg+Rtt65srwL9yXBYhf0=";

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
