{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    rev = "refs/tags/v${version}";
    hash = "sha256-kdoBHTJq/Sj27BOD4NFDVpMlywG5H7vGRS6uUbPscOY=";
  };

  vendorHash = "sha256-RM0PskgKT+n2EQkoIwIbCAwh03TLdcwj7g8AjXBeZPY=";

  ldflags = [
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/nats";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
