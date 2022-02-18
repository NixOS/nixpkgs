import ./make-test-python.nix ({ pkgs, ... }:

  {
    name = "input-remapper";
    meta = {
      maintainers = with pkgs.lib.maintainers; [ LunNova ];
    };

    machine = { config, ... }:
      let user = config.users.users.sybil; in
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];

        services.xserver.enable = true;
        services.input-remapper.enable = true;
        users.users.sybil = { isNormalUser = true; group = "wheel"; };
        test-support.displayManager.auto.user = user.name;
        # passwordless pkexec bodge
        security.sudo = { enable = true; wheelNeedsPassword = false; };
        security.wrappers.pkexec = pkgs.lib.mkForce
          {
            setuid = true;
            owner = "root";
            group = "root";
            source = "${pkgs.sudo}/bin/sudo";
          };
      };

    enableOCR = true;

    testScript = { nodes, ... }: ''
      start_all()
      machine.wait_for_x()

      machine.succeed("systemctl status input-remapper.service")
      machine.execute("su - sybil -c input-remapper-gtk >&2 &")

      machine.wait_for_text("Input Remapper")
      machine.wait_for_text("Preset")
      machine.wait_for_text("Change Key")
    '';
  })
