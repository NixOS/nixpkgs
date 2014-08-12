# Test printing via CUPS.

import ./make-test.nix ({pkgs, ... }: {
  name = "printing";

  nodes = {

    server =
      { config, pkgs, ... }:
      { services.printing.enable = true;
        services.printing.listenAddresses = [ "*:631" ];
        services.printing.cupsdConf =
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
      $server->waitForUnit("cupsd.service");
      $client->waitForUnit("cupsd.service");
      $client->succeed("lpstat -r") =~ /scheduler is running/ or die;
      $client->succeed("lpstat -H") =~ "/var/run/cups/cups.sock" or die;
      $client->succeed("curl --fail http://localhost:631/");
      $client->succeed("curl --fail http://server:631/");
      $server->fail("curl --fail --connect-timeout 2  http://client:631/");

      # Add a HP Deskjet printer connected via USB to the server.
      $server->succeed("lpadmin -p DeskjetLocal -v usb://HP/Deskjet%205400%20series?serial=TH93I152S123XY -m 'drv:///sample.drv/deskjet.ppd' -E");

      # Add it to the client as well via IPP.
      $client->succeed("lpadmin -p DeskjetRemote -v ipp://server/printers/DeskjetLocal -m 'drv:///sample.drv/deskjet.ppd' -E");
      $client->succeed("lpadmin -d DeskjetRemote");

      # Do some status checks.
      $client->succeed("lpstat -a") =~ /DeskjetRemote accepting requests/ or die;
      $client->succeed("lpstat -h server -a") =~ /DeskjetLocal accepting requests/ or die;
      $client->succeed("cupsdisable DeskjetRemote");
      $client->succeed("lpq") =~ /DeskjetRemote is not ready.*no entries/s or die;
      $client->succeed("cupsenable DeskjetRemote");
      $client->succeed("lpq") =~ /DeskjetRemote is ready.*no entries/s or die;

      # Test printing various file types.
      foreach my $file ("${pkgs.groff}/share/doc/*/examples/mom/typesetting.pdf",
                        "${pkgs.groff}/share/doc/*/meref.ps",
                        "${pkgs.cups}/share/doc/cups/images/cups.png",
                        "${pkgs.xz}/share/doc/xz/faq.txt")
      {
          $file =~ /([^\/]*)$/; my $fn = $1;

          subtest "print $fn", sub {

              # Print the file on the client.
              $client->succeed("lp $file");
              $client->succeed("lpq") =~ /active.*root.*$fn/ or die;

              # Ensure that a raw PCL file appeared in the server's queue
              # (showing that the right filters have been applied).  Of
              # course, since there is no actual USB printer attached, the
              # file will stay in the queue forever.
              $server->waitForFile("/var/spool/cups/d*-*");
              $server->succeed("lpq -a") =~ /remroot.*$fn/ or die;
              $server->succeed("hexdump -C -n2 /var/spool/cups/d*-*") =~ /1b 45/ or die; # 1b 45 = printer reset

              # Delete the job on the client.  It should disappear on the
              # server as well.
              $client->succeed("lprm");
              $client->succeed("lpq -a") =~ /no entries/;
              Machine::retry sub {
                return 1 if $server->succeed("lpq -a") =~ /no entries/;
              };
          };
      }
    '';

})
