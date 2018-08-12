import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "yabar";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.yabar = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    services.xserver.displayManager.auto.user = "bob";

    programs.yabar.enable = true;
  };

  testScript = ''
    $yabar->start;
    $yabar->waitForX;

    $yabar->waitForUnit("yabar.service", "bob");
  '';
})
