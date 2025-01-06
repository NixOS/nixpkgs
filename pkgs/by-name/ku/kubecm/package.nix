{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-qB3Xzw6nWViBd2QMa3gBLrYhflalkjyLqeyl+7ICoSA=";
  };

  vendorHash = "sha256-Fr31wLvzIoN2wIU2EmUrsqiMcPpdJpQI3ZfB//JYIXE=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qjoly ];
    mainProgram = "kubecm";
  };
}
