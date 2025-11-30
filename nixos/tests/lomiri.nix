let
  makeTest = import ./make-test-python.nix;
  # Just to make sure everything is the same, need it for OCR & navigating greeter
  user = "alice";
  description = "Alice Foobar";
  password = "foobar";

  wallpaperName = "wallpaper.jpg";
  # In case it ever shows up in the VM, we could OCR for it instead
  wallpaperText = "Lorem ipsum";

  # tmpfiles setup to make OCRing on terminal output more reliable
  terminalOcrTmpfilesSetup =
    {
      pkgs,
      lib,
      config,
    }:
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
      "${confBase}".d = userDirArgs;
      "${confBase}/terminal.ubports".d = userDirArgs;
      "${confBase}/terminal.ubports/customized.colorscheme".L.argument = "${terminalColors}";
      "${confBase}/terminal.ubports/terminal.ubports.conf".L.argument = "${terminalConfig}";
    };

  wallpaperFile =
    pkgs:
    pkgs.runCommand wallpaperName
      {
        nativeBuildInputs = with pkgs; [
          (imagemagick.override { ghostscriptSupport = true; }) # produce OCR-able image
        ];
      }
      ''
        magick -size 640x480 canvas:black -pointsize 30 -fill white -annotate +100+100 '${wallpaperText}' $out
      '';

  lomiriWallpaperDconfSettings = pkgs: {
    settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${wallpaperFile pkgs}";
      };
    };
  };

  sharedTestFunctions = ''
    def wait_for_text(text):
      """
      Wait for on-screen text, and try to optimise retry count for slow hardware.
      """

      machine.sleep(30)
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

      # Move
      machine.execute(f"ydotool mousemove --absolute -- {xpos} {ypos}")
      machine.sleep(2)

      # Click (C0 - left button: down & up)
      machine.execute("ydotool click 0xC0")
      machine.sleep(2)

    def open_starter():
      """
      Open the starter, and ensure it's opened.
      """

      # Using the keybind has a chance of instantly closing the menu again? Just click the button
      mouse_click(15, 15)

  '';

  makeIndicatorTest =
    {
      name,
      left,
      ocr,
      extraCheck ? null,

      titleOcr,
    }:

    makeTest (
      { pkgs, lib, ... }:
      {
        name = "lomiri-desktop-ayatana-indicator-${name}";

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

            # Not setting wallpaper, as it breaks indicator OCR(?)
          };

        enableOCR = true;

        testScript =
          { nodes, ... }:
          sharedTestFunctions
          + ''
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
            mouse_click(735, 0) # the cog in the top-right, for the session indicator
            wait_for_text(${titleOcr})
            machine.screenshot("indicators_open")

            # Indicator order within the menus *should* be fixed based on per-indicator order setting
            # Session is the one we clicked, but it might not be the one we want to test right now.
            # Go as far left as necessary.
            ${lib.strings.replicate left "machine.send_key(\"left\")\n"}

            with subtest("ayatana indicator session works"):
                wait_for_text(r"(${lib.strings.concatStringsSep "|" ocr})")
                machine.screenshot("indicator_${name}")
          ''
          + lib.optionalString (extraCheck != null) extraCheck;
      }
    );

  makeIndicatorTests =
    {
      titles,
      details,
    }:
    let
      titleOcr = "r\"(${builtins.concatStringsSep "|" titles})\"";
    in
    builtins.listToAttrs (
      builtins.map (
        {
          name,
          left,
          ocr,
          extraCheck ? null,
        }:
        {
          name = "desktop-ayatana-indicator-${name}";
          value = makeIndicatorTest {
            inherit
              name
              left
              ocr
              extraCheck
              titleOcr
              ;
          };
        }
      ) details
    );
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

          services.xserver.enable = true;
          services.xserver.windowManager.icewm.enable = true;
          services.xserver.displayManager.lightdm = {
            enable = true;
            greeters.lomiri.enable = true;
          };
          services.displayManager.defaultSession = lib.mkForce "none+icewm";
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        sharedTestFunctions
        + ''
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
              machine.wait_for_x()
              machine.screenshot("session_launched")
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
            etc."xdg/alacritty/alacritty.toml".source = (pkgs.formats.toml { }).generate "alacritty.toml" {
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

            etc."${wallpaperName}".source = wallpaperFile pkgs;

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

          programs.dconf.profiles.user.databases = [
            (lomiriWallpaperDconfSettings pkgs)
          ];

          # Help with OCR
          systemd.tmpfiles.settings = {
            "10-lomiri-test-setup" = terminalOcrTmpfilesSetup { inherit pkgs lib config; };
          };
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        sharedTestFunctions
        + ''
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
          # Qt5 qtwebengine is not secure: https://github.com/NixOS/nixpkgs/pull/435067
          # with subtest("morph browser works"):
          #     open_starter()
          #     machine.send_chars("Morph\n")
          #     wait_for_text(r"(Bookmarks|address|site|visited any)")
          #     machine.screenshot("morph_open")
          #
          #     # morph-browser has a separate VM test to test its basic functionalities
          #
          #     machine.send_key("alt-f4")

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

            etc."${wallpaperName}".source = wallpaperFile pkgs;

            variables = {
              # So we can test what lomiri-content-hub is working behind the scenes
              LOMIRI_CONTENT_HUB_LOGGING_LEVEL = "2";
            };

            systemPackages = with pkgs; [
              # For a convenient way of kicking off lomiri-content-hub peer collection
              lomiri.lomiri-content-hub.examples
            ];
          };

          programs.dconf.profiles.user.databases = [
            (lomiriWallpaperDconfSettings pkgs)
          ];

          # Help with OCR
          systemd.tmpfiles.settings = {
            "10-lomiri-test-setup" = terminalOcrTmpfilesSetup { inherit pkgs lib config; };
          };
        };

      enableOCR = true;

      testScript =
        { nodes, ... }:
        sharedTestFunctions
        + ''
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

              # for the LSS lomiri-content-hub test to work reliably, we need to kick off peer collecting
              machine.send_chars("lomiri-content-hub-test-importer\n")
              wait_for_text(r"(/build/source|hub.cpp|handler.cpp|void|virtual|const)") # awaiting log messages from lomiri-content-hub
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

              # lomiri-system-settings has a separate VM test, only test Lomiri-specific lomiri-content-hub functionalities here

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
              wait_for_text("Gallery")
              machine.screenshot("settings_lomiri-content-hub_peers")

              # Select Gallery as content source
              mouse_click(460, 80)

              # Expect Gallery to be brought into the foreground, with its sharing page open
              wait_for_text("Photos")

              # If lomiri-content-hub encounters a problem, it may have crashed the original application issuing the request.
              # Check that it's still alive
              machine.succeed("pgrep -u ${user} -f lomiri-system-settings")

              machine.screenshot("lomiri-content-hub_exchange")

              # Testing any more would require more applications & setup, the fact that it's already being attempted is a good sign
              machine.send_key("tab")
              machine.send_key("ret")

              machine.sleep(2) # sleep a tiny bit so gallery can close & the focus can return to LSS
              machine.send_key("alt-f4")
        '';
    }
  );

  keymap =
    let
      pwInput = "qwerty";
      pwOutput = "qwertz";
    in
    makeTest (
      { pkgs, lib, ... }:
      {
        name = "lomiri-keymap";

        meta = {
          maintainers = lib.teams.lomiri.members;
        };

        nodes.machine =
          { config, ... }:
          {
            imports = [ ./common/user-account.nix ];

            virtualisation.memorySize = 2047;

            users.users.${user} = {
              inherit description;
              password = lib.mkForce pwOutput;
            };

            services.desktopManager.lomiri.enable = lib.mkForce true;
            services.displayManager.defaultSession = lib.mkForce "lomiri";

            # Help with OCR
            fonts.packages = [ pkgs.inconsolata ];

            services.xserver.xkb.layout = lib.strings.concatStringsSep "," [
              # Start with a non-QWERTY keymap to test keymap patch
              "de"
              # Then a QWERTY one to test switching
              "us"
            ];

            environment.etc."${wallpaperName}".source = wallpaperFile pkgs;

            programs.dconf.profiles.user.databases = [
              (lomiriWallpaperDconfSettings pkgs)
            ];

            # Help with OCR
            systemd.tmpfiles.settings = {
              "10-lomiri-test-setup" = terminalOcrTmpfilesSetup { inherit pkgs lib config; };
            };
          };

        enableOCR = true;

        testScript =
          { nodes, ... }:
          sharedTestFunctions
          + ''
            start_all()
            machine.wait_for_unit("multi-user.target")

            # Lomiri in greeter mode should use the correct keymap
            with subtest("lomiri greeter keymap works"):
                machine.wait_for_unit("display-manager.service")
                machine.wait_until_succeeds("pgrep -u lightdm -f 'lomiri --mode=greeter'")

                # Start page shows current time
                # And the greeter *actually* renders our wallpaper!
                wait_for_text(r"(AM|PM|Lorem|ipsum)")
                machine.screenshot("lomiri_greeter_launched")

                # Advance to login part
                machine.send_key("ret")
                wait_for_text("${description}")
                machine.screenshot("lomiri_greeter_login")

                # Login
                machine.send_chars("${pwInput}\n")
                machine.wait_until_succeeds("pgrep -u ${user} -f 'lomiri --mode=full-shell'")

                # Output rendering from Lomiri has started when it starts printing performance diagnostics
                machine.wait_for_console_text("Last frame took")
                # And the desktop doesn't render the wallpaper anymore. Grumble grumble...
                # Look for datetime's clock, one of the last elements to load
                wait_for_text(r"(AM|PM)")
                machine.screenshot("lomiri_launched")

            # Lomiri in desktop mode should use the correct keymap
            with subtest("lomiri session keymap works"):
                machine.send_key("ctrl-alt-t")
                wait_for_text(r"(${user}|machine)")
                machine.screenshot("terminal_opens")

                machine.send_chars("touch ${pwInput}\n")
                machine.wait_for_file("/home/alice/${pwOutput}", 90)

                # Issues with this keybind: input leaks to focused surface, may open launcher
                # Don't have the keyboard indicator to handle this better
                machine.send_key("meta_l-spc")
                machine.wait_for_console_text('SET KEYMAP "us"')

                # Handle keybind fallout
                machine.sleep(10) # wait for everything to settle
                machine.send_key("esc") # close launcher in case it was opened
                machine.sleep(2) # wait for animation to finish
                # Make sure input leaks are gone
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")
                machine.send_key("backspace")

                machine.send_chars("touch ${pwInput}\n")
                machine.wait_for_file("/home/alice/${pwInput}", 90)

                machine.send_key("alt-f4")
          '';
      }
    );
}
// makeIndicatorTests {
  titles = [
    "Notifications" # messages
    "Rotation" # display
    "Battery" # power
    "Sound" # sound
    "Time" # datetime
    "Date" # datetime
    "System" # session
  ];
  details = [
    # messages normally has no contents
    {
      name = "display";
      left = 6;
      ocr = [ "Lock" ];
    }
    {
      name = "bluetooth";
      left = 5;
      ocr = [ "Bluetooth" ];
    }
    {
      name = "network";
      left = 4;
      ocr = [
        "Flight"
        "Wi-Fi"
      ];
    }
    {
      name = "sound";
      left = 3;
      ocr = [
        "Silent"
        "Volume"
      ];
    }
    {
      name = "power";
      left = 2;
      ocr = [
        "Charge"
        "Battery"
      ];
    }
    {
      name = "datetime";
      left = 1;
      ocr = [
        "Time"
        "Date"
      ];
    }
    {
      name = "session";
      left = 0;
      ocr = [ "Log Out" ];
      extraCheck = ''
        # We should be able to log out and return to the greeter
        mouse_click(600, 250) # "Log Out"
        mouse_click(340, 220) # confirm logout
        machine.wait_until_fails("pgrep -u ${user} -f 'lomiri --mode=full-shell'")
      '';
    }
  ];
}
