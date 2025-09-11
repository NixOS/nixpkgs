# A test that runs a single node k3s cluster and verify a pod can run
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
        (hiPrio coreutils)
        busybox
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
    testPodYaml = pkgs.writeText "test.yml" ''
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
    name = "${k3s.name}-single-node";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          k3s
          gzip
        ];

        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.k3s.enable = true;
        services.k3s.role = "server";
        services.k3s.package = k3s;
        # Slightly reduce resource usage
        services.k3s.extraFlags = [
          "--disable coredns"
          "--disable local-storage"
          "--disable metrics-server"
          "--disable servicelb"
          "--disable traefik"
          "--pause-image test.local/pause:local"
        ];

        users.users = {
          noprivs = {
            isNormalUser = true;
            description = "Can't access k3s by default";
            password = "*";
          };
        };
      };

    testScript = # python
      ''
        start_all()

        machine.wait_for_unit("k3s")
        machine.succeed("kubectl cluster-info")
        machine.fail("sudo -u noprivs kubectl cluster-info")
        machine.succeed("k3s check-config")
        machine.succeed(
            "${pauseImage} | ctr image import -"
        )

        # Also wait for our service account to show up; it takes a sec
        machine.wait_until_succeeds("kubectl get serviceaccount default")
        machine.succeed("kubectl apply -f ${testPodYaml}")
        machine.succeed("kubectl wait --for 'condition=Ready' pod/test")
        machine.succeed("kubectl delete -f ${testPodYaml}")

        # regression test for #176445
        machine.fail("journalctl -o cat -u k3s.service | grep 'ipset utility not found'")

        with subtest("Run k3s-killall"):
            # Call the killall script with a clean path to assert that
            # all required commands are wrapped
            output = machine.succeed("PATH= ${k3s}/bin/k3s-killall.sh 2>&1 | tee /dev/stderr")
            t.assertNotIn("command not found", output, "killall script contains unknown command")

            # Check that killall cleaned up properly
            machine.fail("systemctl is-active k3s.service")
            machine.fail("systemctl list-units | grep containerd")
            machine.fail("ip link show | awk -F': ' '{print $2}' | grep -e flannel -e cni0")
            machine.fail("ip netns show | grep cni-")
      '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
