{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "clashtui";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "JohanChane";
    repo = "clashtui";
    tag = "v${version}";
    hash = "sha256-2iQVYZrqo55EO0ZGn6ktP/3Py5v+LiVgrSYTtaxYXyQ=";
  };

  sourceRoot = "${src.name}/clashtui";

  cargoHash = "sha256-7quO1SlgfDZYDJtOspNWPVlhIaqP/loj19IiQWedIY0=";

  cargoBuildFlags = [ "--all-features" ];

  checkFlags = [
    # need fhs
    "--skip=utils::config::test::test_save_and_load"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Mihomo (Clash.Meta) TUI Client";
    homepage = "https://github.com/JohanChane/clashtui";
    license = lib.licenses.mit;
    mainProgram = "clashtui";
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
