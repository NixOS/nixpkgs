{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-Fg+jlnYkdv9Vfj94lxfmhoc6pyM0EAqwIBepFXYoO5M=";
  };

  vendorHash = "sha256-wj/IHNN8r6pwkKk0ZmpRjxr5nE2c+iypjCsZb+i5vwo=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
