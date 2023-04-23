{ lib, buildGoModule, fetchFromGitHub }:

builtins.mapAttrs (pname: { doCheck ? true, mainProgram ? pname, subPackages }: buildGoModule rec {
  inherit pname;
  version = "3.25.1";

  src = fetchFromGitHub {
    owner = "projectcalico";
    repo = "calico";
    rev = "v${version}";
    hash = "sha256-msXTukje7tS8rovhbZs8CBsfIiDOCx6wkWHoDdhxK+8=";
  };

  vendorHash = "sha256-aJdzizXtW1wI9ZdQVTW8RyGFTXDdtLxpZ4oxXP/0gP0=";

  inherit doCheck subPackages;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://projectcalico.docs.tigera.io";
    changelog = "https://github.com/projectcalico/calico/releases/tag/v${version}";
    description = "Cloud native networking and network security";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
    inherit mainProgram;
  };
}) {
  calico-apiserver = {
    mainProgram = "apiserver";
    subPackages = [
      "apiserver/cmd/..."
    ];
  };
  calico-app-policy = {
    # integration tests require network
    doCheck = false;
    mainProgram = "dikastes";
    subPackages = [
      "app-policy/cmd/..."
    ];
  };
  calico-cni-plugin = {
    mainProgram = "calico";
    subPackages = [
      "cni-plugin/cmd/..."
    ];
  };
  calico-kube-controllers = {
    # integration tests require network and docker
    doCheck = false;
    mainProgram = "kube-controllers";
    subPackages = [
      "kube-controllers/cmd/..."
    ];
  };
  calico-pod2daemon = {
    mainProgram = "flexvol";
    subPackages = [
      "pod2daemon/csidriver"
      "pod2daemon/flexvol"
      "pod2daemon/nodeagent"
    ];
  };
  calico-typha = {
    subPackages = [
      "typha/cmd/..."
    ];
  };
  calicoctl = {
    subPackages = [
      "calicoctl/calicoctl"
    ];
  };
  confd-calico = {
    mainProgram = "confd";
    subPackages = [
      "confd"
    ];
  };
}
