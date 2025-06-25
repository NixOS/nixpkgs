{ pkgs, lib, ... }:

{
  name = "postal";

  meta.maintainers = with lib.maintainers; [ MatthieuBarthel ];

  # tests are broken on aarch64 on ofborg
  # meta.broken = pkgs.stdenv.hostPlatform.isAarch64;

  nodes = {
    machine =
      { ... }:
      let
        envFile = pkgs.writeText "env-file" ''
          RAILS_SECRET_KEY=00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
          SMTP_PASSWORD=password
        '';

        signingKey = pkgs.writeText "signingKey" ''
          -----BEGIN PRIVATE KEY-----
          MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEA4rYQ+1P6a/Qg5Ui1
          /A+BSbI2fpHzOozPVNRPeXvf43pnvlOokgvguwaBvIyTPjLbsfDSUJEigP2LWHRz
          NbmoNwIDAQABAkEAo8el0vsjETQHQ7zYg6Tr4MKXLa7giS7KZV0PoRLFdn5OHve5
          5+eU6x3wnjwHirLENMtzH4Y83mAquJbfqyb0yQIhAPbYX97dQblT+dIKL0lST0Ge
          TKVRXs6zyPxz0XtBC8N1AiEA6x6IgCT1KyKUegkaFbvA1Eah3gw0RDF9rZiWcb16
          43sCIAy9+JzxgO4HJrMv8Wbwh8TUXhJ+k81JvItDk0GwhuHtAiADfoqszN/P6k2m
          mqgGlqnA/eO99xR3xvyFLfVeb2B6LQIhAKF7LHrsmnFx2IkVnJq+VVaaNjk2ZtPG
          dj4q+Kx6pHor
          -----END PRIVATE KEY-----
        '';

      in
      {
        virtualisation.memorySize = 1536;

        services.postal = {
          enable = true;
          domain = "localhost";
          environmentFile = envFile;
          workers = 2;
          settings = {
            postal = {
              web_protocol = "http";
              signing_key_path = signingKey;
            };
            smtp = {
              username = "username";
              from_address = "community@nixos.org";
            };
          };
        };
      };
  };

  testScript =
    let
      railsBootstrapCommands = [
        "Organization.create!(name: 'NixOS tests', owner_id: 1)"
        "Server.create!(name: 'NixOS DevMode', mode: 'Development', organization_id: 1)"
        "Domain.create!(name: 'nixos.org', owner_id: 1, owner_type: 'Organization', verified_at: Time.now, verification_method: 'DNS')"
        "Credential.create!(name: 'username', server_id: 1, type: 'SMTP')"
        "Credential.find(1).update_column(:key, 'password')"
      ];

    in
    ''
      machine.wait_for_unit("postal-smtp.service")
      machine.wait_for_unit("postal-web.service")
      machine.wait_for_unit("postal-worker@1.service")
      machine.wait_for_unit("postal-worker@2.service")

      machine.wait_for_open_port(9091)
      machine.wait_for_open_port(10130)
      machine.wait_for_open_port(10131)

      machine.succeed("""
        curl -isSf http://localhost:5000 | grep Location | grep http://localhost:5000/login
      """)

      machine.succeed("""
        curl -sSf http://localhost:10130 | grep worker
      """)

      machine.succeed("""
        curl -sSf http://localhost:10131 | grep worker
      """)

      machine.succeed("""
        curl -sSf http://localhost:9091 | grep smtp
      """)

      # Create user from cli
      machine.succeed("""
        printf "john.doe@nixos.org\\nJohn\\nDoe\\nPassw0rd!" | postal make-user
      """)

      # Bootstrap data from rails console
      machine.succeed("""
        echo -e "${lib.concatStringsSep "\\n" railsBootstrapCommands}" | postal console
      """)

      # Test smtp in dev mode (no real delivery)
      machine.succeed("""
        postal test-app-smtp test@example.com
      """)

      # As the test-app-smtp seems to not complete in sandbox, we can check that SMTP auth worked from the logs
      machine.succeed("""
        journalctl -u postal-smtp.service | grep "Granted for nixos-tests/nixos-devmode"
      """)
    '';
}
