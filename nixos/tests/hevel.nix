{ lib, ... }:
{
  name = "hevel";

  meta.maintainers = with lib.maintainers; [
    ricardomaps
    yiyu
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.getty.autologinUser = "alice";

      programs.hevel.enable = true;

      environment.systemPackages = [ pkgs.wayland-utils ];

      virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_tty_matches("1", "alice@machine")

    with subtest("hevel starts through swc-launch"):
      machine.send_chars("swc-launch hevel 2> /tmp/hevel.log\n")
      machine.wait_for_file("/run/user/1000/wayland-0")
      machine.succeed("pgrep -u alice -x hevel")

    with subtest("clients can connect"):
      machine.succeed("su - alice -c 'XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 wayland-info' | grep wl_compositor")
      machine.screenshot("hevel")
  '';
}
