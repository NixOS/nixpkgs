{ pkgs, ... }:
{
  name = "stableEntry";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      virtualisation.efi.keepVariables = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.limine.extraConfig = "remember_last_entry: yes";
      boot.loader.timeout = 0;
      nix.enable = true;

      specialisation.updated.configuration = {
        environment.etc."stable-current-marker".text = "updated";
      };
    };

  testScript =
    { nodes, ... }:
    let
      originalSystem = nodes.machine.system.build.toplevel;
      updatedSystem = nodes.machine.specialisation.updated.configuration.system.build.toplevel;
    in
    ''
      def menu_entry(title):
        config = machine.succeed("cat /boot/limine/limine.conf")
        return config.split(f"\n{title}\n", 1)[1].split("\n/", 1)[0]

      machine.start(allow_reboot=True)
      with subtest('Machine boots correctly'):
        machine.wait_for_unit('multi-user.target')

      with subtest('A stable current-system entry is generated'):
        machine.succeed("grep -x '/NixOS' /boot/limine/limine.conf")
        machine.succeed("grep -x '/+NixOS generations' /boot/limine/limine.conf")
        machine.succeed("grep -x 'default_entry: 1' /boot/limine/limine.conf")
        machine.succeed("grep -A8 -x '/NixOS' /boot/limine/limine.conf | grep -F 'init=${originalSystem}/init'")
        generation = machine.succeed("readlink /nix/var/nix/profiles/system").strip().rsplit("-", 2)[1]
        generation_comment = menu_entry("///Default").splitlines()[0].removeprefix("comment: ")
        assert menu_entry("/NixOS").splitlines()[0] == f"comment: Generation {generation}, {generation_comment}"

      with subtest('The stable entry follows the configuration being installed'):
        machine.succeed("${updatedSystem}/bin/switch-to-configuration boot")
        machine.succeed("grep -A8 -x '/NixOS' /boot/limine/limine.conf | grep -F 'init=${updatedSystem}/init'")
        machine.succeed("grep -x '/+NixOS generations' /boot/limine/limine.conf")
        specialisation_comment = menu_entry("///updated").splitlines()[0].removeprefix("comment: ")
        assert menu_entry("/NixOS").splitlines()[0] == f"comment: Generation {generation} (specialisation 'updated'), {specialisation_comment}"

      with subtest('The updated stable entry boots correctly'):
        machine.reboot()
        machine.wait_for_unit('multi-user.target')
        machine.succeed("grep -x updated /etc/stable-current-marker")

      with subtest('Duplicate matches do not invent a generation or timestamp'):
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${updatedSystem}")
        machine.succeed("${updatedSystem}/bin/switch-to-configuration boot")
        assert "init=${updatedSystem}/init" in menu_entry("/NixOS")
        assert menu_entry("/NixOS").splitlines()[0] == "comment: " + specialisation_comment.split(", built on ")[0]

      with subtest('Rollback describes the installed generation, not the newest one'):
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --rollback")
        machine.succeed("${originalSystem}/bin/switch-to-configuration boot")
        assert "init=${originalSystem}/init" in menu_entry("/NixOS")
        assert menu_entry("/NixOS").splitlines()[0] == f"comment: Generation {generation}, {generation_comment}"
        assert "init=${updatedSystem}/init" in menu_entry("//Generation " + str(int(generation) + 1))
        machine.reboot()
        machine.wait_for_unit('multi-user.target')
        machine.fail("test -e /etc/stable-current-marker")
    '';
}
