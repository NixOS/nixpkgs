{ lib, ... }:
{
  name = "lemurs-wayland-script";
  meta = with lib.maintainers; {
    maintainers = [
      nullcube
      stunkymonkey
    ];
  };

  nodes.machine =
    { lib, config, ... }:
    {
      imports = [ ../common/user-account.nix ];

      # Required for wayland to work with Lemurs
      services.seatd.enable = true;
      users.users.alice.extraGroups = [ "seat" ];

      services.displayManager.lemurs.enable = true;

      programs.sway.enable = true;
      environment.etc."lemurs/wayland/sway" = {
        mode = "755";
        text = ''
          #! /bin/sh
          exec ${lib.getExe config.programs.sway.package}
        '';
      };
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'lemurs.*tty1'")
    machine.screenshot("postboot")

    with subtest("Log in as alice to Sway"):
      machine.send_chars("\n")
      machine.send_chars("alice\n")
      machine.sleep(1)
      machine.send_chars("foobar\n")
      machine.sleep(1)
      machine.wait_until_succeeds("pgrep -u alice sway")
      machine.sleep(10)
      machine.succeed("pgrep -u alice sway")
      machine.screenshot("postlogin")
  '';
}
