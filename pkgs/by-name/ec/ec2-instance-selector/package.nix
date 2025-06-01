{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ec2-instance-selector";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-instance-selector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4J66/LiFFeUW20du2clqjz9ozLV+Sn2VVqF9VISXpb0=";
  };

  vendorHash = "sha256-ocysHrbkmFQ96dEVJvc5YuuBiaXToAcMUUPFiLpMCpU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.versionID=${finalAttrs.version}"
    "-X=github.com/aws/amazon-ec2-instance-selector/v3/pkg/selector.versionID=${finalAttrs.version}"
  ];

  postInstall = ''
    rm $out/bin/readme-test
    mv $out/bin/cmd $out/bin/ec2-instance-selector
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recommends instance types based on resource criteria like vcpus and memory";
    homepage = "https://github.com/aws/amazon-ec2-instance-selector";
    changelog = "https://github.com/aws/amazon-ec2-instance-selector/tags/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wcarlsen ];
    mainProgram = "ec2-instance-selector";
  };
})
