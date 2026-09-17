{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shuck";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ewhauser";
    repo = "shuck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TOO3GfKv9D0einHOHsy5p9034TpJpcQFaJPWYwZmIVU=";
  };

  cargoHash = "sha256-XoXnOE9jyhm6kJ0693CJ8PE4/1Sn+fyv0nLs2GG+J6M=";

  cargoBuildFlags = [
    "--package"
    "shuck-cli"
  ];

  cargoTestFlags = [
    "--package"
    "shuck-cli"
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Watch-mode test is timing sensitive and fails in the sandbox
    "--skip"
    "check_watch_reruns_when_files_change"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Shell script linter, formatter, and language server";
    downloadPage = "https://github.com/ewhauser/shuck";
    homepage = "https://ewhauser.github.io/shuck/";
    changelog = "https://github.com/ewhauser/shuck/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shuck";
    platforms = with lib.platforms; unix ++ windows;
  };
})
