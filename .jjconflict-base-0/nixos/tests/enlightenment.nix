import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "enlightenment";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ romildo ];
      timeout = 600;
      # OCR tests are flaky
      broken = true;
    };

    nodes.machine =
      { ... }:
      {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.desktopManager.enlightenment.enable = true;
        services.xserver.displayManager = {
          lightdm.enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        environment.systemPackages = [ pkgs.xdotool ];
        services.acpid.enable = true;
        services.connman.enable = true;
        services.connman.package = pkgs.connmanMinimal;
      };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.config.users.users.alice;
      in
      ''
        with subtest("Ensure x starts"):
            machine.wait_for_x()
            machine.wait_for_file("${user.home}/.Xauthority")
            machine.succeed("xauth merge ${user.home}/.Xauthority")

        with subtest("Check that logging in has given the user ownership of devices"):
            machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

        with subtest("First time wizard"):
            machine.wait_for_text("Default")  # Language
            machine.screenshot("wizard1")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next
            machine.screenshot("wizard2")

            machine.wait_for_text("English")  # Keyboard (default)
            machine.screenshot("wizard3")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("Standard")  # Profile (default)
            machine.screenshot("wizard4")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("Title")  # Sizing (default)
            machine.screenshot("wizard5")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("clicked")  # Windows Focus
            machine.succeed("xdotool mousemove 512 370 click 1")  # Click
            machine.screenshot("wizard6")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("Connman")  # Network Management (default)
            machine.screenshot("wizard7")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("BlusZ")  # Bluetooth Management (default)
            machine.screenshot("wizard8")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("OpenGL")  # Compositing (default)
            machine.screenshot("wizard9")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("update")  # Updates
            machine.succeed("xdotool mousemove 512 495 click 1")  # Disable
            machine.screenshot("wizard10")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("taskbar")  # Taskbar
            machine.succeed("xdotool mousemove 480 410 click 1")  # Enable
            machine.screenshot("wizard11")
            machine.succeed("xdotool mousemove 512 740 click 1")  # Next

            machine.wait_for_text("Home")  # The desktop
            machine.screenshot("wizard12")

        with subtest("Run Terminology"):
            machine.succeed("terminology >&2 &")
            machine.sleep(5)
            machine.send_chars("ls --color -alF\n")
            machine.sleep(2)
            machine.screenshot("terminology")
      '';
  }
)
