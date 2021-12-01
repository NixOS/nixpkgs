let
  tests = {
    wayland = { pkgs, ... }: {
      imports = [ ./common/wayland-cage.nix ];

      services.cage.program = ''
        ${pkgs.vscodium}/bin/codium \
          --enable-features=UseOzonePlatform \
          --ozone-platform=wayland
      '';

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
        start_all()

        machine.wait_for_unit('graphical.target')
        machine.wait_until_succeeds('pgrep -x codium')

        # Wait until vscodium is visible. "File" is in the menu bar.
        machine.wait_for_text('File')
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
        machine.wait_for_text('Save')
        machine.screenshot('save_window')
        machine.send_key('ret')

        # (the default filename is the first line of the file)
        machine.wait_for_file(f'/home/alice/{test_string}')
      '';
    });

in builtins.mapAttrs (k: v: mkTest k v { }) tests
