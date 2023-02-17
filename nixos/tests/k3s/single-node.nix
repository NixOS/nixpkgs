import ../make-test-python.nix ({ pkgs, lib, k3s, ... }:
  let
    imageEnv = pkgs.buildEnv {
      name = "k3s-pause-image-env";
      paths = with pkgs; [ tini (hiPrio coreutils) busybox ];
    };
    pauseImage = pkgs.dockerTools.streamLayeredImage {
      name = "test.local/pause";
      tag = "local";
      contents = imageEnv;
      config.Entrypoint = [ "/bin/tini" "--" "/bin/sleep" "inf" ];
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
    meta = with pkgs.lib.maintainers; {
      maintainers = [ euank ];
    };

    nodes.machine = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ k3s gzip ];

      # k3s uses enough resources the default vm fails.
      virtualisation.memorySize = 1536;
      virtualisation.diskSize = 4096;

      services.k3s.enable = true;
      services.k3s.role = "server";
      services.k3s.package = k3s;
      # Slightly reduce resource usage
      services.k3s.extraFlags = builtins.toString [
        "--disable" "coredns"
        "--disable" "local-storage"
        "--disable" "metrics-server"
        "--disable" "servicelb"
        "--disable" "traefik"
        "--pause-image" "test.local/pause:local"
      ];

      users.users = {
        noprivs = {
          isNormalUser = true;
          description = "Can't access k3s by default";
          password = "*";
        };
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("k3s")
      machine.succeed("k3s kubectl cluster-info")
      machine.fail("sudo -u noprivs k3s kubectl cluster-info")
      '' # Fix-Me: Tests fail for 'aarch64-linux' as: "CONFIG_CGROUP_FREEZER: missing (fail)"
      + lib.optionalString (!pkgs.stdenv.isAarch64) ''machine.succeed("k3s check-config")'' + ''

      machine.succeed(
          "${pauseImage} | k3s ctr image import -"
      )

      # Also wait for our service account to show up; it takes a sec
      machine.wait_until_succeeds("k3s kubectl get serviceaccount default")
      machine.succeed("k3s kubectl apply -f ${testPodYaml}")
      machine.succeed("k3s kubectl wait --for 'condition=Ready' pod/test")
      machine.succeed("k3s kubectl delete -f ${testPodYaml}")

      machine.shutdown()
    '';
  })
