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
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
<<<<<<< HEAD
        machine.wait_for_text(r"(clock.ubports|City|Alarms|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)")
=======
        machine.wait_for_text(r"(clock.ubports|City|Alarms)")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        machine.screenshot("lomiri-clock_open")

    machine.succeed("pkill -f lomiri-clock-app")

    with subtest("lomiri clock localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-clock-app >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
<<<<<<< HEAD
        machine.wait_for_text(r"(Stadt|Weckzeiten|Montag|Dienstag|Mittwoch|Donnerstag|Freitag|Samstag|Sonntag)")
=======
        machine.wait_for_text(r"(Stadt|Weckzeiten)")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        machine.screenshot("lomiri-clock_localised")
  '';
}
