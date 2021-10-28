import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "qt-wayland";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ synthetica ];
  };

  machine = { ... }:

  {
    imports = [ ./common/wayland-cage.nix ];
    services.cage = {
      program = "${pkgs.lxqt.qterminal}/bin/qterminal";
      package = pkgs.cage.override { xwayland = null; };
    };
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    with subtest("Wait for cage to boot up"):
        start_all()
        machine.wait_for_file("/run/user/${toString user.uid}/wayland-0.lock")
        machine.wait_until_succeeds("pgrep qterminal")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
  '';
})
