{ pkgs, ... }:
{
  name = "cfssl";

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking.firewall.allowedTCPPorts = [ config.services.cfssl.port ];

      services.cfssl.enable = true;
      systemd.services.cfssl.after = [ "cfssl-init.service" ];

      systemd.services.cfssl-init = {
        description = "Initialize the cfssl CA";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "cfssl";
          Type = "oneshot";
          WorkingDirectory = config.services.cfssl.dataDir;
        };
        script = with pkgs; ''
          ${cfssl}/bin/cfssl genkey -initca ${
            pkgs.writeText "ca.json" (
              builtins.toJSON {
                hosts = [ "ca.example.com" ];
                key = {
                  algo = "rsa";
                  size = 4096;
                };
                names = [
                  {
                    C = "US";
                    L = "San Francisco";
                    O = "Internet Widgets, LLC";
                    OU = "Certificate Authority";
                    ST = "California";
                  }
                ];
              }
            )
          } | ${cfssl}/bin/cfssljson -bare ca
        '';
      };
    };

  testScript =
    let
      cfsslrequest =
        with pkgs;
        writeScript "cfsslrequest" ''
          curl -f -X POST -H "Content-Type: application/json" -d @${csr} \
            http://localhost:8888/api/v1/cfssl/newkey | ${cfssl}/bin/cfssljson /tmp/certificate
        '';
      csr = pkgs.writeText "csr.json" (
        builtins.toJSON {
          CN = "www.example.com";
          hosts = [
            "example.com"
            "www.example.com"
          ];
          key = {
            algo = "rsa";
            size = 2048;
          };
          names = [
            {
              C = "US";
              L = "San Francisco";
              O = "Example Company, LLC";
              OU = "Operations";
              ST = "California";
            }
          ];
        }
      );
    in
    ''
      machine.wait_for_unit("cfssl.service")
      machine.wait_until_succeeds("${cfsslrequest}")
      machine.succeed("ls /tmp/certificate-key.pem")
    '';
}
