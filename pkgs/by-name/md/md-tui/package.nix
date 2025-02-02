{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "md-tui";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-AwJvB1xLsJCr+r0RJi8jH50QlPq7mbUibvmvYZJi9XE=";
  };

  cargoHash = "sha256-QapogSDuAiQWbCFFwPiaSpvLHn0oRLwBEBuB44MN/t0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown renderer in the terminal";
    homepage = "https://github.com/henriklovhaug/md-tui";
    changelog = "https://github.com/henriklovhaug/md-tui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
    mainProgram = "mdt";
  };
}
