{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rke";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JLP2fZALPJmfj8fCsEPT0S2xsZ1HNQlhORNNrGxxgVg=";
  };

  vendorHash = "sha256-5SxRh9y8I0v3+lU4V9xGtbwWv6JmrvLmPX8TFKjvvD4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke";
    description = "An extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    mainProgram = "rke";
    changelog = "https://github.com/rancher/rke/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
