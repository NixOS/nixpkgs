import ./make-test.nix ({ pkgs, ...} : {
  name = "xrdp";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ volth ];
  };

  nodes = {
    server = { lib, pkgs, ... }: {
      imports = [ ./common/user-account.nix ];
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "${pkgs.xterm}/bin/xterm";
      networking.firewall.allowedTCPPorts = [ 3389 ];
    };

    client = { lib, pkgs, ... }: {
      imports = [ ./common/x11.nix ./common/user-account.nix ];
      services.xserver.displayManager.auto.user = "alice";
      environment.systemPackages = [ pkgs.freerdp ];
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
    };
  };

  testScript = { nodes, ... }: ''
    startAll;

    $client->waitForX;
    $client->waitForFile("/home/alice/.Xauthority");
    $client->succeed("xauth merge ~alice/.Xauthority");

    $client->sleep(5);

    $client->execute("xterm &");
    $client->sleep(1);
    $client->sendChars("xfreerdp /cert-tofu /w:640 /h:480 /v:127.0.0.1 /u:alice /p:foobar\n");
    $client->sleep(5);
    $client->screenshot("localrdp");

    $client->execute("xterm &");
    $client->sleep(1);
    $client->sendChars("xfreerdp /cert-tofu /w:640 /h:480 /v:server /u:alice /p:foobar\n");
    $client->sleep(5);
    $client->screenshot("remoterdp");
  '';
})
