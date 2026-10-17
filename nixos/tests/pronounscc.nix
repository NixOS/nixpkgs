{ lib, ... }:
{
  name = "pronounscc";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine = {
    services.pronounscc = {
      enable = true;
      settings = {
        HMAC_KEY = "dGVzdA==";
        DATABASE_URL = "postgresql://pronounscc@127.0.0.1/pronounscc?sslmode=disable";
        REDIS = "127.0.0.1:6379";
        BASE_URL = "http://localhost:3000";
        MINIO_ENDPOINT = "example.com";
        MINIO_BUCKET = "test";
      };
    };

    services.postgresql = {
      enable = true;
      authentication = lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      ensureDatabases = [ "pronounscc" ];
      ensureUsers = [
        {
          name = "pronounscc";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers."".enable = true;
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("pronounscc.service")
    machine.wait_for_unit("pronounscc-frontend.service")
    machine.wait_for_unit("pronounscc-exporter.service")
    machine.wait_for_unit("pronounscc-clean.timer")
    machine.wait_for_open_port(8080)
    machine.wait_for_open_port(3000)
    machine.wait_for_open_port(9090)

    machine.succeed("curl --fail --silent http://127.0.0.1:8080/v1/meta | grep -q git_commit")
    machine.succeed("curl --fail --silent http://127.0.0.1:3000/ | grep -qi '<html'")
  '';
}
