{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  sqlite,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arti";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    tag = "arti-v${finalAttrs.version}";
    hash = "sha256-4Vx5ATVdE8AoMWjDKKkwGOFVOwI0Qhyfr8MiAo+7MNw=";
  };

  cargoHash = "sha256-x1Pws9XbvwZqxJTJmPHQd6qbNLgkHxCK3YIZbRylk2M=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [ sqlite ] ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  cargoBuildFlags = [
    "--package"
    "arti"
  ];

  cargoTestFlags = [
    "--package"
    "arti"
  ];

  # `full` includes all stable and non-conflicting feature flags. the primary
  # downsides are increased binary size and memory usage for building, but
  # those are acceptable for nixpkgs
  buildFeatures = [ "full" ];

  # several tests under `full` require access to internal types, which are
  # currently marked as experimental for public usage.
  checkFeatures = [
    "full"
    "experimental-api"
  ];

  checkFlags = [
    # problematic test that hangs the build
    "--skip=reload_cfg::test::watch_single_file"

    # some of the cli tests attempt to validate that the filesystem and build
    # is securely configured, which is somewhat broken by the nix build sandbox
    "--skip=cli_tests"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^arti-v(.*)$" ]; };
  };

  meta = {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/arti-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
})
