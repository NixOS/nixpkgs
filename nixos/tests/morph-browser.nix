let
  makeTest = import ./make-test-python.nix;
  generic =
    {
      withQt6,
    }:
    makeTest (
      { pkgs, lib, ... }:
      {
        name = "morph-browser-${if withQt6 then "qt6" else "qt5"}-standalone";
        meta.maintainers = lib.teams.lomiri.members;

        nodes.machine =
          {
            config,
            pkgs,
            ...
          }:
          {
            imports = [
              ./common/x11.nix
            ];

            services.xserver.enable = true;

            environment = {
              systemPackages = with (if withQt6 then pkgs.lomiri-qt6 else pkgs.lomiri); [
                suru-icon-theme
                morph-browser
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

          with subtest("morph browser launches"):
              machine.succeed("morph-browser >&2 &")
              machine.sleep(10)
              machine.send_key("alt-f10")
              machine.sleep(5)
              machine.wait_for_text(r"Web Browser|New|sites|Bookmarks")
              machine.screenshot("morph_open")

          with subtest("morph browser displays HTML"):
              machine.send_chars("file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html\n")
              machine.wait_for_text("Valgrind Documentation")
              machine.screenshot("morph_htmlcontent")

          machine.succeed("pkill -f morph-browser")

          # Get rid of saved tabs, to show localised start page
          machine.succeed("rm -r /root/.local/share/morph-browser")

          with subtest("morph browser localisation works"):
              machine.succeed("env LANG=de_DE.UTF-8 morph-browser >&2 &")
              machine.sleep(10)
              machine.send_key("alt-f10")
              machine.sleep(5)
              machine.wait_for_text(r"Web-Browser|Neuer|Seiten|Lesezeichen")
              machine.screenshot("morph_localised")
        '';
      }
    );
in
{
  qt5 = generic { withQt6 = false; };
  qt6 = generic { withQt6 = true; };
}
