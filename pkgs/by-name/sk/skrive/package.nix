{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "skrive";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "VanuPhantom";
    repo = "skrive";
    rev = "refs/tags/v${version}";
    hash = "sha256-thEq9mMQl9BNlc5PKbEjOoSsVO0ENSpDy0nQ7uplPus=";
  };

  vendorHash = "sha256-NLkrUaEpwvQhMcNcUbBiaPQKRocLT1RSwAIcMOrRdmg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv skrive.1.man skrive.1
    installManPage skrive.1
  '';

  meta = with lib; {
    description = "Secure and sleek dosage logging for the terminal";
    homepage = "https://github.com/VanuPhantom/skrive";
    changelog = "https://github.com/VanuPhantom/skrive/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freyacodes ];
    mainProgram = "skrive";
    platforms = platforms.all;
  };
}
