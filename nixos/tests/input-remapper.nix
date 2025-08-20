import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "input-remapper";
    meta = {
      maintainers = with pkgs.lib.maintainers; [ LunNova ];
    };

    nodes.machine =
      { config, ... }:
      let
        user = config.users.users.sybil;
      in
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];

        services.xserver.enable = true;
        services.input-remapper.enable = true;
        users.users.sybil = {
          isNormalUser = true;
          group = "wheel";
        };
        test-support.displayManager.auto.user = user.name;
        # workaround for pkexec not working in the test environment
        # Error creating textual authentication agent:
        #   Error opening current controlling terminal for the process (`/dev/tty'):
        #   No such device or address
        # passwordless pkexec with polkit module also doesn't work
        # to allow the program to run, we replace pkexec with sudo
        # and turn on passwordless sudo
        # this is not correct in general but good enough for this test
        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };
        security.wrappers.pkexec = pkgs.lib.mkForce {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.sudo}/bin/sudo";
        };
      };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      ''
        start_all()
        machine.wait_for_x()

        machine.succeed("systemctl status input-remapper.service")
        machine.execute("su - sybil -c input-remapper-gtk >&2 &")

        machine.wait_for_text("Input Remapper")
        machine.wait_for_text("Device")
        machine.wait_for_text("Presets")
        machine.wait_for_text("Editor")
      '';
  }
)
