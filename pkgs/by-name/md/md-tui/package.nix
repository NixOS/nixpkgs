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
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-3lNipCYhzqeAAUQZ2ajcOakNDlwSwbUUvP8Dtu6gBsI=";
  };

  cargoHash = "sha256-3hxU6yhMbcz3PhTDylJYnqI+eYoWJlf5Y2KecoY5zPo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
    maintainers = with lib.maintainers; [
      GaetanLepage
      anas
    ];
    platforms = lib.platforms.all;
    mainProgram = "mdt";
  };
}
