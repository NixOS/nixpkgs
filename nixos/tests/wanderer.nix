{ lib, ... }: {
  name = "wanderer";
  meta.maintainers = [ lib.maintainers.maartenbehn ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.etc = {
        "secrets/meili_key".text = "a-very-secret-meili-master-key-123456789";
        "secrets/wanderer.env".text = ''
          MEILI_MASTER_KEY=a-very-secret-meili-master-key-123456789
          POCKETBASE_ENCRYPTION_KEY=12345678901234567890123456789012
        '';
      };

      services.wanderer = {
        enable = true;
        port = 8080;
        origin = "http://localhost:8080";

        pocketbase = {
          port = 8091;
          publicUrl = "http://localhost:8091";
        };

        meilisearch = {
          enable = true;
          port = 7700;
          masterKeyFile = "/etc/secrets/meili_key";
        };

        environmentFile = "/etc/secrets/wanderer.env";
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("meilisearch.service")
    machine.wait_for_unit("wanderer-db.service")
    machine.wait_for_unit("wanderer.service")

    machine.wait_for_open_port(7700)
    machine.wait_for_open_port(8091)
    machine.wait_for_open_port(8080)

    machine.succeed("curl -fsS http://127.0.0.1:8091/api/health")

    machine.succeed("curl -fsS http://127.0.0.1:8080/")
  '';
}
