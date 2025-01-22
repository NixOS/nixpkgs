{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.32.2";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-cW96teV0k0MJq6WJ37Ao4tDOOsB48uU2+WTD07n5EuQ=";
  };

  vendorHash = "sha256-Fr31wLvzIoN2wIU2EmUrsqiMcPpdJpQI3ZfB//JYIXE=";
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
