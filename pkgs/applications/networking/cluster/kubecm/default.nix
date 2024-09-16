{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-Go2lroa8lq1XjIzvdA5ZL/lOjTAyDKopBepqgWzsUII=";
  };

  vendorHash = "sha256-BrSYfxftrnNOcPgG/rsTF3OukDd+VlOvE7OJcos7vW4=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
    mainProgram = "kubecm";
  };
}
