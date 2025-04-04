{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-KdddfixQewj30rIC1qZzyS3h/jq+RdxId9WgQPqW8nE=";
  };

  vendorHash = "sha256-yTF1PRRUlJ27ZrKO0FW4IztIE1Wo05qixTCFvETg358=";

  excludedPackages = [ "hack" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.builtBy=nixpkgs"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    mainProgram = "eks-node-viewer";
  };
}
