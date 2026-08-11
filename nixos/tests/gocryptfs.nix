{
  name = "gocryptfs";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { pkgs, ... }:
    {

      environment.systemPackages = [
        pkgs.gocryptfs
        pkgs.openssl
      ];

      programs.fuse.enable = true;

      specialisation.fstab-test.configuration = {
        # This can't be fileSytems, as the qemu machinery doesn't honor it.
        virtualisation.fileSystems."/plain" = {
          device = "/encrypted";
          fsType = "fuse.gocryptfs";
          options = [
            "nofail"
            "allow_other"
            "passfile=/tmp/password.txt"
          ];
        };
      };
    };

  testScript = ''
    # Initialize a gocryptfs filesystem and mount it
    machine.succeed("openssl rand -base64 32 > /tmp/password.txt")
    machine.succeed("mkdir -p /encrypted /plain")
    machine.succeed("gocryptfs -init /encrypted  -passfile /tmp/password.txt -quiet")
    machine.succeed("gocryptfs /encrypted /plain  -passfile /tmp/password.txt -quiet")

    # Drop a canary file and unmount
    machine.succeed("echo success > /plain/data.txt")
    machine.succeed("fusermount -u /plain")

    # Switch to a specialisation that has this in /etc/fstab
    machine.succeed("/run/current-system/specialisation/fstab-test/bin/switch-to-configuration switch")

    # Wait for mounts
    machine.wait_for_unit("local-fs.target")

    # Sometimes gocryptfs files are slow to appear
    machine.wait_for_file("/plain/data.txt")

    # Ensure the canary is alive
    machine.succeed("grep -q success /plain/data.txt")

  '';
}
