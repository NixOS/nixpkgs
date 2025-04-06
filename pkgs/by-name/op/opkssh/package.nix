{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RtTo/wj4v+jtJ4xZJD0YunKtxT7zZ1esgJOSEtxnLOg=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-MK7lEBKMVZv4jbYY2Vf0zYjw7YV+13tB0HkO3tCqzEI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/openpubkey/opkssh";
    description = "Integrating SSO with SSH - short-lived SSH keys with an OpenID provider";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.johnrichardrinehart ];
    mainProgram = "opkssh";
  };
})
