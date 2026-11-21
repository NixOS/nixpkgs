{ pkgs, lib, ... }:
{
  name = "lomiri-printing-app-standalone";
  meta.teams = [ lib.teams.lomiri ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          lomiri-printing-app
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

    with subtest("lomiri printing app"):
        with subtest("printing app works"):
            machine.succeed("lomiri-printing-app >&2 &")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text(r"(document|print|printing|PDF)")
            machine.screenshot("lomiri-printing-app_open")

        machine.succeed("pgrep -afx lomiri-printing-app >&2")
        machine.succeed("pkill -efx lomiri-printing-app >&2")
        machine.wait_until_fails("pgrep -afx lomiri-printing-app >&2")

        with subtest("printing app localisation works"):
            machine.succeed("env LANG=de_DE.UTF-8 lomiri-printing-app >&2 &")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text(r"(Dokument|Druck|drucken|Drucken)")
            machine.screenshot("lomiri-printing-app_localised")

    machine.succeed("pgrep -afx lomiri-printing-app >&2")
    machine.succeed("pkill -efx lomiri-printing-app >&2")
    machine.wait_until_fails("pgrep -afx lomiri-printing-app >&2")

    with subtest("lomiri printqueue dialog"):
        with subtest("print queue viewer works"):
            machine.succeed("lomiri-printqueue-dialog >&2 &")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text("jobs")
            machine.screenshot("lomiri-printqueue-dialog_open")

        machine.succeed("pgrep -afx lomiri-printqueue-dialog >&2")
        machine.succeed("pkill -efx lomiri-printqueue-dialog >&2")
        machine.wait_until_fails("pgrep -afx lomiri-printqueue-dialog >&2")

        with subtest("print queue viewer localisation works"):
            # OCR struggles with finding the German compound word :)
            machine.succeed("env LANG=it_IT.UTF-8 lomiri-printqueue-dialog >&2 &")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text("lavoro") # "(print) job"
            machine.screenshot("lomiri-printqueue-dialog_localised")
  '';
}
