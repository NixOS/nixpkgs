import ./make-test.nix (

let
  client = { config, pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = [ pkgs.mumble ];
  };
in
{
  name = "mumble";

  nodes = {
    server = { config, pkgs, ... }: {
      services.murmur.enable       = true;
      services.murmur.registerName = "NixOS tests";
      networking.firewall.allowedTCPPorts = [ config.services.murmur.port ];
    };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    startAll;

    $server->waitForUnit("murmur.service");
    $client1->waitForX;
    $client2->waitForX;

    $client1->execute("mumble mumble://client1\@server/test &");
    $client2->execute("mumble mumble://client2\@server/test &");

    # cancel client audio configuration
    $client1->waitForWindow(qr/Audio Tuning Wizard/);
    $client2->waitForWindow(qr/Audio Tuning Wizard/);
    $client1->sendKeys("esc");
    $client2->sendKeys("esc");

    # cancel client cert configuration
    $client1->waitForWindow(qr/Certificate Management/);
    $client2->waitForWindow(qr/Certificate Management/);
    $client1->sendKeys("esc");
    $client2->sendKeys("esc");

    # accept server certificate
    $client1->waitForWindow(qr/^Mumble$/);
    $client2->waitForWindow(qr/^Mumble$/);
    $client1->sendChars("y");
    $client2->sendChars("y");

    # Find clients in logs
    $server->waitUntilSucceeds("grep -q 'client1' /var/log/murmur/murmurd.log");
    $server->waitUntilSucceeds("grep -q 'client2' /var/log/murmur/murmurd.log");

    $server->sleep(5); # wait to get screenshot
    $client1->screenshot("screen1");
    $client2->screenshot("screen2");
  '';
})
