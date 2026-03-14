{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.12";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZUa2eUIZHPLXnsQlHhM26sjOt52lticwlLHDDnC4gUo=";
  };

  vendorHash = "sha256-4uTOf08hlK66SRRJQQEE5jsqOWb7nhFVkoH8NDkAC7c=";

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
