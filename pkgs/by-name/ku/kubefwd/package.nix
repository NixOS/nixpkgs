{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.13";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fAqsBqJgDyollaJNjdXI+hv3im7v0P/+cMkd4zj10kA=";
  };

  vendorHash = "sha256-jMGz1pgSfr4NAOYvGRBL+A1ecWCC5Okn0vPZ1qgyxB8=";

  subPackages = [ "cmd/kubefwd" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Bulk port forwarding Kubernetes services for local development";
    homepage = "https://kubefwd.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjimti ];
    mainProgram = "kubefwd";
  };
})
