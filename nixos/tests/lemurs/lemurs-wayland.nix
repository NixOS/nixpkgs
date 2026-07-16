{ lib, ... }:
{
  name = "lemurs-wayland";
  meta = with lib.maintainers; {
    maintainers = [
      nullcube
      stunkymonkey
    ];
  };

  nodes.machine =
    { ... }:
    {
      imports = [ ../common/user-account.nix ];

      # Required for wayland to work with Lemurs
      services.seatd.enable = true;
      users.users.alice.extraGroups = [ "seat" ];

      services.displayManager.lemurs.enable = true;

      programs.river-classic.enable = true;
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'lemurs.*tty1'")
    machine.screenshot("postboot")

    with subtest("Log in as alice to river"):
      machine.send_chars("\n")
      machine.send_chars("alice\n")
      machine.sleep(1)
      machine.send_chars("foobar\n")
      machine.sleep(1)
      machine.wait_until_succeeds("pgrep -u alice river")
      machine.sleep(10)
      machine.succeed("pgrep -u alice river")
      machine.screenshot("postlogin")
  '';
}
