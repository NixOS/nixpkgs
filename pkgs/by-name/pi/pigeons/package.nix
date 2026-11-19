{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigeons";
  version = "0.2.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "pigeons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b5K1K9+aax+pOYMBHA6R9P6wv96Ca4TKePO9cnUPBgw=";
  };

  cargoHash = "sha256-Xrt3+JPJFoNWgAPkf8qvy0CH+3hCnWyqrwd7Pk8kNCI=";

  preCheck = ''
    export HOME="$NIX_BUILD_TOP"
  '';

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
