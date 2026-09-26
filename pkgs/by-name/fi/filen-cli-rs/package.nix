{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "filen-cli-rs";
  version = "0.2.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-rs";
    tag = "filen-cli@v${finalAttrs.version}";
    hash = "sha256-rmcmIBa7/JqfL2/8ZS34zho/pzKjwzIlXrMIIf7QnHg=";
  };

  cargoHash = "sha256-z8rsHoSkDE26wdIvpYOLD45yegwaWXCUN5xNzDZQeaw=";

  buildAndTestSubdir = "filen-cli";

  env = {
    RUSTC_BOOTSTRAP = "1"; # Avoid error[E0554]
  };

  cargoTestFlags = [
    # Avoid tests under filen-cli/tests/ that require a real account
    "--lib"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        # Do not use the filen-rs repository to get the version number.
        # This monorepo has many other tags (filen-js@*) that hide the correct tags (filen-cli@v*).
        # Revisit once https://github.com/Mic92/nix-update/issues/231 is resolved.
        "--url"
        "https://github.com/FilenCloudDienste/filen-cli-releases"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Tools for interacting with Filen cloud drive";
    homepage = "https://github.com/FilenCloudDienste/filen-rs";
    changelog = "https://github.com/FilenCloudDienste/filen-rs/blob/filen-cli@v${finalAttrs.version}/filen-cli/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "filen-cli";
    platforms = with lib.platforms; unix ++ windows;
  };
})
