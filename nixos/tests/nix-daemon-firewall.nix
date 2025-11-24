{ lib, pkgs, ... }:
let
  # Hashes for the test files we serve. We have multiple of them to force nix
  # to download the files instead of using the already-downloaded variant
  hashes = {
    a = "sha256-ypeBEsobvcr6wjGzmiPcTaeG7/gUfE5yuYB3ha/uSLs=";
    b = "sha256-PiPoFgA5WUoziU9lZOGxNIu9egCI1CxKy3PurtWcAJ0=";
    c = "sha256-Ln0sA6lQeuJl7PW1NWiFpTOTogKdJBOUmXJloaJa78Y=";
  };

  # Builds a .nix file that can download a file from the test server
  mkFetcher =
    {
      name,
      url,
      hash,
    }:
    pkgs.writeText "${name}.nix" ''
      derivation {
          name = "${name}-fetch";
          builder = "builtin:fetchurl";
          system = "builtin";
          preferLocalBuild = true;

          url = "${url}";
          outputHash = "${hash}";
          outputHashMode = "flat";
        }
    '';

  # Fetches a file from the public IP, port 80
  publicFetcher = mkFetcher {
    name = "public";
    url = "http://1.0.0.1/a";
    hash = hashes.a;
  };

  # Fetches a file from the private IP, port 80
  privateFetcher = mkFetcher {
    name = "private";
    url = "http://192.168.0.1/b";
    hash = hashes.b;
  };

  # Fetches a file from the public IP, port 81
  publicFetcherOtherPort = mkFetcher {
    name = "public";
    url = "http://192.168.0.1:81/c";
    hash = hashes.c;
  };

  # Fetches a file from localhost
  localhostFetcher = mkFetcher {
    name = "localhost";
    url = "http://127.0.0.1/a";
    hash = hashes.a;
  };

  # Generates a file but tires to resolve via DNS first
  resolver = pkgs.writeText "pinger.nix" ''
    derivation {
      name = "resolver";

      system = builtins.currentSystem;
      preferLocalBuild = true;

      builder = "/bin/sh";
      args = [ "-c" "${pkgs.pkgsStatic.busybox}/bin/nslookup . && echo hello > $out" ];

      outputHash = "sha256-WJG1tSLV3whtD/CxEPvZ0hu0/HFjrzTQgoai6Eb2vgM=";
      outputHashMode = "flat";
    }
  '';

  # Base system for all fetchers
  baseNixSystem = ipSuffix: {
    networking = {
      useDHCP = false;
      interfaces.eth1 = {
        ipv4.addresses = [
          {
            address = "192.168.0.${toString ipSuffix}";
            prefixLength = 24;
          }
          {
            address = "1.0.0.${toString ipSuffix}";
            prefixLength = 24;
          }
        ];
      };
      nftables = {
        enable = true;
        flushRuleset = false;
      };
    };

    nix.settings = {
      # Gets rid of substitution warnings
      substituters = lib.mkForce [ ];
      # Gives us access inside the nix sandbox
      extra-sandbox-paths = [ "${pkgs.pkgsStatic.busybox}" ];
    };

    # Easy way to get files to the system
    environment.etc = {
      "fetch-public.nix".source = publicFetcher;
      "fetch-private.nix".source = privateFetcher;
      "fetch-public-other-port.nix".source = publicFetcherOtherPort;
      "fetch-localhost.nix".source = localhostFetcher;
      "resolver.nix".source = resolver;
    };

    # For localhost tests
    services.nginx = {
      enable = true;
      virtualHosts.default.locations."/a".return = "200 \"a\"";
    };
  };
in
{
  name = "nix-daemon-firewall";
  meta.maintainers = with lib.maintainers; [ das_j ];

  nodes = {
    httpServer = {
      services.nginx = {
        enable = true;
        virtualHosts.default = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 80;
            }
            {
              addr = "0.0.0.0";
              port = 81;
            }
          ];
          locations = {
            "/a".return = "200 \"a\"";
            "/b".return = "200 \"b\"";
            "/c".return = "200 \"c\"";
          };
        };
      };
      networking = {
        useDHCP = false;
        interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.1";
              prefixLength = 24;
            }
            {
              address = "1.0.0.1";
              prefixLength = 24;
            }
          ];
        };

        firewall.allowedTCPPorts = [
          80
          81
        ];
      };
    };

    unfirewalled = {
      imports = [ (baseNixSystem 2) ];
    };

    everythingAllowed = {
      imports = [ (baseNixSystem 3) ];
      nix.firewall = {
        enable = true;
        allowLoopback = true;
        allowNonTCPUDP = true;
      };
    };

    noLocalNets = {
      imports = [ (baseNixSystem 4) ];
      nix.firewall = {
        enable = true;
        allowPrivateNetworks = false;
      };
    };

    onlyPort80 = {
      imports = [ (baseNixSystem 5) ];
      nix.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };

    resolved = {
      imports = [ (baseNixSystem 6) ];
      nix.firewall = {
        enable = true;
      };
      services.resolved.enable = true;
    };
  };

  testScript = ''
    # Startup
    start_all()
    httpServer.wait_for_open_port(80)

    # No firewall
    unfirewalled.wait_for_unit("multi-user.target")
    unfirewalled.fail("nft list ruleset | grep nix_daemon_traffic")

    # Everything allowed
    everythingAllowed.wait_for_unit("multi-user.target")
    everythingAllowed.succeed("nft list ruleset | grep nix_daemon_traffic")
    everythingAllowed.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-public.nix")
    everythingAllowed.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-private.nix")
    everythingAllowed.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-public-other-port.nix")
    everythingAllowed.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-localhost.nix")

    # No local networks and no localhost
    noLocalNets.wait_for_unit("multi-user.target")
    noLocalNets.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-public.nix")
    noLocalNets.fail("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-private.nix")
    noLocalNets.fail("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-localhost.nix")

    # Ports
    onlyPort80.wait_for_unit("multi-user.target")
    onlyPort80.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-public.nix")
    onlyPort80.fail("NIX_REMOTE=daemon nix-build --timeout 5 /etc/fetch-public-other-port.nix")

    # systemd-resolved
    resolved.wait_for_unit("multi-user.target")
    resolved.succeed("NIX_REMOTE=daemon nix-build --timeout 5 /etc/resolver.nix")
  '';
}
