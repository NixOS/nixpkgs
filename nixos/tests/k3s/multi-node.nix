# A test that runs a multi-node k3s cluster and verify pod networking works across nodes
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    k3s,
    ...
  }:
  let
    imageEnv = pkgs.buildEnv {
      name = "k3s-pause-image-env";
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
  in
  {
    name = "${k3s.name}-multi-node";

    nodes = {
      server =
        { nodes, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            gzip
            jq
          ];
          # k3s uses enough resources the default vm fails.
          virtualisation.memorySize = 1536;
          virtualisation.diskSize = 4096;

          services.k3s = {
            inherit tokenFile;
            enable = true;
            role = "server";
            package = k3s;
            images = [ pauseImage ];
            clusterInit = true;
            extraFlags = [
              "--disable coredns"
              "--disable local-storage"
              "--disable metrics-server"
              "--disable servicelb"
              "--disable traefik"
              "--pause-image test.local/pause:local"
              "--node-ip ${nodes.server.networking.primaryIPAddress}"
              # The interface selection logic of flannel would normally use eth0, as the nixos
              # testing driver sets a default route via dev eth0. However, in test setups we
              # have to use eth1 for inter-node communication.
              "--flannel-iface eth1"
            ];
          };
          networking.firewall.allowedTCPPorts = [
            2379
            2380
            6443
          ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
        };

      server2 =
        { nodes, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            gzip
            jq
          ];
          virtualisation.memorySize = 1536;
          virtualisation.diskSize = 4096;

          services.k3s = {
            inherit tokenFile;
            enable = true;
            package = k3s;
            images = [ pauseImage ];
            serverAddr = "https://${nodes.server.networking.primaryIPAddress}:6443";
            clusterInit = false;
            extraFlags = [
              "--disable coredns"
              "--disable local-storage"
              "--disable metrics-server"
              "--disable servicelb"
              "--disable traefik"
              "--pause-image test.local/pause:local"
              "--node-ip ${nodes.server2.networking.primaryIPAddress}"
              "--flannel-iface eth1"
            ];
          };
          networking.firewall.allowedTCPPorts = [
            2379
            2380
            6443
          ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
        };

      agent =
        { nodes, pkgs, ... }:
        {
          virtualisation.memorySize = 1024;
          virtualisation.diskSize = 2048;
          services.k3s = {
            inherit tokenFile;
            enable = true;
            role = "agent";
            package = k3s;
            images = [ pauseImage ];
            serverAddr = "https://${nodes.server2.networking.primaryIPAddress}:6443";
            extraFlags = [
              "--pause-image test.local/pause:local"
              "--node-ip ${nodes.agent.networking.primaryIPAddress}"
              "--flannel-iface eth1"
            ];
          };
          networking.firewall.allowedTCPPorts = [ 6443 ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
        };
    };

    testScript = # python
      ''
        start_all()

        machines = [server, server2, agent]
        for m in machines:
            m.wait_for_unit("k3s")

        # wait for the agent to show up
        server.wait_until_succeeds("k3s kubectl get node agent")

        for m in machines:
            m.succeed("k3s check-config")

        server.succeed("k3s kubectl cluster-info")
        # Also wait for our service account to show up; it takes a sec
        server.wait_until_succeeds("k3s kubectl get serviceaccount default")

        # Now create a pod on each node via a daemonset and verify they can talk to each other.
        server.succeed("k3s kubectl apply -f ${networkTestDaemonset}")
        server.wait_until_succeeds(f'[ "$(k3s kubectl get ds test -o json | jq .status.numberReady)" -eq {len(machines)} ]')

        # Get pod IPs
        pods = server.succeed("k3s kubectl get po -o json | jq '.items[].metadata.name' -r").splitlines()
        pod_ips = [server.succeed(f"k3s kubectl get po {name} -o json | jq '.status.podIP' -cr").strip() for name in pods]

        # Verify each server can ping each pod ip
        for pod_ip in pod_ips:
            server.succeed(f"ping -c 1 {pod_ip}")
            server2.succeed(f"ping -c 1 {pod_ip}")
            agent.succeed(f"ping -c 1 {pod_ip}")
            # Verify the pods can talk to each other
            for pod in pods:
                resp = server.succeed(f"k3s kubectl exec {pod} -- socat TCP:{pod_ip}:8000 -")
                t.assertEqual(resp.strip(), "server")
      '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
