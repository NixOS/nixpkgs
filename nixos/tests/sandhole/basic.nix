{ pkgs, ... }:

let
  inherit (import ../ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;

  pubKey = pkgs.writeTextDir "user_keys/snakeoil.pub" snakeOilEd25519PublicKey;

  subdomainCert = (
    import ../common/acme/server/generate-certs.nix {
      pkgs = pkgs;
      domain = "hello.sandhole.nix";
    }
  );

  sandholeCerts = pkgs.stdenv.mkDerivation {
    name = "sandhole-certs";

    src = subdomainCert;

    installPhase = ''
      mkdir -p $out/hello.sandhole.nix
      cp ${subdomainCert}/hello.sandhole.nix.cert.pem $out/hello.sandhole.nix/fullchain.pem
      cp ${subdomainCert}/hello.sandhole.nix.key.pem $out/hello.sandhole.nix/privkey.pem
    '';
  };

in

{
  name = "sandhole-basic";
  meta.maintainers = with pkgs.lib.maintainers; [ EpicEric ];

  nodes = {
    # The reverse proxy running Sandhole.
    sandhole =
      { lib, ... }:
      with lib;
      {
        virtualisation.vlans = [ 10 ];
        networking = {
          useDHCP = false;
          interfaces.eth1 = {
            useDHCP = false;
            ipv4 = {
              addresses = [
                {
                  address = "192.168.10.10";
                  prefixLength = 24;
                }
              ];
              routes = mkForce [
                {
                  address = "0.0.0.0";
                  prefixLength = 0;
                  via = "192.168.10.1";
                }
              ];
            };
          };
          nameservers = [
            "8.8.8.8"
            "8.8.4.4"
          ];
        };
        services.sandhole = {
          enable = true;
          openFirewall = true;
          settings = {
            domain = "sandhole.nix";
            userKeysDirectory = "${pubKey}/user_keys";
            certificatesDirectory = sandholeCerts;
            bindHostnames = "all";
            ipBlocklist = [ "192.168.10.30/32" ];
          };
        };
      };

    # The server that will be proxied via SSH.
    server =
      { lib, ... }:
      with lib;
      {
        virtualisation.vlans = [ 10 ];
        networking = {
          useDHCP = false;
          interfaces.eth1 = {
            useDHCP = false;
            ipv4 = {
              addresses = [
                {
                  address = "192.168.10.20";
                  prefixLength = 24;
                }
              ];
              routes = mkForce [
                {
                  address = "0.0.0.0";
                  prefixLength = 0;
                  via = "192.168.10.1";
                }
              ];
            };
          };
          firewall.allowedTCPPorts = [ 80 ];
        };
        users.users.autossh = {
          isNormalUser = true;
        };
        users.groups.autossh = { };
        services.nginx = {
          enable = true;
          virtualHosts.localhost = {
            locations."/" = {
              return = "200 '<html><body>Hello, NixOS!</body></html>'";
              extraConfig = ''
                default_type text/html;
              '';
            };
          };
        };
        services.autossh.sessions = [
          {
            name = "sandhole";
            user = "autossh";
            extraArguments = ''
              -i ${snakeOilEd25519PrivateKey} \
              -o StrictHostKeyChecking=accept-new \
              -o ServerAliveInterval=30 \
              -R hello.sandhole.nix:443:localhost:80 \
              -p 2222 \
              192.168.10.10
            '';
          }
        ];
      };

    # The client that will be blocked from accessing Sandhole.
    blocked =
      { lib, ... }:
      with lib;
      {
        virtualisation.vlans = [ 10 ];
        networking = {
          useDHCP = false;
          interfaces.eth1 = {
            useDHCP = false;
            ipv4 = {
              addresses = [
                {
                  address = "192.168.10.30";
                  prefixLength = 24;
                }
              ];
              routes = mkForce [
                {
                  address = "0.0.0.0";
                  prefixLength = 0;
                  via = "192.168.10.1";
                }
              ];
            };
          };
        };
      };
  };

  testScript = ''
    sandhole.start()
    sandhole.wait_for_unit("sandhole.service")
    sandhole.wait_for_open_port(2222)

    server.start()
    server.wait_for_unit("autossh-sandhole.service")
    server.wait_until_succeeds(
      "${pkgs.curl}/bin/curl --fail"
      "  --resolve hello.sandhole.nix:443:192.168.10.10"
      "  --cacert ${subdomainCert}/ca.cert.pem"
      "  https://hello.sandhole.nix"
      "  | grep 'Hello, NixOS!'",
      timeout=30,
    )

    blocked.start()
    blocked.wait_for_unit("network.target")
    blocked.wait_until_succeeds(
      "${pkgs.curl}/bin/curl --fail"
      "  http://192.168.10.20"
      "  | grep 'Hello, NixOS!'",
      timeout=30,
    )
    blocked.fail(
      "${pkgs.curl}/bin/curl --fail"
      "  --resolve hello.sandhole.nix:443:192.168.10.10"
      "  --cacert ${subdomainCert}/ca.cert.pem"
      "  https://hello.sandhole.nix"
    )
  '';
}
