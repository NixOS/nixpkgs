{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOE6HdS0J2LTa/gup04ioIfhEQfW2FJlkW2MU81io08=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-0drdEGX9ImoA0yKCNyEYD/HewTc9Q+uClEKGFTkK4Ek=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  # remove integration tests, because they want to spin up container
  preCheck = ''
    rm -rf test/integration
  '';

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
