import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "yabar";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    services.xserver.displayManager.auto.user = "bob";

    programs.yabar.enable = true;
    programs.yabar.bars = {
      top.indicators.date.exec = "YABAR_DATE";
    };
  };

  testScript = ''
    $machine->start;
    $machine->waitForX;

    # confirm proper startup
    $machine->waitForUnit("yabar.service", "bob");
    $machine->sleep(10);
    $machine->waitForUnit("yabar.service", "bob");

    $machine->screenshot("top_bar");
  '';
})
