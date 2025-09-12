{ lib, ... }:
{
  name = "rauthy";
  meta.maintainers = with lib.maintainers; [
    gepbird
  ];

  nodes.machine =
    { pkgs, ... }:
    let
      # Do not use this in production. This will make the secret world-readable
      # in the Nix store
      secrets = {
        rauthy-secret-api.path = builtins.toString (
          pkgs.writeText "rauthy-secret-api" "SuperSecureSecret1337"
        );
        rauthy-secret-raft.path = builtins.toString (
          pkgs.writeText "rauthy-secret-raft" "SuperSecureSecret1337"
        );
      };
    in
    {
      services.rauthy = {
        enable = true;
        settings = {
          bootstrap = {
            admin_email = "admin@localhost";
          };
          cluster = {
            node_id = 1;
            nodes = [ "1 localhost:8100 localhost:8200" ];
            secret_api._secret_path = secrets.rauthy-secret-api.path;
            secret_raft._secret_path = secrets.rauthy-secret-raft.path;
          };
          email = {
            smtp_from = "Rauthy <rauthy@localhost>";
            smtp_password = "password";
            smtp_url = "localhost";
            smtp_username = "username";
          };
          encryption = {
            key_active = "q6u26";
            keys = [ "q6u26/M0NFQzhSSldCY01rckJNa1JYZ3g2NUFtSnNOVGdoU0E=" ];
          };
          events = {
            email = "admin@localhost";
          };
          server = {
            proxy_mode = false;
            pub_url = "localhost:8080";
            scheme = "http";
          };
          webauthn = {
            rp_id = "localhost";
            rp_origin = "http://localhost:5173";
          };
        };
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "rauthy" ];
        ensureUsers = [
          {
            name = "rauthy";
            ensureDBOwnership = true;
          }
        ];
      };
    };

  # TODO: write asserts, maybe add a mail server so it doesnt crash?
  testScript = ''
    machine.wait_for_unit("rauthy.service")
    machine.succeed("sleep 5")
  '';
}
