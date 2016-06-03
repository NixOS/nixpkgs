import ./make-test.nix ({ pkgs, ...} :

{
  name = "sddm";
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
    services.xserver.desktopManager.kde5.enable = true;
  };

  enableOCR = true;

  testScript = { nodes, ... }:
  let xdo = "${pkgs.xdotool}/bin/xdotool"; in
   ''     
    sub krunner {
      my ($win,) = @_;
      $machine->execute("${xdo} key Alt+F2 sleep 1 type $win");
      $machine->execute("${xdo} search --sync --onlyvisible --class krunner sleep 5 key Return");
    }

    $machine->waitUntilSucceeds("pgrep plasmashell");
    $machine->succeed("xauth merge ~alice/.Xauthority");    
    $machine->waitForWindow(qr/Desktop.*/);

    # Check that logging in has given the user ownership of devices.
    $machine->succeed("getfacl /dev/snd/timer | grep -q alice");
    
    krunner("dolphin");
    $machine->waitForWindow(qr/.*Dolphin/);
    
    krunner("konsole");
    $machine->waitForWindow(qr/.*Konsole/);
    
    krunner("systemsettings5");
    $machine->waitForWindow(qr/.*Settings/);
    $machine->sleep(20);

    $machine->execute("${xdo} key Alt+F1 sleep 10");
    $machine->screenshot("screen");
  '';
})
