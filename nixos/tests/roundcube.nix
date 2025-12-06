{ pkgs, ... }:
let
  supportedDbTypes = [
    "mysql"
    "pgsql"
  ];
  makeLocalDbTest =
    dbType:
    pkgs.testers.nixosTest {
      name = "roundcube-localDb-${dbType}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ globin ];
      };

      nodes = {
        roundcube =
          { config, pkgs, ... }:
          {
            services.roundcube = {
              enable = true;
              hostName = "roundcube";
              database.type = dbType;
              package = pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
              plugins = [ "persistent_login" ];
              dicts = with pkgs.aspellDicts; [
                en
                fr
                de
              ];
            };
            services.nginx.virtualHosts.roundcube = {
              forceSSL = false;
              enableACME = false;
            };
          };
      };

      testScript =
        let
          dbUnit = if dbType == "mysql" then "mysql.service" else "postgresql.target";
        in
        ''
          roundcube.start
          roundcube.wait_for_unit("${dbUnit}")
          roundcube.wait_for_unit("phpfpm-roundcube.service")
          roundcube.wait_for_unit("nginx.service")
          roundcube.succeed("curl -sSfL http://roundcube/ | grep 'Keep me logged in'")
        '';
    };
in
pkgs.lib.listToAttrs (
  map (test: pkgs.lib.nameValuePair test.name test) (map makeLocalDbTest supportedDbTypes)
)
