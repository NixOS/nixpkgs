{ pkgs, lib, ... }:

{
  name = "postal";

  meta = {
    inherit (pkgs.postal.meta) maintainers;
    platforms = lib.platforms.linux;
  };

  nodes = {
    machine =
      { ... }:
      let
        inherit (lib) mkIf mkForce;

        envFile = pkgs.writeText "env-file" ''
          RAILS_SECRET_KEY=00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
          SMTP_PASSWORD=password
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
              signing_key_path = ./common/acme/server/acme.test.key.pem;
            };
            smtp = {
              username = "username";
              from_address = "community@nixos.org";
            };
          };
        };

        # unit fails to start with systemd-notify on ofborg
        systemd.services.postal-web.serviceConfig = mkIf (pkgs.stdenv.hostPlatform.isAarch64) {
          Type = mkForce "simple";
        };
      };
  };

  testScript = ''
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

    # create a user using the cli
    machine.succeed("""
      printf "john.doe@nixos.org\\nJohn\\nDoe\\nPassw0rd!" | postal make-user
    """)
  '';
}
