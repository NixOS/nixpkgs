{ lib, ... }:
{
  name = "lemurs-xorg-script";
  meta = with lib.maintainers; {
    maintainers = [
      nullcube
      stunkymonkey
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../common/user-account.nix ];

      services.displayManager.lemurs.enable = true;

      services.xserver.enable = true;

      environment.etc."lemurs/wms/icewm" = {
        mode = "755";
        text = ''
          #! /bin/sh
          exec ${pkgs.icewm}/bin/icewm-session
        '';
      };
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'lemurs.*tty1'")
    machine.screenshot("postboot")

    with subtest("Log in as alice to icewm"):
      machine.send_chars("\n")
      machine.send_chars("alice\n")
      machine.sleep(1)
      machine.send_chars("foobar\n")
      machine.wait_until_succeeds("pgrep -u alice icewm")
      machine.sleep(10)
      machine.succeed("pgrep -u alice icewm")
      machine.screenshot("postlogin")
  '';
}
