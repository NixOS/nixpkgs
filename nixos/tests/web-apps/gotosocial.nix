{ lib, ... }:
{
  name = "gotosocial";
  meta.maintainers = with lib.maintainers; [ blakesmith ];

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.jq ];
    services.gotosocial = {
      enable = true;
      setupPostgresqlDB = true;
      settings = {
        host = "localhost:8081";
        port = 8081;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("gotosocial.service")
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_open_port(8081)

    # check user registration via cli
    machine.succeed("curl -sS -f http://localhost:8081/nodeinfo/2.0 | jq '.usage.users.total' | grep -q '^0$'")
    machine.succeed("gotosocial-admin account create --username nickname --email email@example.com --password kurtz575VPeBgjVm")
    machine.succeed("curl -sS -f http://localhost:8081/nodeinfo/2.0 | jq '.usage.users.total' | grep -q '^1$'")
  '';
}
