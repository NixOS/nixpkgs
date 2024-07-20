{ pkgs, lib, ... }:
{
  name = "teleports-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          teleports
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

    with subtest("teleports launches"):
        machine.execute("teleports >&2 &")
        machine.wait_for_text(r"(TELEports|Phone Number)")
        machine.screenshot("teleports_open")

    machine.succeed("pkill -f teleports")

    with subtest("teleports localisation works"):
        machine.execute("env LANG=de_DE.UTF-8 teleports >&2 &")
        machine.wait_for_text("Telefonnummer")
        machine.screenshot("teleports_localised")
  '';
}
