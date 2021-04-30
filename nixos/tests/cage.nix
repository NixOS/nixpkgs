import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "cage";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ matthewbauer ];
  };

  machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.cage = {
      enable = true;
      user = "alice";
      # Disable color and bold and use a larger font to make OCR easier:
      program = "${pkgs.xterm}/bin/xterm -cm -pc -fa Monospace -fs 24";
    };

    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    # Need to switch to a different VGA card / GPU driver because Cage segfaults with the default one (std):
    # machine # [   14.355893] .cage-wrapped[736]: segfault at 20 ip 00007f035fa0d8c7 sp 00007ffce9e4a2f0 error 4 in libwlroots.so.8[7f035fa07000+5a000]
    # machine # [   14.358108] Code: 4f a8 ff ff eb aa 0f 1f 44 00 00 c3 0f 1f 80 00 00 00 00 41 54 49 89 f4 55 31 ed 53 48 89 fb 48 8d 7f 18 48 8d 83 b8 00 00 00 <80> 7f 08 00 75 0d 48 83 3f 00 0f 85 91 00 00 00 48 89 fd 48 83 c7
    os.environ["QEMU_OPTS"] = "-vga virtio"

    with subtest("Wait for cage to boot up"):
        start_all()
        machine.wait_for_file("/run/user/${toString user.uid}/wayland-0.lock")
        machine.wait_until_succeeds("pgrep xterm")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
  '';
})
