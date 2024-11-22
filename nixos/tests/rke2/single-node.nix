import ../make-test-python.nix ({ pkgs, lib, rke2, ... }:
  let
    pauseImage = pkgs.dockerTools.streamLayeredImage {
      name = "test.local/pause";
      tag = "local";
      contents = pkgs.buildEnv {
        name = "rke2-pause-image-env";
        paths = with pkgs; [ tini (hiPrio coreutils) busybox ];
      };
      config.Entrypoint = [ "/bin/tini" "--" "/bin/sleep" "inf" ];
    };
    testPodYaml = pkgs.writeText "test.yaml" ''
      apiVersion: v1
      kind: Pod
      metadata:
        name: test
      spec:
        containers:
        - name: test
          image: test.local/pause:local
          imagePullPolicy: Never
          command: ["sh", "-c", "sleep inf"]
    '';
  in
  {
    name = "${rke2.name}-single-node";
    meta.maintainers = rke2.meta.maintainers;

    nodes.machine = { pkgs, ... }: {
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

    testScript = let
      kubectl = "${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml";
      ctr = "${pkgs.containerd}/bin/ctr -a /run/k3s/containerd/containerd.sock";
    in ''
      start_all()

      machine.wait_for_unit("rke2")
      machine.succeed("${kubectl} cluster-info")
      machine.wait_until_succeeds(
        "${pauseImage} | ${ctr} -n k8s.io image import -"
      )

      machine.wait_until_succeeds("${kubectl} get serviceaccount default")
      machine.succeed("${kubectl} apply -f ${testPodYaml}")
      machine.succeed("${kubectl} wait --for 'condition=Ready' pod/test")
      machine.succeed("${kubectl} delete -f ${testPodYaml}")

      machine.shutdown()
    '';
  })
