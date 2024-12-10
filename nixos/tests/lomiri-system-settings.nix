import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "lomiri-system-settings-standalone";
    meta.maintainers = lib.teams.lomiri.members;

    nodes.machine =
      { config, pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
        ];

        services.xserver.enable = true;

        environment = {
          systemPackages = with pkgs.lomiri; [
            suru-icon-theme
            lomiri-system-settings
          ];
          variables = {
            UITK_ICON_THEME = "suru";
          };
        };

        i18n.supportedLocales = [ "all" ];

        fonts.packages = with pkgs; [
          # Intended font & helps with OCR
          ubuntu_font_family
        ];

        services.upower.enable = true;
      };

    enableOCR = true;

    testScript =
      let
        settingsPages = [
          # Base pages
          {
            name = "wifi";
            type = "internal";
            element = "networks";
          }
          {
            name = "bluetooth";
            type = "internal";
            element = "discoverable|None detected";
          }
          # only text we can really look for with VPN is on a button, OCR on CI struggles with it
          {
            name = "vpn";
            type = "internal";
            element = "Add|Manual|Configuration";
            skipOCR = true;
          }
          {
            name = "appearance";
            type = "internal";
            element = "Background image|blur effects";
          }
          {
            name = "desktop";
            type = "internal";
            element = "workspaces|Icon size";
          }
          {
            name = "sound";
            type = "internal";
            element = "Silent Mode|Message sound";
          }
          {
            name = "language";
            type = "internal";
            element = "Display language|External keyboard";
          }
          {
            name = "notification";
            type = "internal";
            element = "Apps that notify";
          }
          {
            name = "gestures";
            type = "internal";
            element = "Edge drag";
          }
          {
            name = "mouse";
            type = "internal";
            element = "Cursor speed|Wheel scrolling speed";
          }
          {
            name = "timedate";
            type = "internal";
            element = "Time zone|Set the time and date";
          }

          # External plugins
          {
            name = "security-privacy";
            type = "external";
            element = "Locking|unlocking|permissions";
            elementLocalised = "Sperren|Entsperren|Berechtigungen";
          }
        ];
      in
      ''
        machine.wait_for_x()

        with subtest("lomiri system settings launches"):
            machine.execute("lomiri-system-settings >&2 &")
            machine.wait_for_text("System Settings")
            machine.screenshot("lss_open")

        # Move focus to start of plugins list for following list of tests
        machine.send_key("tab")
        machine.send_key("tab")
        machine.screenshot("lss_focus")

        # tab through & open all sub-menus, to make sure none of them fail
      ''
      + (lib.strings.concatMapStringsSep "\n" (
        page:
        ''
          machine.send_key("tab")
          machine.send_key("kp_enter")
        ''
        + lib.optionalString (!(page.skipOCR or false)) ''
          with subtest("lomiri system settings ${page.name} works"):
              machine.wait_for_text(r"(${page.element})")
              machine.screenshot("lss_page_${page.name}")
        ''
      ) settingsPages)
      + ''

        machine.execute("pkill -f lomiri-system-settings")

        with subtest("lomiri system settings localisation works"):
            machine.execute("env LANG=de_DE.UTF-8 lomiri-system-settings >&2 &")
            machine.wait_for_text("Systemeinstellungen")
            machine.screenshot("lss_localised_open")

        # Move focus to start of plugins list for following list of tests
        machine.send_key("tab")
        machine.send_key("tab")
        machine.screenshot("lss_focus_localised")

      ''
      + (lib.strings.concatMapStringsSep "\n" (
        page:
        ''
          machine.send_key("tab")
          machine.send_key("kp_enter")
        ''
        + lib.optionalString (page.type == "external") ''
          with subtest("lomiri system settings ${page.name} localisation works"):
              machine.wait_for_text(r"(${page.elementLocalised})")
              machine.screenshot("lss_localised_page_${page.name}")
        ''
      ) settingsPages)
      + '''';
  }
)
