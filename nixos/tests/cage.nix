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

    # Need to switch to a different GPU driver than the default one (-vga std) so that Cage can launch:
    virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
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
