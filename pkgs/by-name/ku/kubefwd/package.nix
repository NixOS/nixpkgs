{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.17";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-grdSN28Xm96K/ZoPS+oyeGpte2sV7XHEYUhHlU+gEW4=";
  };

  vendorHash = "sha256-nHmvzXNKLzqSFB27WFsG/Tlz+LhjXfKdxAdw55A6vUc=";

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
