import ./make-test-python.nix ({ lib, ... } : {
  name = "nix-fetch";
  meta.maintainers = with lib.maintainers; [ baloo ];

  nodes = {
    http_dns = { lib, pkgs, config, ... }: {
      networking.firewall.enable = false;
      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        { address = "fd21::1"; prefixLength = 64; }
      ];
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
        { address = "192.168.0.1"; prefixLength = 24; }
      ];

      services.unbound = {
        enable = true;
        enableRootTrustAnchor = false;
        settings = {
          server = {
            interface = [ "192.168.0.1" "fd21::1" "::1" "127.0.0.1" ];
            access-control = [ "192.168.0.0/24 allow" "fd21::/64 allow" "::1 allow" "127.0.0.0/8 allow" ];
            local-data = [
              ''"example.com. IN A 192.168.0.1"''
              ''"example.com. IN AAAA fd21::1"''
              ''"tarballs.nixos.org. IN A 192.168.0.1"''
              ''"tarballs.nixos.org. IN AAAA fd21::1"''
            ];
          };
        };
      };

      services.nginx = {
        enable = true;
        virtualHosts."example.com" = {
          root = pkgs.runCommand "testdir" {} ''
            mkdir "$out"
            echo hello world > "$out/index.html"
          '';
        };
      };
    };

    # client consumes a remote resolver
    client = { lib, nodes, pkgs, ... }: {
      networking.useDHCP = false;
      networking.nameservers = [
        (lib.head nodes.http_dns.config.networking.interfaces.eth1.ipv6.addresses).address
        (lib.head nodes.http_dns.config.networking.interfaces.eth1.ipv4.addresses).address
      ];
      networking.interfaces.eth1.ipv6.addresses = [
        { address = "fd21::10"; prefixLength = 64; }
      ];
      networking.interfaces.eth1.ipv4.addresses = [
        { address = "192.168.0.10"; prefixLength = 24; }
      ];

      nix.sandboxPaths = lib.mkForce [];
      nix.binaryCaches = lib.mkForce [];
      nix.useSandbox = lib.mkForce true;
    };
  };

  testScript = { nodes, ... }: ''
    http_dns.wait_for_unit("nginx")
    http_dns.wait_for_open_port(80)
    http_dns.wait_for_unit("unbound")
    http_dns.wait_for_open_port(53)

    client.start()
    client.wait_for_unit('multi-user.target')

    with subtest("can fetch data from a remote server outside sandbox"):
        client.succeed("nix --version >&2")
        client.succeed("curl -vvv http://example.com/index.html >&2")

    with subtest("nix-build can lookup dns and fetch data"):
        client.succeed("""
          nix-build -E 'derivation {
              builder = "builtin:fetchurl";

              # New-style output content requirements.
              outputHash = "0ix4jahrkll5zg01wandq78jw3ab30q4nscph67rniqg5x7r0j59";
              outputHashAlgo = "sha256";
              outputHashMode = "flat";

              name = "example.com";
              url = "http://example.com";

              unpack = false;
              executable = false;

              system = "builtin";

              # No need to double the amount of network traffic
              preferLocalBuild = true;

              impureEnvVars = [
                # We borrow these environment variables from the caller to allow
                # easy proxy configuration.  This is impure, but a fixed-output
                # derivation like fetchurl is allowed to do so since its result is
                # by definition pure.
                "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
              ];

              # To make "nix-prefetch-url" work.
              urls = [ "http://example.com" ];
            }' >&2
          """)
  '';
})
