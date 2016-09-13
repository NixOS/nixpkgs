import ./make-test.nix ({ pkgs, ...} : 

let
  client = { config, pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = [ pkgs.mumble ];
  };
in
{
  name = "mumble";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ thoughtpolice eelco chaoflow ];
  };

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

    sub retry {
        my ($coderef) = @_;
        my $n;
        for ($n = 0; $n < 900; $n++) {
            return if &$coderef;
            sleep 1;
        }
        die "action timed out after $n seconds";
    }

    my @clients = ($client1, $client2);
    foreach my $cl (@clients) {
        # cancel client audio configuration
        my $audiore = qr/Audio Tuning Wizard/;
        $cl->waitForWindow($audiore);
        $cl->sleep(5);
        $cl->nest("Cancel Audio Tuning Wizard", sub {
          my $c = 0;
          retry(sub {
            return 1 if !$cl->hasWindow($audiore);
            if ($c % 2 > 0) {
              $cl->sendKeys("alt-tab");
              $cl->sleep(5);
            }
            $cl->sendKeys("esc");
            $c++;
          });
        });

        # cancel client cert configuration
        my $certre = qr/Certificate Management/;
        $cl->waitForWindow($certre);
        $cl->sleep(5);
        $cl->nest("Cancel Certificate Management", sub {
          my $c = 0;
          retry(sub {
            return 1 if !$cl->hasWindow($certre);
            if ($c % 2 > 0) {
              $cl->sendKeys("alt-tab");
              $cl->sleep(5);
            }
            $cl->sendKeys("esc");
            $c++;
          });
        });

        # accept server certificate
        my $acceptre = qr/^Mumble$/;
        $cl->waitForWindow($acceptre);
        $cl->sleep(5);
        $cl->nest("Accept Server Certificate", sub {
          my $c = 0;
          retry(sub {
            return 1 if !$cl->hasWindow($acceptre);
            if ($c % 2 > 0) {
              $cl->sendKeys("alt-tab");
              $cl->sleep(5);
            }
            $cl->sendChars("y");
            $c++;
          });
        });
    }

    # Find clients in logs
    $server->waitUntilSucceeds("grep -q 'client1' /var/log/murmur/murmurd.log");
    $server->waitUntilSucceeds("grep -q 'client2' /var/log/murmur/murmurd.log");

    $server->sleep(5); # wait to get screenshot
    $client1->screenshot("screen1");
    $client2->screenshot("screen2");
  '';
})
