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

      environment.systemPackages = [ pkgs.xinput ];

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

    with subtest("X server has keyboard and pointer"):
      display = machine.succeed(
        "tr '\\0' '\\n' < /proc/$(pgrep -u alice -x icewm)/environ | sed -n 's/^DISPLAY=//p'"
      ).strip()
      xinput = f"su alice -c 'DISPLAY={display} XAUTHORITY=/home/alice/.Xauthority xinput list --short'"
      devices = machine.succeed(xinput)
      print(devices)
      machine.succeed(f"{xinput} | grep -v -e 'Virtual core' -e XTEST | grep 'slave  keyboard'")
      machine.succeed(f"{xinput} | grep -v -e 'Virtual core' -e XTEST | grep 'slave  pointer'")

    with subtest("Keyboard input reaches the session"):
      # Open the icewm menu and start its first entry (xterm)
      machine.send_key("ctrl-esc")
      machine.sleep(2)
      machine.send_key("ret")
      machine.wait_until_succeeds("pgrep -u alice xterm")
      machine.screenshot("xterm")
  '';
}
