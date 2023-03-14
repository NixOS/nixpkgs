let
  tests = {
    wayland = { pkgs, ... }: {
      imports = [ ./common/wayland-cage.nix ];

      services.cage.program = "${pkgs.vscodium}/bin/codium";

      environment.variables.NIXOS_OZONE_WL = "1";
      environment.variables.DISPLAY = "do not use";

      fonts.fonts = with pkgs; [ dejavu_fonts ];
    };
    xorg = { pkgs, ... }: {
      imports = [ ./common/user-account.nix ./common/x11.nix ];

      virtualisation.memorySize = 2047;
      services.xserver.enable = true;
      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.vscodium}/bin/codium
      '';
      test-support.displayManager.auto.user = "alice";
    };
  };

  mkTest = name: machine:
    import ./make-test-python.nix ({ pkgs, ... }: {
      inherit name;

      nodes = { "${name}" = machine; };

      meta = with pkgs.lib.maintainers; {
        maintainers = [ synthetica turion ];
      };
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
            machine.wait_for_text('Welcome')
            machine.screenshot('start_screen')

            test_string = 'testfile'

            # Create a new file
            machine.send_key('ctrl-n')
            machine.wait_for_text('Untitled')
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
    });

in
builtins.mapAttrs (k: v: mkTest k v { }) tests
