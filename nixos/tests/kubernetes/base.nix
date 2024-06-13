{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  mkKubernetesBaseTest =
    { name, domain ? "my.zyx", test, machines
    , extraConfiguration ? null }:
    let
      masterName = head (filter (machineName: any (role: role == "master") machines.${machineName}.roles) (attrNames machines));
      master = machines.${masterName};
      extraHosts = ''
        ${master.ip}  etcd.${domain}
        ${master.ip}  api.${domain}
        ${concatMapStringsSep "\n" (machineName: "${machines.${machineName}.ip}  ${machineName}.${domain}") (attrNames machines)}
      '';
      wrapKubectl = with pkgs; runCommand "wrap-kubectl" { nativeBuildInputs = [ makeWrapper ]; } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.kubernetes}/bin/kubectl $out/bin/kubectl --set KUBECONFIG "/etc/kubernetes/cluster-admin.kubeconfig"
      '';
    in makeTest {
      inherit name;

      nodes = mapAttrs (machineName: machine:
        { config, pkgs, lib, nodes, ... }:
          mkMerge [
            {
              boot.postBootCommands = "rm -fr /var/lib/kubernetes/secrets /tmp/shared/*";
              virtualisation.memorySize = mkDefault 1536;
              virtualisation.diskSize = mkDefault 4096;
              networking = {
                inherit domain extraHosts;
                primaryIPAddress = mkForce machine.ip;

                firewall = {
                  allowedTCPPorts = [
                    10250 # kubelet
                  ];
                  trustedInterfaces = ["mynet"];

                  extraCommands = concatMapStrings  (node: ''
                    iptables -A INPUT -s ${node.networking.primaryIPAddress} -j ACCEPT
                  '') (attrValues nodes);
                };
              };
              programs.bash.completion.enable = true;
              environment.systemPackages = [ wrapKubectl ];
              services.flannel.iface = "eth1";
              services.kubernetes = {
                proxy.hostname = "${masterName}.${domain}";

                easyCerts = true;
                inherit (machine) roles;
                apiserver = {
                  securePort = 443;
                  advertiseAddress = master.ip;
                };
                masterAddress = "${masterName}.${config.networking.domain}";
              };
            }
            (optionalAttrs (any (role: role == "master") machine.roles) {
              networking.firewall.allowedTCPPorts = [
                443 # kubernetes apiserver
              ];
            })
            (optionalAttrs (machine ? extraConfiguration) (machine.extraConfiguration { inherit config pkgs lib nodes; }))
            (optionalAttrs (extraConfiguration != null) (extraConfiguration { inherit config pkgs lib nodes; }))
          ]
      ) machines;

      testScript = ''
        start_all()
      '' + test;
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
