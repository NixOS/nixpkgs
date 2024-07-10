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
        ubuntu_font_family
      ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("lomiri clock launches"):
        machine.execute("lomiri-clock-app >&2 &")
        machine.wait_for_text(r"(clock.ubports|City|Alarms)")
        machine.screenshot("lomiri-clock_open")

    machine.succeed("pkill -f lomiri-clock-app")

    with subtest("lomiri clock localisation works"):
        machine.execute("env LANG=de_DE.UTF-8 lomiri-clock-app >&2 &")
        machine.wait_for_text(r"(Stadt|Weckzeiten)")
        machine.screenshot("lomiri-clock_localised")
  '';
}
