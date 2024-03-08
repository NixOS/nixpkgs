{ system, pkgs }:
let
  tests = {
    xorg = {
      node = { pkgs, ... }: {
        imports = [ ./common/user-account.nix ./common/x11.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sessionCommands = ''
          ${pkgs.drawterm}/bin/drawterm -g 1024x768 &
        '';
        test-support.displayManager.auto.user = "alice";
      };
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
    wayland = {
      node = { pkgs, ... }: {
        imports = [ ./common/wayland-cage.nix ];
        services.cage.program = "${pkgs.drawterm-wayland}/bin/drawterm";
      };
      systems = [ "x86_64-linux" ];
    };
  };

  mkTest = name: machine:
    import ./make-test-python.nix ({ pkgs, ... }: {
      inherit name;

      nodes = { "${name}" = machine; };

      meta = with pkgs.lib.maintainers; {
        maintainers = [ moody ];
      };

      enableOCR = true;

      testScript = ''
        @polling_condition
        def drawterm_running():
            machine.succeed("pgrep drawterm")

        start_all()

        machine.wait_for_unit("graphical.target")
        drawterm_running.wait() # type: ignore[union-attr]
        machine.wait_for_text("cpu")
        machine.send_chars("cpu\n")
        machine.wait_for_text("auth")
        machine.send_chars("cpu\n")
        machine.wait_for_text("ending")
        machine.screenshot("out.png")
      '';

    });
  mkTestOn = systems: name: machine:
    if pkgs.lib.elem system systems then mkTest name machine
    else { ... }: { };
in
builtins.mapAttrs (k: v: mkTestOn v.systems k v.node { inherit system; }) tests
