{ pkgs, lib, ... }:

{
  name = "tinywl";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { config, ... }:
    {
      # Automatically login on tty1 as a normal user:
      imports = [ ./common/user-account.nix ];
      services.getty.autologinUser = "alice";
      security.polkit.enable = true;

      environment = {
        systemPackages = with pkgs; [
          tinywl
          foot
          wayland-utils
        ];
      };

      hardware.graphics.enable = true;

      # Automatically start TinyWL when logging in on tty1:
      programs.bash.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          set -e
          test ! -e /tmp/tinywl.log # Only start tinywl once
          readonly TEST_CMD="wayland-info |& tee /tmp/test-wayland.out && touch /tmp/test-wayland-exit-ok; read"
          readonly FOOT_CMD="foot sh -c '$TEST_CMD'"
          tinywl -s "$FOOT_CMD" |& tee /tmp/tinywl.log
          touch /tmp/tinywl-exit-ok
        fi
      '';

      # Switch to a different GPU driver (default: -vga std), otherwise TinyWL segfaults:
      virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      # Wait for complete startup:
      machine.wait_until_succeeds("pgrep tinywl")
      machine.wait_for_file("/run/user/1000/wayland-0")
      machine.wait_until_succeeds("pgrep foot")
      machine.wait_for_file("/tmp/test-wayland-exit-ok")

      # Make a screenshot and save the result:
      machine.screenshot("tinywl_foot")
      print(machine.succeed("cat /tmp/test-wayland.out"))
      machine.copy_from_vm("/tmp/test-wayland.out")

      # Terminate cleanly:
      machine.send_key("alt-esc")
      machine.wait_until_fails("pgrep foot")
      machine.wait_until_fails("pgrep tinywl")
      machine.wait_for_file("/tmp/tinywl-exit-ok")
      machine.copy_from_vm("/tmp/tinywl.log")
    '';
}
