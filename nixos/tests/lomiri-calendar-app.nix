{ pkgs, lib, ... }:
{
  name = "lomiri-calendar-app-standalone";
  meta = {
    maintainers = lib.teams.lomiri.members;
    # This needs a Linux VM
    platforms = lib.platforms.linux;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages =
          with pkgs;
          [
            xdotool # mouse movement
          ]
          ++ (with pkgs.lomiri; [
            suru-icon-theme
            lomiri-calendar-app
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
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("lomiri calendar launches"):
        machine.succeed("lomiri-calendar-app >&2 &")
        machine.wait_for_text(r"(January|February|March|April|May|June|July|August|September|October|November|December)")
        machine.screenshot("lomiri-calendar")

    with subtest("lomiri calendar works"):
        # Switch to Agenda tab, less busy
        machine.succeed("xdotool mousemove 300 50 click 1")

        # Still on main page
        machine.succeed("xdotool mousemove 500 650 click 1")
        machine.wait_for_text(r"(Date|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|All day|Name|Details|More)")
        machine.screenshot("lomiri-calendar_newevent")

        # On New Event page
        machine.succeed("xdotool mousemove 500 230 click 1")
        machine.send_chars("foobar")
        machine.sleep(2) # make sure they're actually in there
        machine.succeed("xdotool mousemove 780 40 click 1")
        machine.wait_for_text("Agenda")
        machine.screenshot("lomiri-calendar_eventadded")

        # Back on main page
        # Event was created, does it have the correct name?
        machine.wait_for_text("foobar")
        machine.screenshot("lomiri-calendar_works")

    machine.succeed("pkill -f lomiri-calendar-app")

    with subtest("lomiri calendar localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-calendar-app >&2 &")
        machine.wait_for_text(r"(Montag|Dienstag|Mittwoch|Donnerstag|Freitag|Samstag|Sonntag)")
        machine.screenshot("lomiri-calendar_localised")
  '';
}
