import ./make-test-python.nix (
  { pkgs, ... }:
  let
    listenPort = 30123;
    testString = "It works!";
    mkCreateSmallFileService =
      {
        path,
        loop ? false,
      }:
      {
        script = ''
          ${pkgs.coreutils}/bin/dd if=/dev/zero of=${path} bs=1K count=100
          ${pkgs.lib.optionalString loop "${pkgs.util-linux}/bin/losetup --find ${path}"}
        '';
        serviceConfig = {
          Type = "oneshot";
        };
        wantedBy = [ "multi-user.target" ];
        before = [ "nbd-server.service" ];
      };
  in
  {
    name = "nbd";

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          # Create some small files of zeros to use as the ndb disks
          ## `vault-pub.disk` is accessible from any IP
          systemd.services.create-pub-file = mkCreateSmallFileService { path = "/vault-pub.disk"; };
          ## `vault-priv.disk` is accessible only from localhost.
          ## It's also a loopback device to test exporting /dev/...
          systemd.services.create-priv-file = mkCreateSmallFileService {
            path = "/vault-priv.disk";
            loop = true;
          };
          ## `aaa.disk` is just here because "[aaa]" sorts before
          ## "[generic]" lexicographically, and nbd-server breaks if
          ## "[generic]" isn't the first section.
          systemd.services.create-aaa-file = mkCreateSmallFileService { path = "/aaa.disk"; };

          # Needed only for nbd-client used in the tests.
          environment.systemPackages = [ pkgs.nbd ];

          # Open the nbd port in the firewall
          networking.firewall.allowedTCPPorts = [ listenPort ];

          # Run the nbd server and expose the small file created above
          services.nbd.server = {
            enable = true;
            exports = {
              aaa = {
                path = "/aaa.disk";
              };
              vault-pub = {
                path = "/vault-pub.disk";
              };
              vault-priv = {
                path = "/dev/loop0";
                allowAddresses = [
                  "127.0.0.1"
                  "::1"
                ];
              };
            };
            listenAddress = "0.0.0.0";
            listenPort = listenPort;
          };
        };

      client =
        { config, pkgs, ... }:
        {
          programs.nbd.enable = true;
        };
    };

    testScript = ''
      testString = "${testString}"

      start_all()
      server.wait_for_open_port(${toString listenPort})

      # Client: Connect to the server, write a small string to the nbd disk, and cleanly disconnect
      client.succeed("nbd-client server ${toString listenPort} /dev/nbd0 -name vault-pub -persist")
      client.succeed(f"echo '{testString}' | dd of=/dev/nbd0 conv=notrunc")
      client.succeed("nbd-client -d /dev/nbd0")

      # Server: Check that the string written by the client is indeed in the file
      foundString = server.succeed(f"dd status=none if=/vault-pub.disk count={len(testString)}")[:len(testString)]
      if foundString != testString:
         raise Exception(f"Read the wrong string from nbd disk. Expected: '{testString}'. Found: '{foundString}'")

      # Client: Fail to connect to the private disk
      client.fail("nbd-client server ${toString listenPort} /dev/nbd0 -name vault-priv -persist")

      # Server: Successfully connect to the private disk
      server.succeed("nbd-client localhost ${toString listenPort} /dev/nbd0 -name vault-priv -persist")
      server.succeed(f"echo '{testString}' | dd of=/dev/nbd0 conv=notrunc")
      foundString = server.succeed(f"dd status=none if=/dev/loop0 count={len(testString)}")[:len(testString)]
      if foundString != testString:
         raise Exception(f"Read the wrong string from nbd disk. Expected: '{testString}'. Found: '{foundString}'")
      server.succeed("nbd-client -d /dev/nbd0")

      # Server: Successfully connect to the aaa disk
      server.succeed("nbd-client localhost ${toString listenPort} /dev/nbd0 -name aaa -persist")
      server.succeed(f"echo '{testString}' | dd of=/dev/nbd0 conv=notrunc")
      foundString = server.succeed(f"dd status=none if=/aaa.disk count={len(testString)}")[:len(testString)]
      if foundString != testString:
         raise Exception(f"Read the wrong string from nbd disk. Expected: '{testString}'. Found: '{foundString}'")
      server.succeed("nbd-client -d /dev/nbd0")
    '';
  }
)
