import ../make-test-python.nix (
  {
    pkgs,
    lib,
    rke2,
    ...
  }:
  let
    throwSystem = throw "RKE2: Unsupported system: ${pkgs.stdenv.hostPlatform.system}";
    coreImages =
      {
        aarch64-linux = rke2.images-core-linux-arm64-tar-zst;
        x86_64-linux = rke2.images-core-linux-amd64-tar-zst;
      }
      .${pkgs.stdenv.hostPlatform.system} or throwSystem;
    canalImages =
      {
        aarch64-linux = rke2.images-canal-linux-arm64-tar-zst;
        x86_64-linux = rke2.images-canal-linux-amd64-tar-zst;
      }
      .${pkgs.stdenv.hostPlatform.system} or throwSystem;
    helloImage = pkgs.dockerTools.buildImage {
      name = "test.local/hello";
      tag = "local";
      compressor = "zstd";
      copyToRoot = pkgs.buildEnv {
        name = "rke2-hello-image-env";
        paths = with pkgs; [
          coreutils
          socat
        ];
      };
    };
    # A daemonset that responds 'hello' on port 8000
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
              image: test.local/hello:local
              imagePullPolicy: Never
              resources:
                limits:
                  memory: 20Mi
              command: ["socat", "TCP4-LISTEN:8000,fork", "EXEC:echo hello"]
    '';
    tokenFile = pkgs.writeText "token" "p@s$w0rd";
    agentTokenFile = pkgs.writeText "agent-token" "agentP@s$w0rd";
    # Let flannel use eth1 to enable inter-node communication in tests
    canalConfig = pkgs.writeText "rke2-canal-config.yaml" ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChartConfig
      metadata:
        name: rke2-canal
        namespace: kube-system
      spec:
        valuesContent: |-
          flannel:
            iface: "eth1"
    '';
  in
  {
    name = "${rke2.name}-multi-node";
    meta.maintainers = rke2.meta.maintainers;

    nodes = {
      server =
        {
          config,
          nodes,
          pkgs,
          ...
        }:
        {
          # Setup image archives to be imported by rke2
          systemd.tmpfiles.settings."10-rke2" = {
            "/var/lib/rancher/rke2/agent/images/rke2-images-core.tar.zst" = {
              "L+".argument = "${coreImages}";
            };
            "/var/lib/rancher/rke2/agent/images/rke2-images-canal.tar.zst" = {
              "L+".argument = "${canalImages}";
            };
            "/var/lib/rancher/rke2/agent/images/hello.tar.zst" = {
              "L+".argument = "${helloImage}";
            };
            # Copy the canal config so that rke2 can write the remaining default values to it
            "/var/lib/rancher/rke2/server/manifests/rke2-canal-config.yaml" = {
              "C".argument = "${canalConfig}";
            };
          };

          # Canal CNI with VXLAN
          networking.firewall.allowedUDPPorts = [ 8472 ];
          networking.firewall.allowedTCPPorts = [
            # Kubernetes API
            6443
            # Canal CNI health checks
            9099
            # RKE2 supervisor API
            9345
          ];

          # RKE2 needs more resources than the default
          virtualisation.cores = 4;
          virtualisation.memorySize = 4096;
          virtualisation.diskSize = 8092;

          services.rke2 = {
            enable = true;
            role = "server";
            package = rke2;
            inherit tokenFile;
            inherit agentTokenFile;
            # Without nodeIP the apiserver starts with the wrong service IP family
            nodeIP = config.networking.primaryIPAddress;
            disable = [
              "rke2-coredns"
              "rke2-metrics-server"
              "rke2-ingress-nginx"
              "rke2-snapshot-controller"
              "rke2-snapshot-controller-crd"
              "rke2-snapshot-validation-webhook"
            ];
          };
        };

      agent =
        {
          config,
          nodes,
          pkgs,
          ...
        }:
        {
          # Setup image archives to be imported by rke2
          systemd.tmpfiles.settings."10-rke2" = {
            "/var/lib/rancher/rke2/agent/images/rke2-images-core.linux-amd64.tar.zst" = {
              "L+".argument = "${coreImages}";
            };
            "/var/lib/rancher/rke2/agent/images/rke2-images-canal.linux-amd64.tar.zst" = {
              "L+".argument = "${canalImages}";
            };
            "/var/lib/rancher/rke2/agent/images/hello.tar.zst" = {
              "L+".argument = "${helloImage}";
            };
            "/var/lib/rancher/rke2/server/manifests/rke2-canal-config.yaml" = {
              "C".argument = "${canalConfig}";
            };
          };

          # Canal CNI health checks
          networking.firewall.allowedTCPPorts = [ 9099 ];
          # Canal CNI with VXLAN
          networking.firewall.allowedUDPPorts = [ 8472 ];

          # The agent node can work with less resources
          virtualisation.memorySize = 2048;
          virtualisation.diskSize = 8092;

          services.rke2 = {
            enable = true;
            role = "agent";
            package = rke2;
            tokenFile = agentTokenFile;
            serverAddr = "https://${nodes.server.networking.primaryIPAddress}:9345";
            nodeIP = config.networking.primaryIPAddress;
          };
        };
    };

    testScript =
      let
        kubectl = "${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml";
        jq = "${pkgs.jq}/bin/jq";
      in
      # python
      ''
        start_all()

        server.wait_for_unit("rke2-server")
        agent.wait_for_unit("rke2-agent")

        # Wait for the agent to be ready
        server.wait_until_succeeds(r"""${kubectl} wait --for='jsonpath={.status.conditions[?(@.type=="Ready")].status}=True' nodes/agent""")

        server.succeed("${kubectl} cluster-info")
        server.wait_until_succeeds("${kubectl} get serviceaccount default")

        # Now create a pod on each node via a daemonset and verify they can talk to each other.
        server.succeed("${kubectl} apply -f ${networkTestDaemonset}")
        server.wait_until_succeeds(
            f'[ "$(${kubectl} get ds test -o json | ${jq} .status.numberReady)" -eq {len(machines)} ]'
        )

        # Get pod IPs
        pods = server.succeed("${kubectl} get po -o json | ${jq} '.items[].metadata.name' -r").splitlines()
        pod_ips = [
            server.succeed(f"${kubectl} get po {n} -o json | ${jq} '.status.podIP' -cr").strip() for n in pods
        ]

        # Verify each node can ping each pod ip
        for pod_ip in pod_ips:
            # The CNI sometimes needs a little time
            server.wait_until_succeeds(f"ping -c 1 {pod_ip}", timeout=5)
            agent.wait_until_succeeds(f"ping -c 1 {pod_ip}", timeout=5)
            # Verify the server can exec into the pod
            # for pod in pods:
            #     resp = server.succeed(f"${kubectl} exec {pod} -- socat TCP:{pod_ip}:8000 -")
            #     assert resp.strip() == "hello", f"Unexpected response from hello daemonset: {resp.strip()}"
      '';
  }
)
