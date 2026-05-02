{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.14";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fxwUolGn55gf4voGT3noz44aNMSkxZiHD6OLADJ8aGg=";
  };

  vendorHash = "sha256-UL9i81ez937u2sn4ZGY89eXfTplB0LVkeuLigc0BM5Y=";

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
