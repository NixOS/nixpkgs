# Test printing via CUPS.
{
  pkgs,
  socket ? true, # whether to use socket activation
  listenTcp ? true, # whether to open port 631 on client
  ...
}:

let
  inherit (pkgs) lib;
in

{
  name = "printing";
  meta = {
    maintainers = [ ];
  };

  nodes.server =
    { ... }:
    {
      services.printing = {
        enable = true;
        stateless = true;
        startWhenNeeded = socket;
        listenAddresses = [ "*:631" ];
        defaultShared = true;
        openFirewall = true;
        extraConf = ''
          <Location />
            Order allow,deny
            Allow from all
          </Location>
        '';
      };
      # Add a HP Deskjet printer connected via USB to the server.
      hardware.printers.ensurePrinters = [
        {
          name = "DeskjetLocal";
          deviceUri = "usb://foobar/printers/foobar";
          model = "drv:///sample.drv/deskjet.ppd";
        }
      ];
    };

  nodes.client =
    { lib, ... }:
    {
      services.printing.enable = true;
      services.printing.startWhenNeeded = socket;
      services.printing.listenAddresses = lib.mkIf (!listenTcp) [ ];
      # Add printer to the client as well, via IPP.
      hardware.printers.ensurePrinters = [
        {
          name = "DeskjetRemote";
          deviceUri = "ipp://server/printers/DeskjetLocal";
          model = "drv:///sample.drv/deskjet.ppd";
        }
      ];
      hardware.printers.ensureDefaultPrinter = "DeskjetRemote";
    };

  testScript = ''
    import os
    import re

    start_all()

    with subtest("Make sure that cups is up on both sides and printers are set up"):
        server.wait_for_unit("ensure-printers.service")
        client.wait_for_unit("ensure-printers.service")

    assert "scheduler is running" in client.succeed("lpstat -r")

    with subtest("UNIX socket is used for connections"):
        assert "/var/run/cups/cups.sock" in client.succeed("lpstat -H")

    with subtest("HTTP server is available too"):
        ${lib.optionalString listenTcp ''client.succeed("curl --fail http://localhost:631/")''}
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
  '';
}
