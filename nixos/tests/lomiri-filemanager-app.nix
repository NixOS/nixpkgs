{ pkgs, lib, ... }:
{
  name = "lomiri-filemanager-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          lomiri-filemanager-app
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

    with subtest("lomiri filemanager launches"):
        machine.succeed("lomiri-filemanager-app >&2 &")
        machine.wait_for_console_text("QFSFileEngine::open: No file name specified")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(filemanager.ubports|alice|items|directories|files|folder)")
        machine.screenshot("lomiri-filemanager_open")

    machine.succeed("pkill -f lomiri-filemanager-app")

    with subtest("lomiri filemanager localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-filemanager-app >&2 &")
        machine.wait_for_console_text("QFSFileEngine::open: No file name specified")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(Elemente|Verzeichnisse|Dateien|Ordner)")
        machine.screenshot("lomiri-filemanager_localised")
  '';
}
