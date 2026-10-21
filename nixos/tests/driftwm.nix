{ lib, ... }:
{
  name = "driftwm";
  meta.maintainers = with lib.maintainers; [ yiyu ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/auto.nix
        ./common/user-account.nix
      ];

      test-support.displayManager.auto = {
        enable = true;
        user = "alice";
      };

      services.xserver.enable = true;
      services.displayManager.defaultSession = "driftwm";

      programs.driftwm.enable = true;

      environment.systemPackages = [
        pkgs.wayland-utils
        pkgs.xdpyinfo
      ];

      virtualisation.memorySize = 2048;
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("driftwm session starts"):
        machine.wait_for_unit("driftwm.service", "alice")
        machine.wait_for_file("/run/user/1000/wayland-1")

    with subtest("Wayland clients can connect"):
        machine.succeed("su - alice -c 'WAYLAND_DISPLAY=/run/user/1000/wayland-1 wayland-info' >&2")
        machine.screenshot("driftwm")

    with subtest("X11 clients can connect through xwayland-satellite"):
        display = machine.wait_until_succeeds(
            "su - alice -c 'XDG_RUNTIME_DIR=/run/user/1000 systemctl --user show-environment'"
            + " | grep -Po '^DISPLAY=\\K.*'",
            timeout=60,
        ).strip()
        machine.succeed(f"su - alice -c 'DISPLAY={display} xdpyinfo' >&2")
  '';
}
