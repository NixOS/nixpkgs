{ lib, ... }:
{
  name = "phrog";
  meta = with lib.maintainers; {
    maintainers = [
      marcusramberg
    ];
  };

  nodes.machine = _: {
    users.users.alice = {
      isNormalUser = true;
      description = "Alice Foobar";
      password = "1234";
      uid = 1000;
    };

    # Required for wayland to work with Lemurs
    services.seatd.enable = true;
    environment.sessionVariables = {
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
    users.users.alice.extraGroups = [ "seat" ];

    services.displayManager.phrog.enable = true;

    programs.river-classic.enable = true;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'phrog.*tty1'")
    machine.screenshot("postboot")

    with subtest("Log in as alice to river"):
      machine.sleep(5)
      machine.send_chars("1234\n")
      machine.wait_until_succeeds("pgrep -u alice river")
      machine.sleep(5)
      machine.succeed("pgrep -u alice river")
      machine.screenshot("postlogin")
  '';
}
