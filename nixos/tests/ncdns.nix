import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    fakeReply = pkgs.writeText "namecoin-reply.json" ''
      { "error": null,
        "id": 1,
        "result": {
          "address": "T31q8ucJ4dI1xzhxQ5QispfECld5c7Xw",
          "expired": false,
          "expires_in": 2248,
          "height": 438155,
          "name": "d/test",
          "txid": "db61c0b2540ba0c1a2c8cc92af703a37002e7566ecea4dbf8727c7191421edfb",
          "value": "{\"ip\": \"1.2.3.4\", \"email\": \"root@test.bit\",\"info\": \"Fake record\"}",
          "vout": 0
        }
      }
    '';

    # Disabled because DNSSEC does not currently validate,
    # see https://github.com/namecoin/ncdns/issues/127
    dnssec = false;

  in

  {
    name = "ncdns";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ rnhmjoj ];
    };

    nodes.server =
      { ... }:
      {
        networking.nameservers = [ "::1" ];

        services.namecoind.rpc = {
          address = "::1";
          user = "namecoin";
          password = "secret";
          port = 8332;
        };

        # Fake namecoin RPC server because we can't
        # run a full node in a test.
        systemd.services.namecoind = {
          wantedBy = [ "multi-user.target" ];
          script = ''
            while true; do
              echo -e "HTTP/1.1 200 OK\n\n $(<${fakeReply})\n" \
                | ${pkgs.netcat}/bin/nc -N -l ::1 8332
            done
          '';
        };

        services.ncdns = {
          enable = true;
          dnssec.enable = dnssec;
          identity.hostname = "example.com";
          identity.hostmaster = "root@example.com";
          identity.address = "1.0.0.1";
        };

        services.pdns-recursor.enable = true;
        services.pdns-recursor.resolveNamecoin = true;

        environment.systemPackages = [ pkgs.dnsutils ];
      };

    testScript =
      (lib.optionalString dnssec ''
        with subtest("DNSSEC keys have been generated"):
            server.wait_for_unit("ncdns")
            server.wait_for_file("/var/lib/ncdns/bit.key")
            server.wait_for_file("/var/lib/ncdns/bit-zone.key")

        with subtest("DNSKEY bit record is present"):
            server.wait_for_unit("pdns-recursor")
            server.wait_for_open_port(53)
            server.succeed("host -t DNSKEY bit")
      '')
      + ''
        with subtest("can resolve a .bit name"):
            server.wait_for_unit("namecoind")
            server.wait_for_unit("ncdns")
            server.wait_for_open_port(8332)
            assert "1.2.3.4" in server.succeed("dig @localhost -p 5333 test.bit")

        with subtest("SOA record has identity information"):
            assert "example.com" in server.succeed("dig SOA @localhost -p 5333 bit")

        with subtest("bit. zone forwarding works"):
            server.wait_for_unit("pdns-recursor")
            assert "1.2.3.4" in server.succeed("host test.bit")
      '';
  }
)
