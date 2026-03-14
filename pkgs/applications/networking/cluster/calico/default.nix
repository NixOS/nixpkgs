{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

builtins.mapAttrs
  (
    pname:
    {
      doCheck ? true,
      mainProgram ? pname,
      subPackages,
    }:
    buildGoModule rec {
      inherit pname;
      version = "3.31.4";

      src = fetchFromGitHub {
        owner = "projectcalico";
        repo = "calico";
        rev = "v${version}";
        hash = "sha256-PXRs5f9w3zHwWWdzLdqOK8fxE14X7wFJAIq4/xbgM3A=";
      };

      vendorHash = "sha256-5QXK04xnFbExsovHCN0d3Y0jX2dB5Jxkq4taLmJNDow=";

      inherit doCheck subPackages;

      ldflags = [
        "-s"
        "-w"
      ];

      meta = {
        homepage = "https://projectcalico.docs.tigera.io";
        changelog = "https://github.com/projectcalico/calico/releases/tag/v${version}";
        description = "Cloud native networking and network security";
        license = lib.licenses.asl20;
        maintainers = [ ];
        platforms = lib.platforms.linux;
        inherit mainProgram;
      };
    }
  )
  {
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
