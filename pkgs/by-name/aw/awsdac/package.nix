{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "awsdac";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "diagram-as-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhIGrkP/wpO+gf1SMSaO1CQVLRxFY48XQnnN6HELUtg=";
  };

  vendorHash = "sha256-1yQnjQfOY69lTpPjI9sA9SwdeMx+iAK6QUEVqQOnprY=";

  subPackages = [ "cmd/awsdac" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for drawing AWS infrastructure diagrams through YAML code";
    homepage = "https://github.com/awslabs/diagram-as-code";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zelkourban ];
    mainProgram = "awsdac";
  };
})
