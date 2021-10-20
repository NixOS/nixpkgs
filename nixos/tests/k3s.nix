import ./make-test-python.nix ({ pkgs, ... }:

let
  # A suitable k3s pause image, also used for the test pod
  pauseImage = pkgs.dockerTools.buildImage {
    name = "test.local/pause";
    tag = "local";
    contents = with pkgs; [ tini coreutils busybox ];
    config.Entrypoint = [ "/bin/tini" "--" "/bin/sleep" "inf" ];
  };
  testPodYaml = pkgs.writeText "test.yml" ''
    # Don't use the default service account because there's a race where it may
    # not be created yet; make our own instead.
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

  nodes = {
    k3s =
      { pkgs, ... }: {
        environment.systemPackages = [ pkgs.k3s pkgs.gzip ];

        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = pkgs.lib.mkDefault 1536;
        virtualisation.diskSize = pkgs.lib.mkDefault 4096;

        services.k3s.enable = true;
        services.k3s.role = "server";
        services.k3s.package = pkgs.k3s;
        # Slightly reduce resource usage
        services.k3s.extraFlags = "--no-deploy coredns,servicelb,traefik,local-storage,metrics-server --pause-image test.local/pause:local";

        users.users = {
          noprivs = {
            isNormalUser = true;
            description = "Can't access k3s by default";
            password = "*";
          };
        };
      };
  };

  testScript = ''
    start_all()

    k3s.wait_for_unit("k3s")
    k3s.succeed("k3s kubectl cluster-info")
    k3s.fail("sudo -u noprivs k3s kubectl cluster-info")
    # k3s.succeed("k3s check-config") # fails with the current nixos kernel config, uncomment once this passes

    k3s.succeed(
        "zcat ${pauseImage} | k3s ctr image import -"
    )

    k3s.succeed("k3s kubectl apply -f ${testPodYaml}")
    k3s.succeed("k3s kubectl wait --for 'condition=Ready' pod/test")
  '';
})
