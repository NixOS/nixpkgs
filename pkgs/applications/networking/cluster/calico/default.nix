{ lib, buildGoModule, fetchFromGitHub }:

builtins.mapAttrs (pname: { doCheck ? true, mainProgram ? pname, subPackages }: buildGoModule rec {
  inherit pname;
  version = "3.28.1";

  src = fetchFromGitHub {
    owner = "projectcalico";
    repo = "calico";
    rev = "v${version}";
    hash = "sha256-IQGDuxk3ZDtrY/RLp2DfdCWtBNMTYPOitcVCcxH7HoY=";
  };

  vendorHash = "sha256-F44n+n9jfGYBQC1I33ylp8ZJtMi+uzjOLeG+5MbVePs=";

  inherit doCheck subPackages;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://projectcalico.docs.tigera.io";
    changelog = "https://github.com/projectcalico/calico/releases/tag/v${version}";
    description = "Cloud native networking and network security";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
    platforms = platforms.linux;
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
