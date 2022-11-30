{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  baseline = {
    virtualisation.useBootLoader = true;
  };
  grub = {
    boot.loader.grub.enable = true;
  };
  systemd-boot = {
    boot.loader.systemd-boot.enable = true;
  };
  uefi = {
    virtualisation.useEFIBoot = true;
    boot.loader.efi.canTouchEfiVariables = true;
    environment.systemPackages = [ pkgs.efibootmgr ];
  };
  standard = {
    boot.bootspec.enable = true;

    imports = [
      baseline
      systemd-boot
      uefi
    ];
  };
in
{
  basic = makeTest {
    name = "systemd-boot-with-bootspec";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = standard;

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /run/current-system/bootspec/boot.json")
    '';
  };

  grub = makeTest {
    name = "grub-with-bootspec";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = {
      boot.bootspec.enable = true;

      imports = [
        baseline
        grub
        uefi
      ];
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /run/current-system/bootspec/boot.json")
    '';
  };

  legacy-boot = makeTest {
    name = "legacy-boot-with-bootspec";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = {
      boot.bootspec.enable = true;

      imports = [
        baseline
        grub
      ];
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /run/current-system/bootspec/boot.json")
    '';
  };

  # Check that specialisations create corresponding entries in bootspec.
  specialisation = makeTest {
    name = "bootspec-with-specialisation";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = {
      imports = [ standard ];
      environment.systemPackages = [ pkgs.jq ];
      specialisation.something.configuration = {};
    };

    testScript = ''
      import json

      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /run/current-system/bootspec/boot.json")
      machine.succeed("test -e /run/current-system/specialisation/something/bootspec/boot.json")

      sp_in_parent = json.loads(machine.succeed("jq -r '.v1.specialisation.something' /run/current-system/bootspec/boot.json"))
      sp_in_fs = json.loads(machine.succeed("cat /run/current-system/specialisation/something/bootspec/boot.json"))

      assert sp_in_parent == sp_in_fs['v1'], "Bootspecs of the same specialisation are different!"
    '';
  };

  # Check that extensions are propagated.
  extensions = makeTest {
    name = "bootspec-with-extensions";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = { config, ... }: {
      imports = [ standard ];
      environment.systemPackages = [ pkgs.jq ];
      boot.bootspec.extensions = {
        osRelease = config.environment.etc."os-release".source;
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      current_os_release = machine.succeed("cat /etc/os-release")
      bootspec_os_release = machine.succeed("cat $(jq -r '.v1.extensions.osRelease' /run/current-system/bootspec/boot.json)")

      assert current_os_release == bootspec_os_release, "Filename referenced by extension has unexpected contents"
    '';
  };

}
