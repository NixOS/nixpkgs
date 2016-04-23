# Test printing via CUPS.

import ./make-test.nix ({pkgs, ... }: {
  name = "printing";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ iElectric eelco chaoflow jgeerds ];
  };

  nodes = {

    server =
      { config, pkgs, ... }:
      { services.printing.enable = true;
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
      };

    client =
      { config, pkgs, nodes, ... }:
      { services.printing.enable = true;
      };

  };

  testScript =
    ''
      startAll;

      # Make sure that cups is up on both sides.
      $server->waitForUnit("cups.service");
      $client->waitForUnit("cups.service");
      $client->sleep(10); # wait until cups is fully initialized
      $client->succeed("lpstat -r") =~ /scheduler is running/ or die;
      $client->succeed("lpstat -H") =~ "/var/run/cups/cups.sock" or die;
      $client->succeed("curl --fail http://localhost:631/");
      $client->succeed("curl --fail http://server:631/");
      $server->fail("curl --fail --connect-timeout 2  http://client:631/");

      # Add a HP Deskjet printer connected via USB to the server.
      $server->succeed("lpadmin -p DeskjetLocal -E -v usb://foobar/printers/foobar");

      # Add it to the client as well via IPP.
      $client->succeed("lpadmin -p DeskjetRemote -E -v ipp://server/printers/DeskjetLocal");
      $client->succeed("lpadmin -d DeskjetRemote");

      # Do some status checks.
      $client->succeed("lpstat -a") =~ /DeskjetRemote accepting requests/ or die;
      $client->succeed("lpstat -h server:631 -a") =~ /DeskjetLocal accepting requests/ or die;
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
              $client->sleep(10);
              $client->succeed("lpq") =~ /active.*root.*$fn/ or die;

              # Ensure that a raw PCL file appeared in the server's queue
              # (showing that the right filters have been applied).  Of
              # course, since there is no actual USB printer attached, the
              # file will stay in the queue forever.
              $server->waitForFile("/var/spool/cups/d*-001");
              $server->sleep(10);
              $server->succeed("lpq -a") =~ /$fn/ or die;

              # Delete the job on the client.  It should disappear on the
              # server as well.
              $client->succeed("lprm");
              $client->sleep(10);
              $client->succeed("lpq -a") =~ /no entries/;
              Machine::retry sub {
                return 1 if $server->succeed("lpq -a") =~ /no entries/;
              };
              # The queue is empty already, so this should be safe.
              # Otherwise, pairs of "c*"-"d*-001" files might persist.
              $server->execute("rm /var/spool/cups/*");
          };
      }
    '';
})
