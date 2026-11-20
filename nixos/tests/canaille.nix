{ pkgs, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  inherit (certs) domain;
in
{
  name = "canaille";
  meta.maintainers = with pkgs.lib.maintainers; [ erictapen ];

  nodes.server =
    { pkgs, lib, ... }:
    {
      services.canaille = {
        enable = true;
        secretKeyFile = pkgs.writeText "canaille-secret-key" ''
          this is not a secret key
        '';
        settings = {
          SERVER_NAME = domain;
        };
      };

      services.nginx.virtualHosts."${domain}" = {
        enableACME = lib.mkForce false;
        sslCertificate = certs."${domain}".cert;
        sslCertificateKey = certs."${domain}".key;
      };

      networking.hosts."::1" = [ "${domain}" ];
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      users.users.canaille.shell = pkgs.bashInteractive;

      security.pki.certificateFiles = [ certs.ca.cert ];
    };

  nodes.client =
    { nodes, ... }:
    {
      networking.hosts."${nodes.server.networking.primaryIPAddress}" = [ "${domain}" ];
      security.pki.certificateFiles = [ certs.ca.cert ];
    };

  testScript =
    { ... }:
    ''
      import json

      start_all()
      server.wait_for_unit("canaille.socket")
      server.wait_until_succeeds("curl -f https://${domain}")
      server.succeed("sudo -iu canaille -- canaille create user --user-name admin --password adminpass --emails admin@${domain}")
      json_str = server.succeed("sudo -iu canaille -- canaille get user")
      assert json.loads(json_str)[0]["user_name"] == "admin"
      server.succeed("sudo -iu canaille -- canaille config check")
    '';
}
