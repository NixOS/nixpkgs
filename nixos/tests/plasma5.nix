import ./make-test.nix ({ pkgs, ...} :

{
  name = "plasma5";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ttuegel ];
  };

  machine = { lib, ... }: {
    imports = [ ./common/user-account.nix ];
    virtualisation.memorySize = 1024;
    services.xserver.enable = true;
    services.xserver.displayManager.sddm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "alice";
      };
    };
    services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.desktopManager.default = "plasma5";
    virtualisation.writableStore = false; # FIXME
  };

  testScript = { nodes, ... }:
  let xdo = "${pkgs.xdotool}/bin/xdotool"; in
   ''
    startAll;

    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");

    $machine->waitUntilSucceeds("pgrep plasmashell");
    $machine->waitForWindow("^Desktop ");

    # Check that logging in has given the user ownership of devices.
    $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

    $machine->execute("su - alice -c 'DISPLAY=:0.0 dolphin &'");
    $machine->waitForWindow(" Dolphin");

    $machine->execute("su - alice -c 'DISPLAY=:0.0 konsole &'");
    $machine->waitForWindow("Konsole");

    $machine->execute("su - alice -c 'DISPLAY=:0.0 systemsettings5 &'");
    $machine->waitForWindow("Settings");

    $machine->execute("${xdo} key Alt+F1 sleep 10");
    $machine->screenshot("screen");
  '';
})
