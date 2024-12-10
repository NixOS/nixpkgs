{ lib, ... }:
{

  name = "activation-etc-overlay-mutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { pkgs, ... }:
    {
      system.etc.overlay.enable = true;
      system.etc.overlay.mutable = true;

      # Prerequisites
      boot.initrd.systemd.enable = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      specialisation.new-generation.configuration = {
        environment.etc."newgen".text = "newgen";
      };
    };

  testScript = ''
    with subtest("/etc is mounted as an overlay"):
      machine.succeed("findmnt --kernel --type overlay /etc")

    with subtest("switching to the same generation"):
      machine.succeed("/run/current-system/bin/switch-to-configuration test")

    with subtest("switching to a new generation"):
      machine.fail("stat /etc/newgen")
      machine.succeed("echo -n 'mutable' > /etc/mutable")

      machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")

      assert machine.succeed("cat /etc/newgen") == "newgen"
      assert machine.succeed("cat /etc/mutable") == "mutable"
  '';
}
