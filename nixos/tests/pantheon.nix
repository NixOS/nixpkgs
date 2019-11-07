import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "pantheon";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = pkgs.pantheon.maintainers;
  };

  machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];

    services.xserver.enable = true;
    services.xserver.desktopManager.pantheon.enable = true;

    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    # Wait for display manager to start
    machine.wait_for_unit("display-manager.service")

    # Test we can see username in elementary-greeter
    machine.wait_for_text("${user.description}")
    machine.screenshot("elementary_greeter_lightdm")

    # Log in with elementary-greeter
    machine.send_chars("${user.password}\n")
    machine.wait_for_unit("default.target", "${user.name}")
    machine_wait_for_x()
    machine.wait_for_file("${user.home}/.Xauthority")
    machine.succeed("xauth merge ${user.home}/.Xauthority")

    # Check that logging in has given the user ownership of devices
    machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

    # TODO: DBus API could eliminate this?
    # Check if pantheon-shell components actually start
    machine.wait_until_succeeds("pgrep gala")
    machine.wait_for_window("gala")
    machine.wait_until_succeeds("pgrep wingpanel")
    machine.wait_for_window("wingpanel")
    machine.wait_until_succeeds("pgrep plank")
    machine.wait_for_window("plank")

    # Open elementary terminal
    machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.terminal &'")
    machine.wait_for_window("io.elementary.terminal")
    machine.sleep(20)
    machine.screenshot("screen")
  '';
})
