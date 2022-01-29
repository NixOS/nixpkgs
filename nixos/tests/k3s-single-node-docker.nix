import ./make-test-python.nix ({ pkgs, ... }:

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
    # Don't use the default service account because there's a race where it may
    # not be created yet; make our own instead.
    testPodYaml = pkgs.writeText "test.yml" ''
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: test
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: test
      spec:
        serviceAccountName: test
        containers:
        - name: test
          image: test.local/pause:local
          imagePullPolicy: Never
          command: ["sh", "-c", "sleep inf"]
    '';
  in
  {
    name = "k3s";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ euank ];
    };

    machine = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ k3s gzip ];

      # k3s uses enough resources the default vm fails.
      virtualisation.memorySize = 1536;
      virtualisation.diskSize = 4096;

      services.k3s = {
        enable = true;
        role = "server";
        docker = true;
        # Slightly reduce resource usage
        extraFlags = "--no-deploy coredns,servicelb,traefik,local-storage,metrics-server --pause-image test.local/pause:local";
      };

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
      # FIXME: this fails with the current nixos kernel config; once it passes, we should uncomment it
      # machine.succeed("k3s check-config")

      machine.succeed(
          "${pauseImage} | docker load"
      )

      machine.succeed("k3s kubectl apply -f ${testPodYaml}")
      machine.succeed("k3s kubectl wait --for 'condition=Ready' pod/test")
      machine.succeed("k3s kubectl delete -f ${testPodYaml}")

      machine.shutdown()
    '';
  })
