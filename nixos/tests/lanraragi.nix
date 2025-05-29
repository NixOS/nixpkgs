{ pkgs, lib, ... }:
{
  name = "lanraragi";
  meta.maintainers = with lib.maintainers; [ tomasajt ];

  nodes = {
    machine1 =
      { pkgs, ... }:
      {
        services.lanraragi.enable = true;
      };
    machine2 =
      { pkgs, ... }:
      {
        services.lanraragi = {
          enable = true;
          passwordFile = pkgs.writeText "lrr-test-pass" ''
            Ultra-secure-p@ssword-"with-spec1al\chars
          '';
          port = 4000;
          redis = {
            port = 4001;
            passwordFile = pkgs.writeText "redis-lrr-test-pass" ''
              123-redis-PASS
            '';
          };
        };
      };
  };

  testScript = ''
    start_all()

    machine1.wait_for_unit("lanraragi.service")
    machine1.wait_until_succeeds("curl -f localhost:3000")
    machine1.succeed("[ $(curl -o /dev/null -X post 'http://localhost:3000/login' --data-raw 'password=kamimamita' -w '%{http_code}') -eq 302 ]")

    machine2.wait_for_unit("lanraragi.service")
    machine2.wait_until_succeeds("curl -f localhost:4000")
    machine2.succeed("[ $(curl -o /dev/null -X post 'http://localhost:4000/login' --data-raw 'password=Ultra-secure-p@ssword-\"with-spec1al\\chars' -w '%{http_code}') -eq 302 ]")
  '';
}
