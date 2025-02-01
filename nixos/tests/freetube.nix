let
  tests = {
    wayland =
      { pkgs, ... }:
      {
        imports = [ ./common/wayland-cage.nix ];
        services.cage.program = "${pkgs.freetube}/bin/freetube";
        virtualisation.memorySize = 2047;
        environment.variables.NIXOS_OZONE_WL = "1";
        environment.variables.DISPLAY = "do not use";
      };
    xorg =
      { pkgs, ... }:
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];
        virtualisation.memorySize = 2047;
        services.xserver.enable = true;
        services.xserver.displayManager.sessionCommands = ''
          ${pkgs.freetube}/bin/freetube
        '';
        test-support.displayManager.auto.user = "alice";
      };
  };

  mkTest =
    name: machine:
    import ./make-test-python.nix (
      { pkgs, ... }:
      {
        inherit name;
        nodes = {
          "${name}" = machine;
        };
        meta.maintainers = with pkgs.lib.maintainers; [ kirillrdy ];
        # time-out on ofborg
        meta.broken = pkgs.stdenv.hostPlatform.isAarch64;
        enableOCR = true;

        testScript = ''
          start_all()
          machine.wait_for_unit('graphical.target')
          machine.wait_for_text('Your Subscription list is currently empty')
          machine.send_key("ctrl-r")
          machine.wait_for_text('Your Subscription list is currently empty')
          machine.screenshot("main.png")
          machine.send_key("ctrl-comma")
          machine.wait_for_text('Data', timeout=60)
          machine.screenshot("preferences.png")
        '';
      }
    );
in
builtins.mapAttrs (k: v: mkTest k v) tests
