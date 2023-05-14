import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "doh-proxy-rust";
  meta = with lib.maintainers; {
    maintainers = [ stephank ];
  };

  nodes = {
    machine = { pkgs, lib, ... }: {
      services.bind = {
        enable = true;
        extraOptions = "empty-zones-enable no;";
        zones = lib.singleton {
          name = ".";
          master = true;
          file = pkgs.writeText "root.zone" ''
            $TTL 3600
            . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
            . IN NS ns.example.org.
            ns.example.org. IN A    192.168.0.1
          '';
        };
      };
      services.doh-proxy-rust = {
        enable = true;
        flags = [
          "--server-address=127.0.0.1:53"
        ];
      };
    };
  };

  testScript = { nodes, ... }: ''
    url = "http://localhost:3000/dns-query"
    query = "AAABAAABAAAAAAAAAm5zB2V4YW1wbGUDb3JnAAABAAE="  # IN A ns.example.org.
    bin_ip = r"$'\xC0\xA8\x00\x01'"  # 192.168.0.1, as shell binary string

    machine.wait_for_unit("bind.service")
    machine.wait_for_unit("doh-proxy-rust.service")
    machine.wait_for_open_port(53)
    machine.wait_for_open_port(3000)
    machine.succeed(f"curl --fail -H 'Accept: application/dns-message' '{url}?dns={query}' | grep -F {bin_ip}")
  '';
})
