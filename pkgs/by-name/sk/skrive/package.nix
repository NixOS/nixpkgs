{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "skrive";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "VanuPhantom";
    repo = "skrive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-thEq9mMQl9BNlc5PKbEjOoSsVO0ENSpDy0nQ7uplPus=";
  };

  vendorHash = "sha256-NLkrUaEpwvQhMcNcUbBiaPQKRocLT1RSwAIcMOrRdmg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv skrive.1.man skrive.1
    installManPage skrive.1
  '';

  meta = {
    description = "Secure and sleek dosage logging for the terminal";
    homepage = "https://github.com/VanuPhantom/skrive";
    changelog = "https://github.com/VanuPhantom/skrive/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ freyacodes ];
    mainProgram = "skrive";
    platforms = lib.platforms.all;
  };
})
