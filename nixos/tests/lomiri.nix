let
  makeTest = import ./make-test-python.nix;
  # Just to make sure everything is the same, need it for OCR & navigating greeter
  user = "alice";
  description = "Alice Foobar";
  password = "foobar";
in
{
  greeter = makeTest (
    { pkgs, lib, ... }:
    {
      name = "lomiri-greeter";

      meta = {
        maintainers = lib.teams.lomiri.members;
      };

      nodes.machine =
        { config, ... }:
        {
          imports = [ ./common/user-account.nix ];

          virtualisation.memorySize = 2047;

          users.users.${user} = {
            inherit description password;
          };

          services.desktopManager.lomiri.enable = lib.mkForce true;
          services.displayManager.defaultSession = lib.mkForce "lomiri";

          # Help with OCR
          fonts.packages = [ pkgs.inconsolata ];
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        ''
          def wait_for_text(text):
              """
              Wait for on-screen text, and try to optimise retry count for slow hardware.
              """
              machine.sleep(10)
              machine.wait_for_text(text)

          start_all()
          machine.wait_for_unit("multi-user.target")

          # Lomiri in greeter mode should work & be able to start a session
          with subtest("lomiri greeter works"):
              machine.wait_for_unit("display-manager.service")
              machine.wait_until_succeeds("pgrep -u lightdm -f 'lomiri --mode=greeter'")

              # Start page shows current time
              wait_for_text(r"(AM|PM)")
              machine.screenshot("lomiri_greeter_launched")

              # Advance to login part
              machine.send_key("ret")
              wait_for_text("${description}")
              machine.screenshot("lomiri_greeter_login")

              # Login
              machine.send_chars("${password}\n")
              machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")

              # Output rendering from Lomiri has started when it starts printing performance diagnostics
              machine.wait_for_console_text("Last frame took")
              # Look for datetime's clock, one of the last elements to load
              wait_for_text(r"(AM|PM)")
              machine.screenshot("lomiri_launched")
        '';
    }
  );

  desktop-basics = makeTest (
    { pkgs, lib, ... }:
    {
      name = "lomiri-desktop-basics";

      meta = {
        maintainers = lib.teams.lomiri.members;
      };

      nodes.machine =
        { config, ... }:
        {
          imports = [
            ./common/auto.nix
            ./common/user-account.nix
          ];

          virtualisation.memorySize = 2047;

          users.users.${user} = {
            inherit description password;
          };

          test-support.displayManager.auto = {
            enable = true;
            inherit user;
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

            systemPackages = with pkgs; [
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
          systemd.tmpfiles.settings =
            let
              white = "255, 255, 255";
              black = "0, 0, 0";
              colorSection = color: {
                Color = color;
                Bold = true;
                Transparency = false;
              };
              terminalColors = pkgs.writeText "customized.colorscheme" (
                lib.generators.toINI { } {
                  Background = colorSection white;
                  Foreground = colorSection black;
                  Color2 = colorSection black;
                  Color2Intense = colorSection black;
                }
              );
              terminalConfig = pkgs.writeText "terminal.ubports.conf" (
                lib.generators.toINI { } {
                  General = {
                    colorScheme = "customized";
                    fontSize = "16";
                    fontStyle = "Inconsolata";
                  };
                }
              );
              confBase = "${config.users.users.${user}.home}/.config";
              userDirArgs = {
                mode = "0700";
                user = user;
                group = "users";
              };
            in
            {
              "10-lomiri-test-setup" = {
                "${confBase}".d = userDirArgs;
                "${confBase}/terminal.ubports".d = userDirArgs;
                "${confBase}/terminal.ubports/customized.colorscheme".L.argument = "${terminalColors}";
                "${confBase}/terminal.ubports/terminal.ubports.conf".L.argument = "${terminalConfig}";
              };
            };
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        ''
          def wait_for_text(text):
              """
              Wait for on-screen text, and try to optimise retry count for slow hardware.
              """
              machine.sleep(10)
              machine.wait_for_text(text)

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

          start_all()
          machine.wait_for_unit("multi-user.target")

          # The session should start, and not be stuck in i.e. a crash loop
          with subtest("lomiri starts"):
              machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
              # Output rendering from Lomiri has started when it starts printing performance diagnostics
              machine.wait_for_console_text("Last frame took")
              # Look for datetime's clock, one of the last elements to load
              wait_for_text(r"(AM|PM)")
              machine.screenshot("lomiri_launched")

          # Working terminal keybind is good
          with subtest("terminal keybind works"):
              machine.send_key("ctrl-alt-t")
              wait_for_text(r"(${user}|machine)")
              machine.screenshot("terminal_opens")

              # lomiri-terminal-app has a separate VM test to test its basic functionality

              machine.send_key("alt-f4")

          # We want the ability to launch applications
          with subtest("starter menu works"):
              open_starter()
              machine.screenshot("starter_opens")

              # Just try the terminal again, we know that it should work
              machine.send_chars("Terminal\n")
              wait_for_text(r"(${user}|machine)")
              machine.send_key("alt-f4")

          # We want support for X11 apps
          with subtest("xwayland support works"):
              open_starter()
              machine.send_chars("Alacritty\n")
              wait_for_text(r"(${user}|machine)")
              machine.screenshot("alacritty_opens")
              machine.send_key("alt-f4")

          # Morph is how we go online
          with subtest("morph browser works"):
              open_starter()
              machine.send_chars("Morph\n")
              wait_for_text(r"(Bookmarks|address|site|visited any)")
              machine.screenshot("morph_open")

              # morph-browser has a separate VM test to test its basic functionalities

              machine.send_key("alt-f4")

          # LSS provides DE settings
          with subtest("system settings open"):
              open_starter()
              machine.send_chars("System Settings\n")
              wait_for_text("Rotation Lock")
              machine.screenshot("settings_open")

              # lomiri-system-settings has a separate VM test to test its basic functionalities

              machine.send_key("alt-f4")
        '';
    }
  );

  desktop-appinteractions = makeTest (
    { pkgs, lib, ... }:
    {
      name = "lomiri-desktop-appinteractions";

      meta = {
        maintainers = lib.teams.lomiri.members;
      };

      nodes.machine =
        { config, ... }:
        {
          imports = [
            ./common/auto.nix
            ./common/user-account.nix
          ];

          virtualisation.memorySize = 2047;

          users.users.${user} = {
            inherit description password;
            # polkit agent test
            extraGroups = [ "wheel" ];
          };

          test-support.displayManager.auto = {
            enable = true;
            inherit user;
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
            ];
          };

          # Help with OCR
          systemd.tmpfiles.settings =
            let
              white = "255, 255, 255";
              black = "0, 0, 0";
              colorSection = color: {
                Color = color;
                Bold = true;
                Transparency = false;
              };
              terminalColors = pkgs.writeText "customized.colorscheme" (
                lib.generators.toINI { } {
                  Background = colorSection white;
                  Foreground = colorSection black;
                  Color2 = colorSection black;
                  Color2Intense = colorSection black;
                }
              );
              terminalConfig = pkgs.writeText "terminal.ubports.conf" (
                lib.generators.toINI { } {
                  General = {
                    colorScheme = "customized";
                    fontSize = "16";
                    fontStyle = "Inconsolata";
                  };
                }
              );
              confBase = "${config.users.users.${user}.home}/.config";
              userDirArgs = {
                mode = "0700";
                user = user;
                group = "users";
              };
            in
            {
              "10-lomiri-test-setup" = {
                "${confBase}".d = userDirArgs;
                "${confBase}/terminal.ubports".d = userDirArgs;
                "${confBase}/terminal.ubports/customized.colorscheme".L.argument = "${terminalColors}";
                "${confBase}/terminal.ubports/terminal.ubports.conf".L.argument = "${terminalConfig}";
              };
            };
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        ''
          def wait_for_text(text):
              """
              Wait for on-screen text, and try to optimise retry count for slow hardware.
              """
              machine.sleep(10)
              machine.wait_for_text(text)

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

          start_all()
          machine.wait_for_unit("multi-user.target")

          # The session should start, and not be stuck in i.e. a crash loop
          with subtest("lomiri starts"):
              machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
              # Output rendering from Lomiri has started when it starts printing performance diagnostics
              machine.wait_for_console_text("Last frame took")
              # Look for datetime's clock, one of the last elements to load
              wait_for_text(r"(AM|PM)")
              machine.screenshot("lomiri_launched")

          # Working terminal keybind is good
          with subtest("terminal keybind works"):
              machine.send_key("ctrl-alt-t")
              wait_for_text(r"(${user}|machine)")
              machine.screenshot("terminal_opens")

              # lomiri-terminal-app has a separate VM test to test its basic functionality

              # for the LSS content-hub test to work reliably, we need to kick off peer collecting
              machine.send_chars("content-hub-test-importer\n")
              wait_for_text(r"(/build/source|hub.cpp|handler.cpp|void|virtual|const)") # awaiting log messages from content-hub
              machine.send_key("ctrl-c")

              # Doing this here, since we need an in-session shell & separately starting a terminal again wastes time
              with subtest("polkit agent works"):
                  machine.send_chars("pkexec touch /tmp/polkit-test\n")
                  # There's an authentication notification here that gains focus, but we struggle with OCRing it
                  # Just hope that it's up after a short wait
                  machine.sleep(10)
                  machine.screenshot("polkit_agent")
                  machine.send_chars("${password}")
                  machine.sleep(2) # Hopefully enough delay to make sure all the password characters have been registered? Maybe just placebo
                  machine.send_chars("\n")
                  machine.wait_for_file("/tmp/polkit-test", 10)

              machine.send_key("alt-f4")

          # LSS provides DE settings
          with subtest("system settings open"):
              open_starter()
              machine.send_chars("System Settings\n")
              wait_for_text("Rotation Lock")
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
              wait_for_text("Background image")

              # Try to load custom background
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("ret")

              # Peers should be loaded
              wait_for_text("Morph") # or Gallery, but Morph is already packaged
              machine.screenshot("settings_content-hub_peers")

              # Select Morph as content source
              mouse_click(370, 100)

              # Expect Morph to be brought into the foreground, with its Downloads page open
              wait_for_text("No downloads")

              # If content-hub encounters a problem, it may have crashed the original application issuing the request.
              # Check that it's still alive
              machine.succeed("pgrep -u ${user} -f lomiri-system-settings")

              machine.screenshot("content-hub_exchange")

              # Testing any more would require more applications & setup, the fact that it's already being attempted is a good sign
              machine.send_key("esc")

              machine.sleep(2) # sleep a tiny bit so morph can close & the focus can return to LSS
              machine.send_key("alt-f4")
        '';
    }
  );

  desktop-ayatana-indicators = makeTest (
    { pkgs, lib, ... }:
    {
      name = "lomiri-desktop-ayatana-indicators";

      meta = {
        maintainers = lib.teams.lomiri.members;
      };

      nodes.machine =
        { config, ... }:
        {
          imports = [
            ./common/auto.nix
            ./common/user-account.nix
          ];

          virtualisation.memorySize = 2047;

          users.users.${user} = {
            inherit description password;
          };

          test-support.displayManager.auto = {
            enable = true;
            inherit user;
          };

          # To control mouse via scripting
          programs.ydotool.enable = true;

          services.desktopManager.lomiri.enable = lib.mkForce true;
          services.displayManager.defaultSession = lib.mkForce "lomiri";

          # Help with OCR
          fonts.packages = [ pkgs.inconsolata ];

          environment.systemPackages = with pkgs; [ qt5.qttools ];
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        ''
          def wait_for_text(text):
              """
              Wait for on-screen text, and try to optimise retry count for slow hardware.
              """
              machine.sleep(10)
              machine.wait_for_text(text)

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

          start_all()
          machine.wait_for_unit("multi-user.target")

          # The session should start, and not be stuck in i.e. a crash loop
          with subtest("lomiri starts"):
              machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
              # Output rendering from Lomiri has started when it starts printing performance diagnostics
              machine.wait_for_console_text("Last frame took")
              # Look for datetime's clock, one of the last elements to load
              wait_for_text(r"(AM|PM)")
              machine.screenshot("lomiri_launched")

          # The ayatana indicators are an important part of the experience, and they hold the only graphical way of exiting the session.
          # There's a test app we could use that also displays their contents, but it's abit inconsistent.
          with subtest("ayatana indicators work"):
              mouse_click(735, 0) # the cog in the top-right, for the session indicator
              wait_for_text(r"(Notifications|Rotation|Battery|Sound|Time|Date|System)")
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
                  wait_for_text("Lock")
                  machine.screenshot("indicators_display")

              with subtest("lomiri indicator network works"):
                  machine.send_key("right")
                  wait_for_text(r"(Flight|Wi-Fi)")
                  machine.screenshot("indicators_network")

              with subtest("ayatana indicator sound works"):
                  machine.send_key("right")
                  wait_for_text(r"(Silent|Volume)")
                  machine.screenshot("indicators_sound")

              with subtest("ayatana indicator power works"):
                  machine.send_key("right")
                  wait_for_text(r"(Charge|Battery settings)")
                  machine.screenshot("indicators_power")

              with subtest("ayatana indicator datetime works"):
                  machine.send_key("right")
                  wait_for_text("Time and Date Settings")
                  machine.screenshot("indicators_timedate")

              with subtest("ayatana indicator session works"):
                  machine.send_key("right")
                  wait_for_text("Log Out")
                  machine.screenshot("indicators_session")

                  # We should be able to log out and return to the greeter
                  mouse_click(720, 280) # "Log Out"
                  mouse_click(400, 240) # confirm logout
                  machine.wait_until_fails("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
        '';
    }
  );

}
