{ runTest }:
let
  tests = {
    wayland =
      { lib, pkgs, ... }:
      {
        imports = [ ./common/wayland-cage.nix ];

        # We scale vscodium to help OCR find the small "Untitled" text.
        services.cage.program = "${lib.getExe pkgs.vscodium} --force-device-scale-factor=2";

        environment.variables.NIXOS_OZONE_WL = "1";
        environment.variables.DISPLAY = "do not use";

        fonts.packages = with pkgs; [ dejavu_fonts ];
      };
    xorg =
      { lib, pkgs, ... }:
      {
        imports = [
          ./common/user-account.nix
          ./common/x11.nix
        ];

        virtualisation.memorySize = 2047;
        services.xserver.enable = true;
        services.xserver.displayManager.sessionCommands = ''
          ${lib.getExe pkgs.vscodium} --force-device-scale-factor=2
        '';
        test-support.displayManager.auto.user = "alice";
      };
  };

  mkTest =
    name: machine:
    runTest (
      { lib, ... }:
      {
        inherit name;

        nodes."${name}" = machine;

        meta.maintainers = with lib.maintainers; [
          synthetica
          turion
        ];

        # x86_64: https://github.com/NixOS/nixpkgs/pull/452801#issuecomment-3415680343
        # aarch64: https://github.com/NixOS/nixpkgs/issues/207234
        meta.broken = name == "wayland";

        enableOCR = true;

        testScript = ''
          @polling_condition
          def codium_running():
              machine.succeed('pgrep -x codium')


          start_all()

          machine.wait_for_unit('graphical.target')

          codium_running.wait() # type: ignore[union-attr]
          with codium_running: # type: ignore[union-attr]
              # Wait until vscodium is visible. "File" is in the menu bar.
              machine.wait_for_text('(Get|Started|with|Customize|theme)')
              machine.screenshot('start_screen')

              test_string = 'testfile'

              # Create a new file
              machine.send_key('ctrl-n')
              machine.wait_for_text('(Untitled|Select|language|template|dismiss)')
              machine.screenshot('empty_editor')

              # Type a string
              machine.send_chars(test_string)
              machine.wait_for_text(test_string)
              machine.screenshot('editor')

              # Save the file
              machine.send_key('ctrl-s')
              machine.wait_for_text('(Save|Desktop|alice|Size)')
              machine.screenshot('save_window')
              machine.send_key('ret')

              # (the default filename is the first line of the file)
              machine.wait_for_file(f'/home/alice/{test_string}')

          # machine.send_key('ctrl-q')
          # machine.wait_until_fails('pgrep -x codium')
        '';
      }
    );
in
builtins.mapAttrs mkTest tests
