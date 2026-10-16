{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigeons";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "pigeons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dig5bYAxPPOM8YFR0IE9LCQqP/tF7J5FkPlWE9Zx4DA=";
  };

  cargoHash = "sha256-0fYPpP/pFtlG3Ws+nI1PWOcv1jbVQ1bERL439dCFDgA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Connect to any machine behind a NAT or firewall with plain SSH";
    homepage = "https://pigeons.computer";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [ hougo ];
    mainProgram = "pigeons";
  };
})
