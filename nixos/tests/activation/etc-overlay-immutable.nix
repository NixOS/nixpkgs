{ lib, ... }: {

  name = "activation-etc-overlay-immutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = { pkgs, ... }: {
    system.etc.overlay.enable = true;
    system.etc.overlay.mutable = false;

    # Prerequisites
    systemd.sysusers.enable = true;
    users.mutableUsers = false;
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    specialisation.new-generation.configuration = {
      environment.etc."newgen".text = "newgen";
    };
  };

  testScript = ''
    machine.succeed("findmnt --kernel --type overlay /etc")
    machine.fail("stat /etc/newgen")

    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")

    assert machine.succeed("cat /etc/newgen") == "newgen"
  '';
}
