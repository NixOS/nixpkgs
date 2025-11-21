{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "eks-node-viewer";
    tag = "v${version}";
    hash = "sha256-VCRwGxH7adwB6p+UCF1GmAa5f/7GgJlJ7GvRSFOlOto=";
  };

  vendorHash = "sha256-ZBkiiDAcgOkIezDHcDjqJ3w5+k5kXdfw2TCZoTx12hc=";

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
