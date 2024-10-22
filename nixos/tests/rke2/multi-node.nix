import ../make-test-python.nix ({ pkgs, lib, rke2, ... }:
  let
    pauseImage = pkgs.dockerTools.streamLayeredImage {
      name = "test.local/pause";
      tag = "local";
      contents = pkgs.buildEnv {
        name = "rke2-pause-image-env";
        paths = with pkgs; [ tini bashInteractive coreutils socat ];
      };
      config.Entrypoint = [ "/bin/tini" "--" "/bin/sleep" "inf" ];
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
    agentTokenFile = pkgs.writeText "agent-token" "p@s$w0rd";
  in
  {
    name = "${rke2.name}-multi-node";
    meta.maintainers = rke2.meta.maintainers;

    nodes = {
      server1 = { pkgs, ... }: {
        networking.firewall.enable = false;
        networking.useDHCP = false;
        networking.defaultGateway = "192.168.1.1";
        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
          { address = "192.168.1.1"; prefixLength = 24; }
        ];

        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.rke2 = {
          enable = true;
          role = "server";
          inherit tokenFile;
          inherit agentTokenFile;
          nodeName = "${rke2.name}-server1";
          package = rke2;
          nodeIP = "192.168.1.1";
          disable = [
            "rke2-coredns"
            "rke2-metrics-server"
            "rke2-ingress-nginx"
          ];
          extraFlags = [
            "--cluster-reset"
          ];
        };
      };

      server2 = { pkgs, ... }: {
        networking.firewall.enable = false;
        networking.useDHCP = false;
        networking.defaultGateway = "192.168.1.2";
        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
          { address = "192.168.1.2"; prefixLength = 24; }
        ];

        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.rke2 = {
          enable = true;
          role = "server";
          serverAddr = "https://192.168.1.1:6443";
          inherit tokenFile;
          inherit agentTokenFile;
          nodeName = "${rke2.name}-server2";
          package = rke2;
          nodeIP = "192.168.1.2";
          disable = [
            "rke2-coredns"
            "rke2-metrics-server"
            "rke2-ingress-nginx"
          ];
        };
      };

      agent1 = { pkgs, ... }: {
        networking.firewall.enable = false;
        networking.useDHCP = false;
        networking.defaultGateway = "192.168.1.3";
        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
          { address = "192.168.1.3"; prefixLength = 24; }
        ];

        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.rke2 = {
          enable = true;
          role = "agent";
          tokenFile = agentTokenFile;
          serverAddr = "https://192.168.1.2:6443";
          nodeName = "${rke2.name}-agent1";
          package = rke2;
          nodeIP = "192.168.1.3";
        };
      };
    };

    testScript = let
      kubectl = "${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml";
      ctr = "${pkgs.containerd}/bin/ctr -a /run/k3s/containerd/containerd.sock";
      jq = "${pkgs.jq}/bin/jq";
      ping = "${pkgs.iputils}/bin/ping";
    in ''
      machines = [server1, server2, agent1]

      for machine in machines:
          machine.start()
          machine.wait_for_unit("rke2")

      # wait for the agent to show up
      server1.succeed("${kubectl} get node ${rke2.name}-agent1")

      for machine in machines:
          machine.succeed("${pauseImage} | ${ctr} image import -")

      server1.succeed("${kubectl} cluster-info")
      server1.wait_until_succeeds("${kubectl} get serviceaccount default")

      # Now create a pod on each node via a daemonset and verify they can talk to each other.
      server1.succeed("${kubectl} apply -f ${networkTestDaemonset}")
      server1.wait_until_succeeds(
          f'[ "$(${kubectl} get ds test -o json | ${jq} .status.numberReady)" -eq {len(machines)} ]'
      )

      # Get pod IPs
      pods = server1.succeed("${kubectl} get po -o json | ${jq} '.items[].metadata.name' -r").splitlines()
      pod_ips = [
          server1.succeed(f"${kubectl} get po {n} -o json | ${jq} '.status.podIP' -cr").strip() for n in pods
      ]

      # Verify each server can ping each pod ip
      for pod_ip in pod_ips:
          server1.succeed(f"${ping} -c 1 {pod_ip}")
          agent1.succeed(f"${ping} -c 1 {pod_ip}")

      # Verify the pods can talk to each other
      resp = server1.wait_until_succeeds(f"${kubectl} exec {pods[0]} -- socat TCP:{pod_ips[1]}:8000 -")
      assert resp.strip() == "server"
      resp = server1.wait_until_succeeds(f"${kubectl} exec {pods[1]} -- socat TCP:{pod_ips[0]}:8000 -")
      assert resp.strip() == "server"

      # Cleanup
      server1.succeed("${kubectl} delete -f ${networkTestDaemonset}")
      for machine in machines:
          machine.shutdown()
    '';
  })
