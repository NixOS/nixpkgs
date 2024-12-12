{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-wwAJha576P5Gt70Ys83IS4Pe1qAKvq46ucnjAcRKEKA=";
  };

  vendorHash = "sha256-7NW6j5GzOCP0Eb6IVeC9NRtMJl4ujXPWoWu/NvkMxYA=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
    mainProgram = "kubecm";
  };
}
