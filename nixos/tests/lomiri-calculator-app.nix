{ pkgs, lib, ... }:
{
  name = "lomiri-calculator-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          lomiri-calculator-app
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

    with subtest("lomiri calculator launches"):
        machine.execute("lomiri-calculator-app >&2 &")
        machine.wait_for_window("Calculator")
        machine.screenshot("lomiri-calculator")

    with subtest("lomiri calculator works"):
        # Seems like on slower hardware, we might find it too quickly now, with the math library not being set up properly yet
        # qml: [LOG]: Unable to calculate formula : "22*16", math.js: TypeError: Cannot call method 'evaluate' of null
        # OfBorg aarch64 CI is *incredibly slow*, hence the long duration
        machine.sleep(60)

        machine.send_key("tab") # Fix focus

        machine.send_chars("22*16\n")
        machine.wait_for_text("352")
        machine.screenshot("lomiri-calculator_caninfactdobasicmath")

    machine.succeed("pkill -f lomiri-calculator-app")

    with subtest("lomiri calculator localisation works"):
        machine.execute("env LANG=de_DE.UTF-8 lomiri-calculator-app >&2 &")
        machine.wait_for_window("Rechner")
        machine.screenshot("lomiri-calculator_localised")

    # History of previous run should have loaded
    with subtest("lomiri calculator history works"):
        machine.wait_for_text("352")
  '';
}
