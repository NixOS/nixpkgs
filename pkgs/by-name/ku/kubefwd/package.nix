{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.16";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+2RdT4SbXc7Ir9ChG+ps11WAMGno4vKOwc9VTXFijHE=";
  };

  vendorHash = "sha256-MIz2pZerUjKjcViEPZQeduzga3d6fYPlWo7dGQ+OdR4=";

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
    maintainers = with lib.maintainers; [
      cjimti
      iogamaster
    ];
    mainProgram = "kubefwd";
  };
})
