{
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
  lib ? pkgs.lib,
}:
let
  allK3s = lib.filterAttrs (
    n: _: lib.strings.hasPrefix "k3s_" n && (builtins.tryEval pkgs.${n}).success
  ) pkgs;

  tests =
    (selfTests: {
      all = lib.mapAttrs (
        _: k3s:
        let
          k3sKeyVersion = "k3s_" + (lib.versions.major k3s.version) + "_" + (lib.versions.minor k3s.version);
        in
        pkgs.buildEnv {
          name = "k3s-${k3s.version}-tests-all";
          paths =
            let
              selfTestsExceptAll = builtins.removeAttrs selfTests [ "all" ];
              getAttrsKeysAsList =
                attrs: builtins.map (item: selfTests.${item}.${k3sKeyVersion}) (builtins.attrNames attrs);
            in
            getAttrsKeysAsList selfTestsExceptAll;
        }
      ) allK3s;

      airgap-images = lib.mapAttrs (
        _: k3s: import ./airgap-images.nix { inherit system pkgs k3s; }
      ) allK3s;

      auto-deploy = lib.mapAttrs (_: k3s: import ./auto-deploy.nix { inherit system pkgs k3s; }) allK3s;

      auto-deploy-charts = lib.mapAttrs (
        _: k3s: import ./auto-deploy-charts.nix { inherit system pkgs k3s; }
      ) allK3s;

      containerd-config = lib.mapAttrs (
        _: k3s: import ./containerd-config.nix { inherit system pkgs k3s; }
      ) allK3s;

      etcd = lib.mapAttrs (
        _: k3s:
        import ./etcd.nix {
          inherit system pkgs k3s;
          inherit (pkgs) etcd;
        }
      ) allK3s;

      kubelet-config = lib.mapAttrs (
        _: k3s: import ./kubelet-config.nix { inherit system pkgs k3s; }
      ) allK3s;

      multi-node = lib.mapAttrs (_: k3s: import ./multi-node.nix { inherit system pkgs k3s; }) allK3s;

      single-node = lib.mapAttrs (_: k3s: import ./single-node.nix { inherit system pkgs k3s; }) allK3s;
    })
      tests;
in
tests
