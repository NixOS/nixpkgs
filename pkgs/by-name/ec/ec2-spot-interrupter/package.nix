{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ec2-spot-interrupter";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-spot-interrupter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsd0ahIpN8l3qpXofA7Rjlg0f0J+GJtFiPAvo/wy6Mw=";
  };

  vendorHash = "sha256-qrxYLnj8DEGNtIq6sC7xvNBLgguG/lj9YLqgLFumQtE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.versionID=${finalAttrs.version}"
  ];

  postInstall = ''
    rm $out/bin/readme-test
    mv $out/bin/cmd $out/bin/ec2-spot-interrupter
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trigger Amazon EC2 Spot Interruption Notifications and Rebalance Recommendations";
    homepage = "https://github.com/aws/amazon-ec2-spot-interrupter";
    changelog = "https://github.com/aws/amazon-ec2-spot-interrupter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wcarlsen ];
    mainProgram = "ec2-spot-interrupter";
  };
})
