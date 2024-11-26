import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "mate-wayland";

    meta.maintainers = lib.teams.mate.members;

    nodes.machine =
      { ... }:
      {
        imports = [
          ./common/user-account.nix
        ];

        services.xserver.enable = true;
        services.displayManager = {
          sddm.enable = true; # https://github.com/canonical/lightdm/issues/63
          sddm.wayland.enable = true;
          defaultSession = "MATE";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.xserver.desktopManager.mate.enableWaylandSession = true;

        # Need to switch to a different GPU driver than the default one (-vga std) so that wayfire can launch:
        virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
      };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      ''
        machine.wait_for_unit("display-manager.service")

        with subtest("Wait for Wayland server"):
            machine.wait_for_file("/run/user/${toString user.uid}/wayland-1")

        with subtest("Check if MATE session components actually start"):
            for i in ["wayfire", "mate-panel", "mate-wayland.sh", "mate-wayland-components.sh"]:
                machine.wait_until_succeeds(f"pgrep -f {i}")
            # It is expected that this applet doesn't work in Wayland
            machine.wait_for_text('WorkspaceSwitcherApplet')

        with subtest("Check if various environment variables are set"):
            cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf mate-panel)/environ"
            machine.succeed(f"{cmd} | grep 'XDG_SESSION_TYPE' | grep 'wayland'")
            machine.succeed(f"{cmd} | grep 'XDG_SESSION_DESKTOP' | grep 'MATE'")
            machine.succeed(f"{cmd} | grep 'MATE_PANEL_APPLETS_DIR' | grep '${pkgs.mate.mate-panel-with-applets.pname}'")

        with subtest("Check if Wayfire config is properly configured"):
            for i in ["button_style = mate", "firedecor", "mate-wayland-components.sh"]:
                machine.wait_until_succeeds(f"cat /home/${user.name}/.config/mate/wayfire.ini | grep '{i}'")

        with subtest("Check if Wayfire has ever coredumped"):
            machine.fail("coredumpctl --json=short | grep wayfire")
            machine.sleep(10)
            machine.screenshot("screen")
      '';
  }
)
