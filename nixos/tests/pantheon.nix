import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "pantheon";

  meta.maintainers = lib.teams.pantheon.members;

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];

    services.xserver.enable = true;
    services.xserver.desktopManager.pantheon.enable = true;

    environment.systemPackages = [ pkgs.xdotool ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    bob = nodes.machine.users.users.bob;
  in ''
    machine.wait_for_unit("display-manager.service")

    with subtest("Test we can see usernames in elementary-greeter"):
        machine.wait_for_text("${user.description}")
        # OCR was struggling with this one.
        # machine.wait_for_text("${bob.description}")
        # Ensure the password box is focused by clicking it.
        # Workaround for https://github.com/NixOS/nixpkgs/issues/211366.
        machine.succeed("XAUTHORITY=/var/lib/lightdm/.Xauthority DISPLAY=:0 xdotool mousemove 512 505 click 1")
        machine.sleep(2)
        machine.screenshot("elementary_greeter_lightdm")

    with subtest("Login with elementary-greeter"):
        machine.send_chars("${user.password}\n")
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

    with subtest("Check if pantheon session components actually start"):
        machine.wait_until_succeeds("pgrep gala")
        machine.wait_for_window("gala")
        machine.wait_until_succeeds("pgrep -f io.elementary.wingpanel")
        machine.wait_for_window("io.elementary.wingpanel")
        machine.wait_until_succeeds("pgrep plank")
        machine.wait_for_window("plank")

    with subtest("Open system settings"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.switchboard >&2 &'")
        # Wait for all plugins to be loaded before we check if the window is still there.
        machine.sleep(5)
        machine.wait_for_window("io.elementary.switchboard")

    with subtest("Open elementary terminal"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.terminal >&2 &'")
        machine.wait_for_window("io.elementary.terminal")

    with subtest("Check if gala has ever coredumped"):
        machine.fail("coredumpctl --json=short | grep gala")
        machine.sleep(20)
        machine.screenshot("screen")
  '';
})
