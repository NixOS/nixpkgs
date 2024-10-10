import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "lomiri-system-settings-standalone";
    meta.maintainers = lib.teams.lomiri.members;

    nodes.machine =
      { config, pkgs, ... }:
      {
        imports = [ ./common/x11.nix ];

        services.xserver.enable = true;

        environment = {
          systemPackages =
            with pkgs.lomiri;
            [
              suru-icon-theme
              lomiri-system-settings

              # To test localisation of lomiri-online-accounts-plugins' QML plugin within LSS
              lomiri-online-accounts-plugins
            ]
            ++ (with pkgs; [

              # Mouse control
              xdotool
            ]);
          variables = {
            UITK_ICON_THEME = "suru";
          };
        };

        i18n.supportedLocales = [ "all" ];

        fonts.packages = with pkgs; [
          # Intended font & helps with OCR
          ubuntu-classic
        ];

        services.upower.enable = true;
      };

    enableOCR = true;

    testScript =
      let
        settingsPages = [
          {
            name = "wifi";
            element = "networks";
            elementLocalised = "Netzwerke";
          }
          {
            name = "bluetooth";
            element = "discoverable|None detected";
            elementLocalised = "feststellbar|Keines gefunden";
          }
          {
            name = "vpn";
            element = "Add|Manual|Configuration";
            # only text we can really look for with VPN is on a button, OCR on CI struggles with it
            skipOCR = true;
          }
          {
            name = "appearance";
            element = "Background image|blur effects";
            elementLocalised = "Hintergrundbild|Unschärfeeffekte";
          }
          {
            name = "desktop";
            element = "workspaces|Icon size";
            # different elements/strings, OCR struggles with diacritics & ß
            elementLocalised = "aktivieren|Starter immer";
          }
          {
            name = "sound";
            element = "Silent Mode|Message sound";
            elementLocalised = "Stiller Modus|Nachrichtenton";
          }
          {
            name = "language";
            element = "Display language|External keyboard";
            elementLocalised = "Anzeigesprache|Externe Tastatur";
          }

          # localised checks for created account, not same element
          {
            name = "online-accounts";
            element = "No accounts";
            elementLocalised = "Google";
            # Check that LOA within LSSOA is localised
            extraLocalised = ''
              machine.succeed("xdotool mousemove 512 102 click 1")
              machine.wait_for_text("Kennung")
              machine.screenshot("lss_localised_page_online-accounts-plugin")

              # Return focus
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
              machine.send_key("shift-tab")
            '';
          }

          {
            name = "notification";
            element = "Apps that notify";
            elementLocalised = "Apps mit";
          }
          {
            name = "gestures";
            element = "Edge drag";
            # Struggling with that word, let's pick some from a description
            elementLocalised = "Kanten|Wischbereich";
          }
          {
            name = "mouse";
            element = "Cursor speed|Wheel scrolling speed";
            elementLocalised = "Zeigergeschwindigkeit|Mausradgeschwindigkeit";
          }
          {
            name = "timedate";
            element = "Time zone|Set the time and date";
            elementLocalised = "Zeitzone|Uhrzeit und Datum einstellen";
          }

          {
            name = "security-privacy";
            element = "Locking|unlocking|permissions";
            elementLocalised = "Sperren|Entsperren|Berechtigungen";
          }
        ];
      in
      ''
        machine.wait_for_x()

        with subtest("lomiri system settings launches"):
            machine.succeed("lomiri-system-settings >&2 &")
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

        machine.succeed("pkill -f lomiri-system-settings")

        # Preperation for checking i18n of lomiri-online-accounts, within LSS-online-accounts
        machine.succeed("lomiri-account-console create google")

        with subtest("lomiri system settings localisation works"):
            # XDG_CURRENT_DESKTOP so online-accounts plugins get loaded
            machine.succeed("env LANG=de_DE.UTF-8 XDG_CURRENT_DESKTOP=Lomiri lomiri-system-settings >&2 &")
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
        + lib.optionalString (!(page.skipOCR or false)) (
          ''
            with subtest("lomiri system settings ${page.name} localisation works"):
                machine.wait_for_text(r"(${page.elementLocalised})")
                machine.screenshot("lss_localised_page_${page.name}")
          ''
          + lib.optionalString (page ? extraLocalised) page.extraLocalised
        )
      ) settingsPages);
  }
)
