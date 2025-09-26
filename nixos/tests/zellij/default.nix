{
  pkgs,
  ...
}:

let
  port = 8085;
  remote_hostname = "acme.test";
  remote_ip = "192.168.1.100";
in
{
  name = "zellij";

  nodes = {
    local = {
      imports = [
        ../common/user-account.nix
      ];

      services.zellij = {
        enable = true;
        user = "alice";
        web = {
          enable = true;
          port = port;
        };
      };

      environment.etc."zellij/config.kdl".text = ""; # without this, the server seems to not start in the test, but it seems to work in real world

      security.pki.certificateFiles = [
        ../common/acme/server/ca.cert.pem
      ];
      networking.extraHosts = ''
        ${remote_ip} ${remote_hostname}
      '';
    };

    remote = {
      imports = [
        ../common/user-account.nix
      ];

      services.zellij = {
        enable = true;
        user = "alice";
        web = {
          enable = true;
          port = port;
          openFirewall = true;
          ip = "0.0.0.0";
          certificate = ../common/acme/server/acme.test.cert.pem;
          key = ../common/acme/server/acme.test.key.pem;
        };
      };

      environment.etc."zellij/config.kdl".text = ""; # without this, the server seems to not start in the test, but it seems to work in real world

      networking = {
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = [
          {
            address = remote_ip;
            prefixLength = 24;
          }
        ];
      };
    };
  };

  testScript =
    { nodes, ... }:
    builtins.readFile (
      pkgs.replaceVars ./test.py {
        user_name = "alice";
        port = port;
        remote_hostname = remote_hostname;
      }
    );
}
