import ./make-test-python.nix ({ pkgs, lib, ... }: let
  # Just to make sure everything is the same, need it for OCR & navigating greeter
  user = "alice";
  description = "Alice Foobar";
  password = "foobar";
in {
  name = "lomiri";

  meta = {
    maintainers = lib.teams.lomiri.members;
  };

  nodes.machine = { config, ... }: {
    imports = [
      ./common/user-account.nix
    ];

    users.users.${user} = {
      inherit description password;
    };

    # To control mouse via scripting
    programs.ydotool.enable = true;

    services.desktopManager.lomiri.enable = lib.mkForce true;
    services.displayManager.defaultSession = lib.mkForce "lomiri";

    # Help with OCR
    fonts.packages = [ pkgs.inconsolata ];

    environment = {
      # Help with OCR
      etc."xdg/alacritty/alacritty.yml".text = lib.generators.toYAML { } {
        font = rec {
          normal.family = "Inconsolata";
          bold.family = normal.family;
          italic.family = normal.family;
          bold_italic.family = normal.family;
          size = 16;
        };
        colors = rec {
          primary = {
            foreground = "0x000000";
            background = "0xffffff";
          };
          normal = {
            green = primary.foreground;
          };
        };
      };

      variables = {
        # So we can test what content-hub is working behind the scenes
        CONTENT_HUB_LOGGING_LEVEL = "2";
      };

      systemPackages = with pkgs; [
        # For a convenient way of kicking off content-hub peer collection
        lomiri.content-hub.examples

        # Forcing alacritty to run as an X11 app when opened from the starter menu
        (symlinkJoin {
          name = "x11-${alacritty.name}";

          paths = [ alacritty ];

          nativeBuildInputs = [ makeWrapper ];

          postBuild = ''
            wrapProgram $out/bin/alacritty \
              --set WINIT_UNIX_BACKEND x11 \
              --set WAYLAND_DISPLAY ""
          '';

          inherit (alacritty) meta;
        })
      ];
    };

    # Help with OCR
    systemd.tmpfiles.settings = let
      white = "255, 255, 255";
      black = "0, 0, 0";
      colorSection = color: {
        Color = color;
        Bold = true;
        Transparency = false;
      };
      terminalColors = pkgs.writeText "customized.colorscheme" (lib.generators.toINI {} {
        Background = colorSection white;
        Foreground = colorSection black;
        Color2 = colorSection black;
        Color2Intense = colorSection black;
      });
      terminalConfig = pkgs.writeText "terminal.ubports.conf" (lib.generators.toINI {} {
        General = {
          colorScheme = "customized";
          fontSize = "16";
          fontStyle = "Inconsolata";
        };
      });
      confBase = "${config.users.users.${user}.home}/.config";
      userDirArgs = {
        mode = "0700";
        user = user;
        group = "users";
      };
    in {
      "10-lomiri-test-setup" = {
        "${confBase}".d = userDirArgs;
        "${confBase}/terminal.ubports".d = userDirArgs;
        "${confBase}/terminal.ubports/customized.colorscheme".L.argument = "${terminalColors}";
        "${confBase}/terminal.ubports/terminal.ubports.conf".L.argument = "${terminalConfig}";
      };
    };
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    def toggle_maximise():
        """
        Maximise the current window.
        """
        machine.send_key("ctrl-meta_l-up")

        # For some reason, Lomiri in these VM tests very frequently opens the starter menu a few seconds after sending the above.
        # Because this isn't 100% reproducible all the time, and there is no command to await when OCR doesn't pick up some text,
        # the best we can do is send some Escape input after waiting some arbitrary time and hope that it works out fine.
        machine.sleep(5)
        machine.send_key("esc")
        machine.sleep(5)

    def mouse_click(xpos, ypos):
        """
        Move the mouse to a screen location and hit left-click.
        """

        # Need to reset to top-left, --absolute doesn't work?
        machine.execute("ydotool mousemove -- -10000 -10000")
        machine.sleep(2)

        # Move
        machine.execute(f"ydotool mousemove -- {xpos} {ypos}")
        machine.sleep(2)

        # Click (C0 - left button: down & up)
        machine.execute("ydotool click 0xC0")
        machine.sleep(2)

    def open_starter():
        """
        Open the starter, and ensure it's opened.
        """

        # Using the keybind has a chance of instantly closing the menu again? Just click the button
        mouse_click(20, 30)

        # Look for Search box & GUI-less content-hub examples, highest chances of avoiding false positives
        machine.wait_for_text(r"(Search|Export|Import|Share)")

    start_all()
    machine.wait_for_unit("multi-user.target")

    # Lomiri in greeter mode should work & be able to start a session
    with subtest("lomiri greeter works"):
        machine.wait_for_unit("display-manager.service")
        machine.wait_until_succeeds("pgrep -u lightdm -f 'lomiri --mode=greeter'")

        # Start page shows current time
        machine.wait_for_text(r"(AM|PM)")
        machine.screenshot("lomiri_greeter_launched")

        # Advance to login part
        machine.send_key("ret")
        machine.wait_for_text("${description}")
        machine.screenshot("lomiri_greeter_login")

        # Login
        machine.send_chars("${password}\n")
        machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")

    # The session should start, and not be stuck in i.e. a crash loop
    with subtest("lomiri starts"):
        # Output rendering from Lomiri has started when it starts printing performance diagnostics
        machine.wait_for_console_text("Last frame took")
        # Look for datetime's clock, one of the last elements to load
        machine.wait_for_text(r"(AM|PM)")
        machine.screenshot("lomiri_launched")

    # Working terminal keybind is good
    with subtest("terminal keybind works"):
        machine.send_key("ctrl-alt-t")
        machine.wait_for_text(r"(${user}|machine)")
        machine.screenshot("terminal_opens")

        # lomiri-terminal-app has a separate VM test to test its basic functionality

        # for the LSS content-hub test to work reliably, we need to kick off peer collecting
        machine.send_chars("content-hub-test-importer\n")
        machine.wait_for_text(r"(/build/source|hub.cpp|handler.cpp|void|virtual|const)") # awaiting log messages from content-hub
        machine.send_key("ctrl-c")

        machine.send_key("alt-f4")

    # We want the ability to launch applications
    with subtest("starter menu works"):
        open_starter()
        machine.screenshot("starter_opens")

        # Just try the terminal again, we know that it should work
        machine.send_chars("Terminal\n")
        machine.wait_for_text(r"(${user}|machine)")
        machine.send_key("alt-f4")

    # We want support for X11 apps
    with subtest("xwayland support works"):
        open_starter()
        machine.send_chars("Alacritty\n")
        machine.wait_for_text(r"(${user}|machine)")
        machine.screenshot("alacritty_opens")
        machine.send_key("alt-f4")

    # Morph is how we go online
    with subtest("morph browser works"):
        open_starter()
        machine.send_chars("Morph\n")
        machine.wait_for_text(r"(Bookmarks|address|site|visited any)")
        machine.screenshot("morph_open")

        # morph-browser has a separate VM test, there isn't anything new we could test here

        # Keep it running, we're using it to check content-hub communication from LSS

    # LSS provides DE settings
    with subtest("system settings open"):
        open_starter()
        machine.send_chars("System Settings\n")
        machine.wait_for_text("Rotation Lock")
        machine.screenshot("settings_open")

        # lomiri-system-settings has a separate VM test, only test Lomiri-specific content-hub functionalities here

        # Make fullscreen, can't navigate to Background plugin via keyboard unless window has non-phone-like aspect ratio
        toggle_maximise()

        # Load Background plugin
        machine.send_key("tab")
        machine.send_key("tab")
        machine.send_key("tab")
        machine.send_key("tab")
        machine.send_key("tab")
        machine.send_key("tab")
        machine.send_key("ret")
        machine.wait_for_text("Background image")

        # Try to load custom background
        machine.send_key("shift-tab")
        machine.send_key("shift-tab")
        machine.send_key("shift-tab")
        machine.send_key("shift-tab")
        machine.send_key("shift-tab")
        machine.send_key("shift-tab")
        machine.send_key("ret")

        # Peers should be loaded
        machine.wait_for_text("Morph") # or Gallery, but Morph is already packaged
        machine.screenshot("settings_content-hub_peers")

        # Select Morph as content source
        mouse_click(300, 100)

        # Expect Morph to be brought into the foreground, with its Downloads page open
        machine.wait_for_text("No downloads")

        # If content-hub encounters a problem, it may have crashed the original application issuing the request.
        # Check that it's still alive
        machine.succeed("pgrep -u ${user} -f lomiri-system-settings")

        machine.screenshot("content-hub_exchange")

        # Testing any more would require more applications & setup, the fact that it's already being attempted is a good sign
        machine.send_key("esc")

        machine.send_key("alt-f4") # LSS
        machine.sleep(2) # focus is slow to switch to second window, closing it *really* helps with OCR afterwards
        machine.send_key("alt-f4") # Morph

    # The ayatana indicators are an important part of the experience, and they hold the only graphical way of exiting the session.
    # There's a test app we could use that also displays their contents, but it's abit inconsistent.
    with subtest("ayatana indicators work"):
        mouse_click(735, 0) # the cog in the top-right, for the session indicator
        machine.wait_for_text(r"(Notifications|Rotation|Battery|Sound|Time|Date|System)")
        machine.screenshot("indicators_open")

        # Indicator order within the menus *should* be fixed based on per-indicator order setting
        # Session is the one we clicked, but the last we should test (logout). Go as far left as we can test.
        machine.send_key("left")
        machine.send_key("left")
        machine.send_key("left")
        machine.send_key("left")
        machine.send_key("left")
        # Notifications are usually empty, nothing to check there

        with subtest("ayatana indicator display works"):
            # We start on this, don't go right
            machine.wait_for_text("Lock")
            machine.screenshot("indicators_display")

        with subtest("lomiri indicator network works"):
            machine.send_key("right")
            machine.wait_for_text(r"(Flight|Wi-Fi)")
            machine.screenshot("indicators_network")

        with subtest("ayatana indicator sound works"):
            machine.send_key("right")
            machine.wait_for_text(r"(Silent|Volume)")
            machine.screenshot("indicators_sound")

        with subtest("ayatana indicator power works"):
            machine.send_key("right")
            machine.wait_for_text(r"(Charge|Battery settings)")
            machine.screenshot("indicators_power")

        with subtest("ayatana indicator datetime works"):
            machine.send_key("right")
            machine.wait_for_text("Time and Date Settings")
            machine.screenshot("indicators_timedate")

        with subtest("ayatana indicator session works"):
            machine.send_key("right")
            machine.wait_for_text("Log Out")
            machine.screenshot("indicators_session")

            # We should be able to log out and return to the greeter
            mouse_click(720, 280) # "Log Out"
            mouse_click(400, 240) # confirm logout
            machine.wait_until_fails("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
            machine.wait_until_succeeds("pgrep -u lightdm -f 'lomiri --mode=greeter'")
  '';
})
