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
  version = "0.7.0-unstable-2024-08-10";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    # rev = "refs/tags/v${version}";
    rev = "1c9969c";
    hash = "sha256-+YVF59xHb82TOn7Gl0BbX2Yx6Owsp0LiOBgEXHN9QVI=";
  };

  # With the next release please go back to `cargoHash` and remove the vendored
  # `Cargo.lock` if possible.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustic_backend-0.1.1" = "sha256-6VC0DKqV9NPzwKs6SOI3dQMKrGZd2azUBMbU9dejHKs=";
    };
  };

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
