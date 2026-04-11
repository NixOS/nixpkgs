{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.9";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eJcmQRVrBYcT/o++d4hKUd8UWJDS/Z395M/sz8kpLfw=";
  };

  vendorHash = "sha256-l0iHkuSX1ECtOYY2HIFTPFVSYiZL9fi5BDOjhxWpDyA=";

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
