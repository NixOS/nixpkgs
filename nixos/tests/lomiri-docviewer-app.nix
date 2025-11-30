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

  testScript = ''
    machine.wait_for_x()

    with subtest("lomiri docviewer launches"):
        machine.succeed("lomiri-docviewer-app >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("No documents")
        machine.screenshot("lomiri-docviewer_open")

    machine.succeed("pkill -f lomiri-docviewer-app")

    # Setup different document types
    machine.succeed("soffice --convert-to odt --outdir /root/ /etc/docviewer-sampletext.txt")
    machine.succeed("soffice --convert-to pdf --outdir /root/ /etc/docviewer-sampletext.txt")

    with subtest("lomiri docviewer txt works"):
        machine.succeed("lomiri-docviewer-app /etc/docviewer-sampletext.txt >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("${exampleText}")
        machine.screenshot("lomiri-docviewer_txt")

    machine.succeed("pkill -f lomiri-docviewer-app")

    with subtest("lomiri docviewer odt works"):
        machine.succeed("lomiri-docviewer-app /root/docviewer-sampletext.odt >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("${exampleText}")
        machine.screenshot("lomiri-docviewer_odt")

    machine.succeed("pkill -f lomiri-docviewer-app")

    with subtest("lomiri docviewer pdf works"):
        machine.succeed("lomiri-docviewer-app /root/docviewer-sampletext.pdf >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("${exampleText}")
        machine.screenshot("lomiri-docviewer_pdf")

    machine.succeed("pkill -f lomiri-docviewer-app")

    with subtest("lomiri docviewer localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-docviewer-app >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("Keine Dokumente")
        machine.screenshot("lomiri-docviewer_localised")
  '';
}
