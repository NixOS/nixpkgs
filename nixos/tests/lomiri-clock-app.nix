{ pkgs, lib, ... }:
{
  name = "lomiri-clock-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          lomiri-clock-app
        ];
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

    with subtest("lomiri clock launches"):
        machine.succeed("lomiri-clock-app >&2 &")
        machine.wait_for_window("clock.ubports")
        # Optimise OCR
        # OfBorg aarch64 CI is *incredibly slow*, hence the long duration
        machine.sleep(60)
        machine.wait_for_text(r"(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|City|Alarms)")
        machine.screenshot("lomiri-clock_open")

    machine.succeed("pgrep -afx lomiri-clock-app >&2")
    machine.succeed("pkill -efx lomiri-clock-app >&2")
    machine.wait_until_fails("pgrep -afx lomiri-clock-app >&2")

    with subtest("lomiri clock localisation works"):
        machine.execute("env LANG=de_DE.UTF-8 lomiri-clock-app >&2 &")
        machine.wait_for_window("clock.ubports")
        # Optimise OCR
        # OfBorg aarch64 CI is *incredibly slow*, hence the long duration
        machine.sleep(60)
        machine.wait_for_text(r"(Montag|Dienstag|Mittwoch|Donnerstag|Freitag|Samstag|Sonntag|Stadt|Weckzeiten)")
        machine.screenshot("lomiri-clock_localised")
  '';
}
