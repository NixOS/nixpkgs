import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "yabar";
    meta.maintainers = [ ];

    nodes.machine = {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];

      test-support.displayManager.auto.user = "bob";

      programs.yabar.enable = true;
      programs.yabar.bars = {
        top.indicators.date.exec = "YABAR_DATE";
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_x()

      # confirm proper startup
      machine.wait_for_unit("yabar.service", "bob")
      machine.sleep(10)
      machine.wait_for_unit("yabar.service", "bob")

      machine.screenshot("top_bar")
    '';
  }
)
