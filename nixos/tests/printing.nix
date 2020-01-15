# Test printing via CUPS.

import ./make-test.nix ({pkgs, ... }:
let
  printingServer = startWhenNeeded: {
    services.printing.enable = true;
    services.printing.startWhenNeeded = startWhenNeeded;
    services.printing.listenAddresses = [ "*:631" ];
    services.printing.defaultShared = true;
    services.printing.extraConf =
      ''
        <Location />
          Order allow,deny
          Allow from all
        </Location>
      '';
    networking.firewall.allowedTCPPorts = [ 631 ];
    # Add a HP Deskjet printer connected via USB to the server.
    hardware.printers.ensurePrinters = [{
      name = "DeskjetLocal";
      deviceUri = "usb://foobar/printers/foobar";
      model = "drv:///sample.drv/deskjet.ppd";
    }];
  };
  printingClient = startWhenNeeded: {
    services.printing.enable = true;
    services.printing.startWhenNeeded = startWhenNeeded;
    # Add printer to the client as well, via IPP.
    hardware.printers.ensurePrinters = [{
      name = "DeskjetRemote";
      deviceUri = "ipp://${if startWhenNeeded then "socketActivatedServer" else "serviceServer"}/printers/DeskjetLocal";
      model = "drv:///sample.drv/deskjet.ppd";
    }];
    hardware.printers.ensureDefaultPrinter = "DeskjetRemote";
  };

in

{
  name = "printing";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco matthewbauer ];
  };

  nodes = {
    socketActivatedServer = { ... }: (printingServer true);
    serviceServer = { ... }: (printingServer false);

    socketActivatedClient = { ... }: (printingClient true);
    serviceClient = { ... }: (printingClient false);
  };

  testScript =
    ''
      startAll;

      # Make sure that cups is up on both sides.
      $serviceServer->waitForUnit("cups.service");
      $serviceClient->waitForUnit("cups.service");
      # wait until cups is fully initialized and ensure-printers has executed with 10s delay
      $serviceClient->sleep(20);
      $socketActivatedClient->waitUntilSucceeds("systemctl status ensure-printers | grep -q -E 'code=exited, status=0/SUCCESS'");
      sub testPrinting {
          my ($client, $server) = (@_);
          my $clientHostname = $client->name();
          my $serverHostname = $server->name();
          $client->succeed("lpstat -r") =~ /scheduler is running/ or die;
          # Test that UNIX socket is used for connections.
          $client->succeed("lpstat -H") =~ "/var/run/cups/cups.sock" or die;
          # Test that HTTP server is available too.
          $client->succeed("curl --fail http://localhost:631/");
          $client->succeed("curl --fail http://$serverHostname:631/");
          $server->fail("curl --fail --connect-timeout 2  http://$clientHostname:631/");
          # Do some status checks.
          $client->succeed("lpstat -a") =~ /DeskjetRemote accepting requests/ or die;
          $client->succeed("lpstat -h $serverHostname:631 -a") =~ /DeskjetLocal accepting requests/ or die;
          $client->succeed("cupsdisable DeskjetRemote");
          $client->succeed("lpq") =~ /DeskjetRemote is not ready.*no entries/s or die;
          $client->succeed("cupsenable DeskjetRemote");
          $client->succeed("lpq") =~ /DeskjetRemote is ready.*no entries/s or die;
          # Test printing various file types.
          foreach my $file ("${pkgs.groff.doc}/share/doc/*/examples/mom/penguin.pdf",
                            "${pkgs.groff.doc}/share/doc/*/meref.ps",
                            "${pkgs.cups.out}/share/doc/cups/images/cups.png",
                            "${pkgs.pcre.doc}/share/doc/pcre/pcre.txt")
          {
              $file =~ /([^\/]*)$/; my $fn = $1;
              subtest "print $fn", sub {
                  # Print the file on the client.
                  $client->succeed("lp $file");
                  $client->waitUntilSucceeds("lpq | grep -q -E 'active.*root.*$fn'");
                  # Ensure that a raw PCL file appeared in the server's queue
                  # (showing that the right filters have been applied).  Of
                  # course, since there is no actual USB printer attached, the
                  # file will stay in the queue forever.
                  $server->waitForFile("/var/spool/cups/d*-001");
                  $server->waitUntilSucceeds("lpq -a | grep -q -E '$fn'");
                  # Delete the job on the client.  It should disappear on the
                  # server as well.
                  $client->succeed("lprm");
                  $client->waitUntilSucceeds("lpq -a | grep -q -E 'no entries'");
                  Machine::retry sub {
                    return 1 if $server->succeed("lpq -a") =~ /no entries/;
                  };
                  # The queue is empty already, so this should be safe.
                  # Otherwise, pairs of "c*"-"d*-001" files might persist.
                  $server->execute("rm /var/spool/cups/*");
              };
          }
      }
      testPrinting($serviceClient, $serviceServer);
      testPrinting($socketActivatedClient, $socketActivatedServer);
  '';
})
