{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ethersync";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ethersync";
    repo = "ethersync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GPZD/TshZMr+WeCd4WRN/Ewu7zINSzPNPci52bjsV3E=";
  };

  sourceRoot = "${finalAttrs.src.name}/daemon";

  cargoHash = "sha256-F2wVRha63TOdMCWW3KNaQ8kbYjuYbdY5yKmTHOJqODA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time co-editing of local text files";
    homepage = "https://ethersync.github.io/ethersync/";
    downloadPage = "https://github.com/ethersync/ethersync";
    changelog = "https://github.com/ethersync/ethersync/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      prince213
      ethancedwards8
    ];
  };
})
