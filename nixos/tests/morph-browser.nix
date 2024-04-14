import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "morph-browser-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;

    environment = {
      systemPackages = with pkgs.lomiri; [
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
      ubuntu_font_family
    ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()

      with subtest("morph browser launches"):
          machine.execute("morph-browser >&2 &")
          machine.wait_for_text(r"Web Browser|New|sites|Bookmarks")
          machine.screenshot("morph_open")

      with subtest("morph browser displays HTML"):
          machine.send_chars("file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html\n")
          machine.wait_for_text("Valgrind Documentation")
          machine.screenshot("morph_htmlcontent")

      machine.succeed("pkill -f morph-browser")

      with subtest("morph browser localisation works"):
          machine.execute("env LANG=de_DE.UTF-8 morph-browser >&2 &")
          machine.wait_for_text(r"Web-Browser|Neuer|Seiten|Lesezeichen")
          machine.screenshot("morph_localised")
    '';
})
