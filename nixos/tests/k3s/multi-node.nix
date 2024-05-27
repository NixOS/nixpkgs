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
    pauseImage = pkgs.dockerTools.streamLayeredImage {
      name = "test.local/pause";
      tag = "local";
      contents = imageEnv;
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
        { pkgs, ... }:
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
            clusterInit = true;
            extraFlags = builtins.toString [
              "--disable"
              "coredns"
              "--disable"
              "local-storage"
              "--disable"
              "metrics-server"
              "--disable"
              "servicelb"
              "--disable"
              "traefik"
              "--node-ip"
              "192.168.1.1"
              "--pause-image"
              "test.local/pause:local"
            ];
          };
          networking.firewall.allowedTCPPorts = [
            2379
            2380
            6443
          ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
          networking.firewall.trustedInterfaces = [ "flannel.1" ];
          networking.useDHCP = false;
          networking.defaultGateway = "192.168.1.1";
          networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
        };

      server2 =
        { pkgs, ... }:
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
            serverAddr = "https://192.168.1.1:6443";
            clusterInit = false;
            extraFlags = builtins.toString [
              "--disable"
              "coredns"
              "--disable"
              "local-storage"
              "--disable"
              "metrics-server"
              "--disable"
              "servicelb"
              "--disable"
              "traefik"
              "--node-ip"
              "192.168.1.3"
              "--pause-image"
              "test.local/pause:local"
            ];
          };
          networking.firewall.allowedTCPPorts = [
            2379
            2380
            6443
          ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
          networking.firewall.trustedInterfaces = [ "flannel.1" ];
          networking.useDHCP = false;
          networking.defaultGateway = "192.168.1.3";
          networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
            {
              address = "192.168.1.3";
              prefixLength = 24;
            }
          ];
        };

      agent =
        { pkgs, ... }:
        {
          virtualisation.memorySize = 1024;
          virtualisation.diskSize = 2048;
          services.k3s = {
            inherit tokenFile;
            enable = true;
            role = "agent";
            serverAddr = "https://192.168.1.3:6443";
            extraFlags = lib.concatStringsSep " " [
              "--pause-image"
              "test.local/pause:local"
              "--node-ip"
              "192.168.1.2"
            ];
          };
          networking.firewall.allowedTCPPorts = [ 6443 ];
          networking.firewall.allowedUDPPorts = [ 8472 ];
          networking.firewall.trustedInterfaces = [ "flannel.1" ];
          networking.useDHCP = false;
          networking.defaultGateway = "192.168.1.2";
          networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
    };

    meta.maintainers = k3s.meta.maintainers;

    testScript = ''
      machines = [server, server2, agent]
      for m in machines:
          m.start()
          m.wait_for_unit("k3s")

      is_aarch64 = "${toString pkgs.stdenv.isAarch64}" == "1"

      # wait for the agent to show up
      server.wait_until_succeeds("k3s kubectl get node agent")

      for m in machines:
          # Fix-Me: Tests fail for 'aarch64-linux' as: "CONFIG_CGROUP_FREEZER: missing (fail)"
          if not is_aarch64:
              m.succeed("k3s check-config")
          m.succeed(
              "${pauseImage} | k3s ctr image import -"
          )

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
          agent.succeed(f"ping -c 1 {pod_ip}")

      # Verify the pods can talk to each other
      resp = server.wait_until_succeeds(f"k3s kubectl exec {pods[0]} -- socat TCP:{pod_ips[1]}:8000 -")
      assert resp.strip() == "server"
      resp = server.wait_until_succeeds(f"k3s kubectl exec {pods[1]} -- socat TCP:{pod_ips[0]}:8000 -")
      assert resp.strip() == "server"

      # Cleanup
      server.succeed("k3s kubectl delete -f ${networkTestDaemonset}")

      for m in machines:
          m.shutdown()
    '';
  }
)
