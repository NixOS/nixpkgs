# A test that runs a multi-node rancher cluster and verifies pod networking works across nodes
{
  pkgs,
  lib,
  rancherDistro,
  rancherPackage,
  serviceName,
  disabledComponents,
  coreImages,
  vmResources,
  ...
}:
let
  imageEnv = pkgs.buildEnv {
    name = "${rancherDistro}-pause-image-env";
    paths = with pkgs; [
      tini
      bashInteractive
      coreutils
      socat
    ];
  };
  pauseImage = pkgs.dockerTools.buildImage {
    name = "test.local/pause";
    tag = "local";
    copyToRoot = imageEnv;
    config.Entrypoint = [
      "/bin/tini"
      "--"
      "/bin/sleep"
      "inf"
    ];
  };
  # A daemonset that responds 'server' on port 8000
  networkTestDaemonset = pkgs.writeText "test.yml" ''
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: test
      labels:
        name: test
    spec:
      selector:
        matchLabels:
          name: test
      template:
        metadata:
          labels:
            name: test
        spec:
          containers:
          - name: test
            image: test.local/pause:local
            imagePullPolicy: Never
            resources:
              limits:
                memory: 20Mi
            command: ["socat", "TCP4-LISTEN:8000,fork", "EXEC:echo server"]
  '';
  tokenFile = pkgs.writeText "token" "p@s$w0rd";

  supervisorPort =
    {
      k3s = "6443";
      rke2 = "9345";
    }
    .${rancherDistro};
in
{
  name = "${rancherPackage.name}-multi-node";

  nodes = {
    server =
      {
        nodes,
        pkgs,
        config,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          kubectl
          gzip
          jq
        ];
        environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

        virtualisation = vmResources;

        services.${rancherDistro} = lib.mkMerge [
          {
            inherit tokenFile;
            enable = true;
            role = "server";
            package = rancherPackage;
            images = coreImages ++ [ pauseImage ];
            nodeIP = config.networking.primaryIPAddress;
            disable = disabledComponents;
            extraFlags = [
              "--pause-image test.local/pause:local"
            ];
          }
          {
            k3s = {
              clusterInit = true;
              extraFlags = [ "--flannel-iface eth1" ]; # see canalConfig definition
            };

            # The interface selection logic of flannel & canal would normally use eth0, as
            # the nixos testing driver sets a default route via dev eth0. However, in test
            # setups we have to use eth1 for inter-node communication.
            # For K3s this can be handled via --flannel-iface, but RKE2's canal has to be
            # configured with this manifest.
            rke2.manifests.canal-config.content = {
              apiVersion = "helm.cattle.io/v1";
              kind = "HelmChartConfig";
              metadata = {
                name = "rke2-canal";
                namespace = "kube-system";
              };
              # spec.valuesContent needs to a string, either json or yaml
              spec.valuesContent = builtins.toJSON {
                flannel.iface = "eth1";
              };
            };
          }
          .${rancherDistro}
        ];

        networking.firewall.enable = false;
        networking.firewall.allowedTCPPorts = [
          2379
          2380
          6443
        ]
        ++ lib.optionals (rancherDistro == "rke2") [
          9099
          9345
        ];
        networking.firewall.allowedUDPPorts = [ 8472 ];
      };

    server2 =
      {
        nodes,
        pkgs,
        config,
        ...
      }:
      {
        virtualisation = vmResources;

        services.${rancherDistro} = {
          inherit tokenFile;
          enable = true;
          role = "server";
          package = rancherPackage;
          images = coreImages ++ [ pauseImage ];
          serverAddr = "https://${nodes.server.networking.primaryIPAddress}:${supervisorPort}";
          nodeIP = config.networking.primaryIPAddress;
          disable = disabledComponents;
          extraFlags = [
            "--pause-image test.local/pause:local"
          ]
          ++ lib.optional (rancherDistro == "k3s") "--flannel-iface eth1";
        };

        networking.firewall.enable = false;
        networking.firewall.allowedTCPPorts = [
          2379
          2380
          6443
        ]
        ++ lib.optionals (rancherDistro == "rke2") [
          9099
          9345
        ];
        networking.firewall.allowedUDPPorts = [ 8472 ];
      };

    agent =
      {
        nodes,
        pkgs,
        config,
        ...
      }:
      {
        virtualisation = vmResources;

        services.${rancherDistro} = {
          inherit tokenFile;
          enable = true;
          role = "agent";
          package = rancherPackage;
          images = coreImages ++ [ pauseImage ];
          serverAddr = "https://${nodes.server2.networking.primaryIPAddress}:${supervisorPort}";
          nodeIP = config.networking.primaryIPAddress;
          extraFlags = [
            "--pause-image test.local/pause:local"
          ]
          ++ lib.optional (rancherDistro == "k3s") "--flannel-iface eth1";
        };

        networking.firewall.allowedTCPPorts = lib.optional (rancherDistro == "rke2") 9099;
        networking.firewall.allowedUDPPorts = [ 8472 ];
      };
  };

  testScript = # python
    ''
      start_all()

      servers = [server, server2]
      for m in servers:
          m.wait_for_unit("${serviceName}")

      # wait for the agent to show up
      server.wait_until_succeeds("kubectl get node agent")

      ${lib.optionalString (rancherDistro == "k3s") ''
        for m in machines:
            m.succeed("k3s check-config")
      ''}

      server.succeed("kubectl cluster-info")
      # Also wait for our service account to show up; it takes a sec
      server.wait_until_succeeds("kubectl get serviceaccount default")

      # Now create a pod on each node via a daemonset and verify they can talk to each other.
      server.succeed("kubectl apply -f ${networkTestDaemonset}")
      server.wait_until_succeeds(f'[ "$(kubectl get ds test -o json | jq .status.numberReady)" -eq {len(machines)} ]')

      # Get pod IPs
      pods = server.succeed("kubectl get po -o json | jq '.items[].metadata.name' -r").splitlines()
      pod_ips = [server.succeed(f"kubectl get po {name} -o json | jq '.status.podIP' -cr").strip() for name in pods]

      # Verify each server can ping each pod ip
      for pod_ip in pod_ips:
          server.succeed(f"ping -c 1 {pod_ip}")
          server2.succeed(f"ping -c 1 {pod_ip}")
          agent.succeed(f"ping -c 1 {pod_ip}")
          # Verify the pods can talk to each other
          for pod in pods:
              resp = server.succeed(f"kubectl exec {pod} -- socat TCP:{pod_ip}:8000 -")
              t.assertEqual(resp.strip(), "server")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
