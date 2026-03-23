{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cIIbeCsQq/TWf58m9l07aVg2gJNqsEyGqC3UPPb63sQ=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-aZUwuujE5x2ZCbalvH8DzKP835tgRr6MQbDtvcAZRsk=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/openpubkey/opkssh";
    description = "Enables SSH to be used with OpenID Connect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      johnrichardrinehart
      sarcasticadmin
    ];
    mainProgram = "opkssh";
  };
})
