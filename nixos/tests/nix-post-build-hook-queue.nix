{
  ...
}:
let
  cacheDomain = "nix-cache.home.arpa";
in
{
  name = "nix-post-build-hook-queue";

  nodes = {
    build =
      {
        lib,
        nodes,
        ...
      }:
      {
        networking.hosts.${nodes.cache.networking.primaryIPAddress} = [ cacheDomain ];

        virtualisation.writableStore = true;

        nix.settings = {
          # do not attempt to fetch from cache.nixos.org
          substituters = lib.mkForce [ ];
          experimental-features = "nix-command";
        };

        services.nix-post-build-hook-queue = {
          enable = true;
          sshPrivateKeyPath = ./initrd-network-ssh/id_ed25519;
          uploadTo = "ssh://nix-ssh@${cacheDomain}";
        };

        programs.ssh.knownHosts.${cacheDomain} = {
          hostNames = [ cacheDomain ];
          publicKeyFile = ./initrd-network-ssh/ssh_host_ed25519_key.pub;
        };
      };

    cache =
      { ... }:
      {
        nix = {
          sshServe = {
            enable = true;
            write = true;
            keys = [
              (builtins.readFile ./initrd-network-ssh/id_ed25519.pub)
            ];
          };
          # required for writing without a valid signature
          settings.trusted-users = [ "nix-ssh" ];
        };

        environment.etc = {
          "ssh/ssh_host_ed25519_key" = {
            source = ./initrd-network-ssh/ssh_host_ed25519_key;
            mode = "0600";
          };
          "ssh/ssh_host_ed25519_key.pub" = {
            source = ./initrd-network-ssh/ssh_host_ed25519_key.pub;
            mode = "0644";
          };
        };

        services.openssh = {
          enable = true;
          hostKeys = [
            {
              type = "ed25519";
              path = "/etc/ssh/ssh_host_ed25519_key";
            }
          ];
        };
      };
  };

  testScript = ''
    # from nixos/tests/qemu-vm-store.nix
    build_derivation = """
      nix-build --option substitute false -E 'derivation {{
        name = "{name}";
        builder = "/bin/sh";
        args = ["-c" "echo something > $out"];
        system = builtins.currentSystem;
        preferLocalBuild = true;
      }}'
    """

    start_all()

    build.systemctl("start network-online.target")
    cache.systemctl("start network-online.target")
    build.wait_for_unit("network-online.target")
    cache.wait_for_unit("network-online.target")

    with subtest("Basic upload"):
      for name in ("a", "b"):
        store_path: str = build.succeed(build_derivation.format(name=name)).rsplit(" ", 1)[-1].strip()
        print(f"{store_path=}")
        cache.wait_until_succeeds(f"nix-store --verify-path {store_path}", timeout=3)

    with subtest("Graceful exit"):
      build.succeed("journalctl --grep 'nix-post-build-hook-queue.service: Deactivated successfully'")
  '';
}
