{ system ? builtins.currentSystem, pkgs ? import <nixpkgs> { inherit system; } }:
with import ./base.nix { inherit system; };
let
  domain = "my.zyx";
  certs = import ./certs.nix { externalDomain = domain; kubelets = ["machine1" "machine2"]; };
  kubeconfig = pkgs.writeText "kubeconfig.json" (builtins.toJSON {
    apiVersion = "v1";
    kind = "Config";
    clusters = [{
      name = "local";
      cluster.certificate-authority = "${certs.master}/ca.pem";
      cluster.server = "https://api.${domain}";
    }];
    users = [{
      name = "kubelet";
      user = {
        client-certificate = "${certs.admin}/admin.pem";
        client-key = "${certs.admin}/admin-key.pem";
      };
    }];
    contexts = [{
      context = {
        cluster = "local";
        user = "kubelet";
      };
      current-context = "kubelet-context";
    }];
  });

  base = {
    name = "e2e";
    inherit domain certs;
    test = ''
      $machine1->succeed("e2e.test -kubeconfig ${kubeconfig} -provider local -ginkgo.focus '\\[Conformance\\]' -ginkgo.skip '\\[Flaky\\]|\\[Serial\\]'");
    '';
  };
in {
  singlenode = mkKubernetesSingleNodeTest base;
  multinode = mkKubernetesMultiNodeTest base;
}
