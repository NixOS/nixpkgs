import ./make-test-python.nix ({ ... }: {
  name = "acme-dns";

  nodes.machine = { pkgs, ... }: {
    services.acme-dns = {
      enable = true;
      settings = {
        general = rec {
          domain = "acme-dns.home.arpa";
          nsname = domain;
          nsadmin = "admin.home.arpa";
          records = [
            "${domain}. A 127.0.0.1"
            "${domain}. AAAA ::1"
            "${domain}. NS ${domain}."
          ];
        };
        logconfig.loglevel = "debug";
      };
    };
    environment.systemPackages = with pkgs; [ curl bind ];
  };

  testScript = ''
    import json

    machine.wait_for_unit("acme-dns.service")
    machine.wait_for_open_port(53) # dns
    machine.wait_for_open_port(8080) # http api

    result = machine.succeed("curl --fail -X POST http://localhost:8080/register")
    print(result)

    registration = json.loads(result)

    machine.succeed(f'dig -t TXT @localhost {registration["fulldomain"]} | grep "SOA" | grep "admin.home.arpa"')

    # acme-dns exspects a TXT value string length of exactly 43 chars
    txt = "___dummy_validation_token_for_txt_record___"

    machine.succeed(
      "curl --fail -X POST http://localhost:8080/update "
      + f' -H "X-Api-User: {registration["username"]}"'
      + f' -H "X-Api-Key: {registration["password"]}"'
      + f' -d \'{{"subdomain":"{registration["subdomain"]}", "txt":"{txt}"}}\'''
    )

    assert txt in machine.succeed(f'dig -t TXT +short @localhost {registration["fulldomain"]}')
  '';
})
