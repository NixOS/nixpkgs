import ./make-test-python.nix (
  { pkgs, ... }:
  let
    dnscryptServicePort = 5443;
  in
  {
    name = "encrypted-dns-server";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ paepcke ];
    };

    nodes = {
      # encrypted dns server
      server = {
        services.encrypted-dns-server = {
          enable = true;
          settings = {
            state_file = "/var/lib/encrypted-dns-server/encrypted-dns.state";
            listen_addrs = [
              {
                local = "127.0.0.1:${toString dnscryptServicePort}";
                external = "127.0.0.1:${toString dnscryptServicePort}";
              }
            ];
          };
        };
      };
    };

    testScript = ''
      server.wait_for_unit("encrypted-dns-server")
      server.wait_for_open_port(dnscryptServicePort)
    '';
  }
) { }
