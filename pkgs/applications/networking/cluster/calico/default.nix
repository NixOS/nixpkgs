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
      version = "3.30.4";

      src = fetchFromGitHub {
        owner = "projectcalico";
        repo = "calico";
        rev = "v${version}";
        hash = "sha256-WhEdSmJxTLOYke7Jszca+P7dWCLs9tZF074Okl4vDpw=";
      };

      vendorHash = "sha256-W+rHPYCuP9rK/f8yYutP4Cac8cJ6XKtoVAxCeqPtpsM=";

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
        maintainers = with lib.maintainers; [ urandom ];
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
