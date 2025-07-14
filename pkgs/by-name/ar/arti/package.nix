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
  version = "1.4.5";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    tag = "arti-v${finalAttrs.version}";
    hash = "sha256-i5/IYJwIgJUQdYMlnJAIA/I8oTZsyaBmyO7b9Gn0fdE=";
  };

  cargoHash = "sha256-J4hfDcEpiqnTnMdtQHbpOLaeeqpiIU+7vVqIo3peNbg=";

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

  checkFlags = [
    # problematic test that hangs the build
    "--skip=reload_cfg::test::watch_multiple"
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
