{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ethersync";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ethersync";
    repo = "ethersync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dHV4+WxNdEvRZK8WNK0qp9f43Y9oSUtlXrq/mI0yWls=";
  };

  sourceRoot = "${finalAttrs.src.name}/daemon";

  cargoHash = "sha256-uKtJp4RD0YbOmtzbxebpYQxlBmP+5k88d+76hT4cTI8=";

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
    maintainers = with lib.maintainers; [
      prince213
      ethancedwards8
    ];
  };
})
