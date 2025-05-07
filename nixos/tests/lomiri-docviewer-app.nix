{ lib, ... }:
let
  exampleText = "Lorem ipsum dolor sit amet";
in
{
  name = "lomiri-docviewer-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        etc."docviewer-sampletext.txt".text = exampleText;
        systemPackages =
          with pkgs;
          [
            libreoffice # txt -> odf to test LibreOfficeKit integration
          ]
          ++ (with pkgs.lomiri; [
            suru-icon-theme
            lomiri-docviewer-app
          ]);
        variables = {
          UITK_ICON_THEME = "suru";
        };
      };

      i18n.supportedLocales = [ "all" ];

      fonts = {
        packages = with pkgs; [
          # Intended font & helps with OCR
          ubuntu-classic
        ];
      };
    };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()

      with subtest("lomiri docviewer launches"):
          machine.succeed("lomiri-docviewer-app >&2 &")
          machine.wait_for_window("docviewer.ubports")
          machine.sleep(10) # Optimise OCR
          machine.wait_for_text("No documents")
          machine.screenshot("lomiri-docviewer_open")

      machine.succeed("pgrep -afx lomiri-docviewer-app >&2")
      machine.succeed("pkill -efx lomiri-docviewer-app >&2")
      machine.wait_until_fails("pgrep -afx lomiri-docviewer-app >&2")

      # Setup different document types
      machine.succeed("cp /etc/docviewer-sampletext.txt /root/")
      machine.succeed("soffice --convert-to odt --outdir /root/ /etc/docviewer-sampletext.txt")
      machine.succeed("soffice --convert-to pdf --outdir /root/ /etc/docviewer-sampletext.txt")

    ''
    +
      lib.strings.concatMapStringsSep "\n"
        (format: ''
          with subtest("lomiri docviewer ${format} works"):
              machine.succeed("lomiri-docviewer-app /root/docviewer-sampletext.${format} >&2 &")
              machine.wait_for_window("lomiri-docviewer-app")
              machine.sleep(15) # Optimise OCR
              machine.wait_for_text("${exampleText}")
              machine.screenshot("lomiri-docviewer_${format}")

          machine.succeed("pgrep -afx 'lomiri-docviewer-app /root/docviewer-sampletext.${format}' >&2")
          machine.succeed("pkill -efx 'lomiri-docviewer-app /root/docviewer-sampletext.${format}' >&2")
          machine.wait_until_fails("pgrep -afx 'lomiri-docviewer-app /root/docviewer-sampletext.${format}' >&2")
        '')
        [
          "txt"
          "odt"
          "pdf"
        ]
    + ''

      with subtest("lomiri docviewer localisation works"):
          machine.succeed("env LANG=de_DE.UTF-8 lomiri-docviewer-app >&2 &")
          machine.wait_for_window("docviewer.ubports")
          machine.sleep(10) # Optimise OCR
          machine.wait_for_text("Keine Dokumente")
          machine.screenshot("lomiri-docviewer_localised")
    '';
}
