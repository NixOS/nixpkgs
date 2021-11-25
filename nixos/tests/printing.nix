# Test printing via CUPS.

import ./make-test-python.nix ({pkgs, ... }:
let
  printingServer = startWhenNeeded: {
    services.printing.enable = true;
    services.printing.startWhenNeeded = startWhenNeeded;
    services.printing.listenAddresses = [ "*:631" ];
    services.printing.defaultShared = true;
    services.printing.extraConf = ''
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

in {
  name = "printing";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ domenkozar eelco matthewbauer ];
  };

  nodes = {
    socketActivatedServer = { ... }: (printingServer true);
    serviceServer = { ... }: (printingServer false);

    socketActivatedClient = { ... }: (printingClient true);
    serviceClient = { ... }: (printingClient false);
  };

  testScript = ''
    import os
    import re

    start_all()

    with subtest("Make sure that cups is up on both sides and printers are set up"):
        serviceServer.wait_for_unit("cups.service")
        serviceClient.wait_for_unit("cups.service")
        socketActivatedClient.wait_for_unit("ensure-printers.service")


    def test_printing(client, server):
        assert "scheduler is running" in client.succeed("lpstat -r")

        with subtest("UNIX socket is used for connections"):
            assert "/var/run/cups/cups.sock" in client.succeed("lpstat -H")
        with subtest("HTTP server is available too"):
            client.succeed("curl --fail http://localhost:631/")
            client.succeed(f"curl --fail http://{server.name}:631/")
            server.fail(f"curl --fail --connect-timeout 2 http://{client.name}:631/")

        with subtest("LP status checks"):
            assert "DeskjetRemote accepting requests" in client.succeed("lpstat -a")
            assert "DeskjetLocal accepting requests" in client.succeed(
                f"lpstat -h {server.name}:631 -a"
            )
            client.succeed("cupsdisable DeskjetRemote")
            out = client.succeed("lpq")
            print(out)
            assert re.search(
                "DeskjetRemote is not ready.*no entries",
                client.succeed("lpq"),
                flags=re.DOTALL,
            )
            client.succeed("cupsenable DeskjetRemote")
            assert re.match(
                "DeskjetRemote is ready.*no entries", client.succeed("lpq"), flags=re.DOTALL
            )

        # Test printing various file types.
        for file in [
            "${pkgs.groff.doc}/share/doc/*/examples/mom/penguin.pdf",
            "${pkgs.groff.doc}/share/doc/*/meref.ps",
            "${pkgs.cups.out}/share/doc/cups/images/cups.png",
            "${pkgs.pcre.doc}/share/doc/pcre/pcre.txt",
        ]:
            file_name = os.path.basename(file)
            with subtest(f"print {file_name}"):
                # Print the file on the client.
                print(client.succeed("lpq"))
                client.succeed(f"lp {file}")
                client.wait_until_succeeds(
                    f"lpq; lpq | grep -q -E 'active.*root.*{file_name}'"
                )

                # Ensure that a raw PCL file appeared in the server's queue
                # (showing that the right filters have been applied).  Of
                # course, since there is no actual USB printer attached, the
                # file will stay in the queue forever.
                server.wait_for_file("/var/spool/cups/d*-001")
                server.wait_until_succeeds(f"lpq -a | grep -q -E '{file_name}'")

                # Delete the job on the client.  It should disappear on the
                # server as well.
                client.succeed("lprm")
                client.wait_until_succeeds("lpq -a | grep -q -E 'no entries'")

                retry(lambda _: "no entries" in server.succeed("lpq -a"))

                # The queue is empty already, so this should be safe.
                # Otherwise, pairs of "c*"-"d*-001" files might persist.
                server.execute("rm /var/spool/cups/*")


    test_printing(serviceClient, serviceServer)
    test_printing(socketActivatedClient, socketActivatedServer)
  '';
})
