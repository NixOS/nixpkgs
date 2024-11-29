{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuisky";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "tuisky";
    rev = "refs/tags/v${version}";
    hash = "sha256-phadkJgSvizSNPvrVaYu/+y1uAj6fmb9JQLdj0dEQIg=";
  };

  cargoHash = "sha256-jI4HKn8HalEnBCuFR8/auTqi8M1qt25MS3h/b1pf3BA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI client for bluesky";
    homepage = "https://github.com/sugyan/tuisky";
    changelog = "https://github.com/sugyan/tuisky/blob/${lib.removePrefix "refs/tags/" src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuisky";
  };
}
