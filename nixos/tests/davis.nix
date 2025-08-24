{
  pkgs,
  config,
  ...
}:
{
  name = "davis";

  meta.maintainers = pkgs.davis.meta.maintainers;

  nodes.machine1 =
    { config, ... }:
    {
      virtualisation = {
        memorySize = 512;
      };

      services.davis = {
        enable = true;
        hostname = "davis.example.com";
        database = {
          driver = "postgresql";
        };
        mail = {
          dsnFile = "${pkgs.writeText "davisMailDns" "smtp://username:password@example.com:25"}";
          inviteFromAddress = "dav@example.com";
        };
        adminLogin = "admin";
        appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
        adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
      };
    };
  nodes.machine2 =
    { nodes, config, ... }:
    {
      virtualisation = {
        memorySize = 512;
      };
      environment.systemPackages = [ pkgs.fcgi ];

      # no nginx, and no mail dsn
      services.davis = {
        enable = true;
        hostname = "davis.example.com";
        database = {
          driver = "postgresql";
        };
        adminLogin = "admin";
        appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
        adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
        nginx = null;
      };
    };

  testScript = ''
    start_all()

    machine1.wait_for_unit("postgresql.target")
    machine1.wait_for_unit("davis-env-setup.service")
    machine1.wait_for_unit("davis-db-migrate.service")
    machine1.wait_for_unit("phpfpm-davis.service")

    with subtest("welcome screen loads"):
        machine1.succeed(
            "curl -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/ | grep '<title>Davis</title>'"
        )

    with subtest("login works"):
        csrf_token = machine1.succeed(
            "curl -c /tmp/cookies -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login | grep '_csrf_token' | sed -E 's,.*value=\"(.*)\".*,\\1,g'"
        )
        r = machine1.succeed(
            f"curl -b /tmp/cookies --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login -X POST -F _username=admin -F _password=nixos -F _csrf_token={csrf_token.strip()} -D headers"
        )
        print(r)
        machine1.succeed(
          "[[ $(grep -i 'location: ' headers | cut -d: -f2- | xargs echo) == /dashboard* ]]"
        )
    machine2.wait_for_unit("davis-env-setup.service")
    machine2.wait_for_unit("davis-db-migrate.service")
    machine2.wait_for_unit("phpfpm-davis.service")
    r = machine2.succeed(
        "find /var/lib/davis/var/log"
    )
    print(r)
    env = (
      "SCRIPT_NAME=/index.php",
      "SCRIPT_FILENAME=${config.nodes.machine2.services.davis.package}/public/index.php",
      "REMOTE_ADDR=127.0.0.1",
      "REQUEST_METHOD=GET",
    );
    page = machine2.succeed(f"{' '.join(env)} ${pkgs.fcgi}/bin/cgi-fcgi -bind -connect ${config.nodes.machine2.services.phpfpm.pools.davis.socket}")
  '';
}
