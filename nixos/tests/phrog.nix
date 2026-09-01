{ lib, ... }:
{
  name = "phrog";
  meta = with lib.maintainers; {
    maintainers = [
      marcusramberg
    ];
  };

  nodes.machine = {
    users.users.alice = {
      isNormalUser = true;
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

  enableOCR = true;

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'phrog.*tty1'")
    machine.screenshot("1 postboot")

    with subtest("Log in as alice to river"):
      machine.wait_for_text("Password:")
      machine.screenshot("2 prelogin")
      machine.send_chars("1234\n")
      machine.wait_until_succeeds("pgrep -u alice river")
      machine.sleep(5)
      machine.succeed("pgrep -u alice river")
      machine.screenshot("3 postlogin")
  '';
}
