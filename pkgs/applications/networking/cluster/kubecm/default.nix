{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-v2frNvJUvDjPhV1RCR3DHk04kYEqP6hMXeA4j3cWlss=";
  };

  vendorHash = "sha256-uM9/rqu5WOXK6bqxhtmje+Zd9dtdv3qwt+Xr0SJHjPs=";
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
  };
}
