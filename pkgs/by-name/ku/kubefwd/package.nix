{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubefwd";
  version = "1.25.15";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OlmaKXw3SRa+7wXGBD6hEjdccBbdUXp67SM9bHduNEs=";
  };

  vendorHash = "sha256-t6JaUKHpNrf9E8NTFFWwrJJI9b0HyYNQeUoV7II2ocQ=";

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
