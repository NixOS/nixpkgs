{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "amazon-ec2-metadata-mock";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    tag = "v${version}";
    hash = "sha256-gqzROHfwhd3i1GWSp58dBKjS1EU7Xu0Fqbzv2PoLaF8=";
  };

  vendorHash = "sha256-Px4vhFW1mhXbBuPbxEpukmeLZewF7zooOXKxL8sEFLU=";

  subPackages = [ "cmd/ec2-metadata-mock" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${builtins.placeholder "out"}/bin/ec2-metadata-mock";

  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to simulate Amazon EC2 instance metadata";
    homepage = "https://github.com/aws/amazon-ec2-metadata-mock";
    license = lib.licenses.asl20;
    mainProgram = "ec2-metadata-mock";
    maintainers = with lib.maintainers; [ arianvp ];
  };
}
