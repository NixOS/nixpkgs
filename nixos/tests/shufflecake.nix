{
  name = "shufflecake";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.linuxPackages.shufflecake
        pkgs.openssl
      ];

      boot.extraModulePackages = [ pkgs.linuxPackages.shufflecake.out ];
    };

  testScript = ''
    # Create an empty disk image
    machine.succeed("fallocate -l10m /tmp/foo; losetup /dev/loop0 /tmp/foo")

    # Initialize a shufflecake device on it
    machine.succeed("openssl rand -base64 32 > /tmp/password.txt")
    machine.succeed("sflc init --num-volumes=1 /dev/loop0 < /tmp/password.txt")

    # Open the shufflecake device
    machine.succeed("sflc open /dev/loop0 < /tmp/password.txt")
    machine.succeed("stat /dev/mapper/sflc_0_0")
  '';
}
