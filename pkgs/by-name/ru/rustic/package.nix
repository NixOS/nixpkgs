{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  Security,
  SystemConfiguration,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustic";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "refs/tags/v${version}";
    hash = "sha256-4DQNg/pYoIVQpdOp2Yx1AGUdsJbfGSL09Ll5yJTeJlU=";
  };

  cargoHash = "sha256-YFVxTJNzw/A0lz7mH6B+zKjeW5FYqyKHEWckCSVs4A8=";

  # At the time of writing, upstream defaults to "self-update", "tui", and "webdav".
  # "self-update" is a self-updater, which we don't want in nixpkgs.
  # With each update we should therefore ensure that we mimic the default features
  # as closely as possible.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "tui"
    "webdav"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  postInstall = ''
    for shell in {ba,fi,z}sh; do
      $out/bin/rustic completions $shell > rustic.$shell
    done

    installShellCompletion rustic.{ba,fi,z}sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${src.rev}/CHANGELOG.md";
    description = "fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.nobbz ];
  };
}
