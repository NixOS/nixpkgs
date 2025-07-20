{ lib, ... }:
{
  name = "pgweb";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.postgresql = {
        enable = true;
        authentication = ''
          host    all   all   ::1/128        trust
        '';
      };
      environment.systemPackages = [ pkgs.pgweb ];

      systemd.services.myservice = {
        serviceConfig = {
          ExecStart = "${pkgs.pgweb}/bin/pgweb --url postgresql://postgres@localhost:5432/postgres";
        };
        path = [ pkgs.getent ];
        after = [ "postgresql.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

  testScript = ''
    machine.wait_for_unit("myservice.service")
    machine.wait_for_open_port(8081)
    machine.wait_until_succeeds("curl -sSf localhost:8081 | grep '<div class=\"title\">Table Information</div>'")
  '';
}
