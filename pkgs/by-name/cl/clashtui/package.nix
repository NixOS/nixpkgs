{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
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

  cargoHash = "sha256-8oDnumyn0Ry1AIWNLO2+1HSPsxkVLRLItgEVEXqSRFI=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mihomo (Clash.Meta) TUI Client";
    homepage = "https://github.com/JohanChane/clashtui";
    changelog = "https://github.com/JohanChane/clashtui/releases/tag/v${version}";
    mainProgram = "clashtui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
