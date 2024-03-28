import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "cage";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ matthewbauer ];
  };

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];

    fonts.packages = with pkgs; [ dejavu_fonts ];

    services.cage = {
      enable = true;
      user = "alice";
      program = "${pkgs.xterm}/bin/xterm";
    };
  };

  interactive.nodes.machine = {
    virtualisation.opengl = true;
    environment.variables = {
      "WLR_NO_HARDWARE_CURSORS" = "1";
    };
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    with subtest("Wait for cage to boot up"):
        start_all()
        machine.wait_for_file("/run/user/${toString user.uid}/wayland-0.lock")
        machine.wait_until_succeeds("pgrep xterm")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
  '';
})
