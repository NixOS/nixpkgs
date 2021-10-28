import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "cage";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ matthewbauer ];
  };

  machine = { ... }:

  {
    imports = [ ./common/wayland-cage.nix ];
    # Disable color and bold and use a larger font to make OCR easier:
    services.cage.program = "${pkgs.xterm}/bin/xterm -cm -pc -fa Monospace -fs 24";
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
