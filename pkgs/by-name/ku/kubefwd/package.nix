{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.18";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WP9oBy0+i92FHPkxiR4YzpaZpFRHNYy/HYCpdAwAm8M=";
  };

  vendorHash = "sha256-aPl1MmAacMtEaEozaiCfGTKvBMYEhMwGniwNfIyNwBY=";

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
