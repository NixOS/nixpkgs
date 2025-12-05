{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "splash-cli";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "joshi4";
    repo = "splash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eC8WPwB8+g50/2QqFm1le5ES0zd9LhEtDTNPPZ0mfvU=";
  };

  vendorHash = "sha256-hLtRNl8H0GXK7IxvyWpFxiqdG03CY4BGUHsl+r9Y6R0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/joshi4/splash/cmd.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add color to your logs";
    homepage = "https://github.com/joshi4/splash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "splash";
  };
})
