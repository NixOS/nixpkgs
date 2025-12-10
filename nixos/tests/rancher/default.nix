{
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
  lib ? pkgs.lib,
  # service/package name to test
  rancherDistro,
}:
let
  allPackages = lib.filterAttrs (
    n: pkg: lib.strings.hasPrefix "${rancherDistro}_" n && (builtins.tryEval pkg).success
  ) pkgs;

  mkTestArgs = rancherPackage: {
    inherit
      system
      pkgs
      rancherDistro
      rancherPackage
      ;

    # systemd service name
    serviceName =
      {
        k3s = "k3s";
        rke2 = "rke2-server";
      }
      .${rancherDistro};

    # list passed to services.*.disable,
    # for slightly reduced resource usage
    disabledComponents =
      {
        k3s = [
          "coredns"
          "local-storage"
          "metrics-server"
          "servicelb"
          "traefik"
        ];
        rke2 = [
          "rke2-coredns"
          "rke2-metrics-server"
          "rke2-ingress-nginx"
          "rke2-snapshot-controller"
          "rke2-snapshot-controller-crd"
          "rke2-snapshot-validation-webhook"
        ];
      }
      .${rancherDistro};
  };

  importTest =
    path: extraArgs: lib.mapAttrs (_: pkg: import path ((mkTestArgs pkg) // extraArgs)) allPackages;
in
{
  airgap-images = importTest ./airgap-images.nix { };
  auto-deploy = importTest ./auto-deploy.nix { };
  auto-deploy-charts = importTest ./auto-deploy-charts.nix { };
  containerd-config = importTest ./containerd-config.nix { };
  etcd = importTest ./etcd.nix {
    inherit (pkgs) etcd;
  };
  kubelet-config = importTest ./kubelet-config.nix { };
  multi-node = importTest ./multi-node.nix { };
  single-node = importTest ./single-node.nix { };
}
