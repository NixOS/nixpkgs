{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ec2-instance-selector";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-instance-selector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tSZkh2ngOgfwup2nCiNXHFX2GhIVVW9PtLuGNP5yoo=";
  };

  vendorHash = "sha256-qrxYLnj8DEGNtIq6sC7xvNBLgguG/lj9YLqgLFumQtE=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recommends instance types based on resource criteria like vcpus and memory";
    homepage = "https://github.com/aws/amazon-ec2-instance-selector";
    changelog = "https://github.com/aws/amazon-ec2-instance-selector/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wcarlsen ];
    mainProgram = "ec2-instance-selector";
  };
})
