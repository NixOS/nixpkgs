{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "appsignal-cli";
  version = "2.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "appsignal";
    repo = "appsignal-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBcpItLledQionvJsVieJ8L24QTOH4xsx590Dz1GPqw=";
  };

  cargoHash = "sha256-qAeTranzHa3r1SSugwjvm2tDnO8WB+VvlPa0qGcuSss=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for AppSignal monitoring data";
    homepage = "https://github.com/appsignal/appsignal-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kirillrdy ];
    mainProgram = "appsignal-cli";
  };
})
