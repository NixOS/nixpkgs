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

      specialisation.fstab-test.configuration = {
        fileSystems."/plain" = {
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

    # Generate a password
    machine.execute("openssl rand -base64 32 > /tmp/password.txt")

    # Initialize an encrypted vault
    machine.execute("mkdir -p /encrypted /plain")
    machine.execute("gocryptfs -init /encrypted  -passfile /password.txt -quiet")

    # Open and mount vault
    machine.execute("gocryptfs /encrypted /plain  -passfile /tmp/password.txt -quiet")

    machine.execute("echo test > /plain/data.txt")
    machine.execute("echo test > /tmp/data.txt")

    # Unmount
    machine.execute("fusermount -u /plain")

    # Switch to the specialisation
    machine.succeed("/run/current-system/specialisation/fstab-test/bin/switch-to-configuration test")

    # Wait for mount
    machine.wait_for_unit("local-fs.target")

    # Check data
    machine.succeed("diff /plain/data.txt /tmp/data.txt")

  '';
}
