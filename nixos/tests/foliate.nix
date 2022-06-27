import ./make-test-python.nix ({ pkgs, ... }: {
  name = "foliate";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ kamadorueda ];
  };

  nodes.machine = { ... }: {
    imports = [ ./common/x11.nix ];
    config.programs.foliate = {
      enable = true;
      extraConfig = ''
        [com/github/johnfactotum/Foliate]
        footer-left='location'
        footer-right='section-name'

        [com/github/johnfactotum/Foliate/view]
        bg-color='#000000'
        fg-color='#FFFFFF'
        link-color='#00FFFF'
        layout='continuous'
        margin=0
        spacing=1.0
      '';
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_x()
    machine.succeed("foliate --version")

    machine.copy_from_vm("/etc/dconf/profile/foliate")
    with open(machine.out_dir / "foliate") as file:
        content = file.read()
        assert "user-db:user" in content

    machine.copy_from_vm("/etc/dconf/db/foliate.d/00-nixos-settings")
    with open(machine.out_dir / "00-nixos-settings") as file:
        content = file.read()
        assert "[com/github/johnfactotum/Foliate/view]" in content
  '';
})
