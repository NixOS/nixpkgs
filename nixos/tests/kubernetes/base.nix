{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  mkKubernetesBaseTest =
    { name, domain ? "my.zyx", test, machines
    , pkgs ? import <nixpkgs> { inherit system; }
    , certs ? import ./certs.nix { inherit pkgs; externalDomain = domain; kubelets = attrNames machines; }
    , extraConfiguration ? null }:
    let
      masterName = head (filter (machineName: any (role: role == "master") machines.${machineName}.roles) (attrNames machines));
      master = machines.${masterName};
      extraHosts = ''
        ${master.ip}  etcd.${domain}
        ${master.ip}  api.${domain}
        ${concatMapStringsSep "\n" (machineName: "${machines.${machineName}.ip}  ${machineName}.${domain}") (attrNames machines)}
      '';
    in makeTest {
      inherit name;

      nodes = mapAttrs (machineName: machine:
        { config, pkgs, lib, nodes, ... }:
          mkMerge [
            {
              virtualisation.memorySize = mkDefault 1536;
              virtualisation.diskSize = mkDefault 4096;
              networking = {
                inherit domain extraHosts;
                primaryIPAddress = mkForce machine.ip;

                firewall = {
                  allowedTCPPorts = [
                    10250 # kubelet
                  ];
                  trustedInterfaces = ["docker0"];

                  extraCommands = concatMapStrings  (node: ''
                    iptables -A INPUT -s ${node.config.networking.primaryIPAddress} -j ACCEPT
                  '') (attrValues nodes);
                };
              };
              programs.bash.enableCompletion = true;
              environment.variables = {
                ETCDCTL_CERT_FILE = "${certs.worker}/etcd-client.pem";
                ETCDCTL_KEY_FILE = "${certs.worker}/etcd-client-key.pem";
                ETCDCTL_CA_FILE = "${certs.worker}/ca.pem";
                ETCDCTL_PEERS = "https://etcd.${domain}:2379";
              };
              services.flannel.iface = "eth1";
              services.kubernetes.apiserver.advertiseAddress = master.ip;
            }
            (optionalAttrs (any (role: role == "master") machine.roles) {
              networking.firewall.allowedTCPPorts = [
                2379 2380  # etcd
                443 # kubernetes apiserver
              ];
              services.etcd = {
                enable = true;
                certFile = "${certs.master}/etcd.pem";
                keyFile = "${certs.master}/etcd-key.pem";
                trustedCaFile = "${certs.master}/ca.pem";
                peerClientCertAuth = true;
                listenClientUrls = ["https://0.0.0.0:2379"];
                listenPeerUrls = ["https://0.0.0.0:2380"];
                advertiseClientUrls = ["https://etcd.${config.networking.domain}:2379"];
                initialCluster = ["${masterName}=https://etcd.${config.networking.domain}:2380"];
                initialAdvertisePeerUrls = ["https://etcd.${config.networking.domain}:2380"];
              };
            })
            (import ./kubernetes-common.nix { inherit (machine) roles; inherit pkgs config certs; })
            (optionalAttrs (machine ? "extraConfiguration") (machine.extraConfiguration { inherit config pkgs lib nodes; }))
            (optionalAttrs (extraConfiguration != null) (extraConfiguration { inherit config pkgs lib nodes; }))
          ]
      ) machines;

      testScript = ''
        startAll;

        ${test}
      '';
    };

  mkKubernetesMultiNodeTest = attrs: mkKubernetesBaseTest ({
    machines = {
      machine1 = {
        roles = ["master"];
        ip = "192.168.1.1";
      };
      machine2 = {
        roles = ["node"];
        ip = "192.168.1.2";
      };
    };
  } // attrs // {
    name = "kubernetes-${attrs.name}-multinode";
  });

  mkKubernetesSingleNodeTest = attrs: mkKubernetesBaseTest ({
    machines = {
      machine1 = {
        roles = ["master" "node"];
        ip = "192.168.1.1";
      };
    };
  } // attrs // {
    name = "kubernetes-${attrs.name}-singlenode";
  });
in {
  inherit mkKubernetesBaseTest mkKubernetesSingleNodeTest mkKubernetesMultiNodeTest;
}
