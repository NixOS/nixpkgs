{ ... }:
{
  name = "roundcube";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    roundcube =
      { pkgs, ... }:
      {
        services.roundcube = {
          enable = true;
          hostName = "roundcube";
          database.passwordFile = pkgs.writeText "roundcube-test-password.txt" "not production";
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

        specialisation.sqlite.configuration =
          { ... }:
          {
            services.roundcube.configurePgsql = false;
            services.roundcube.database = {
              type = "sqlite";
              host = "/var/lib/roundcube/db.sqlite";
            };
          };
      };
  };

  testScript =
    { nodes, ... }:
    # python
    ''
      roundcube.start
      roundcube.wait_for_unit("postgresql.target")
      roundcube.wait_for_unit("phpfpm-roundcube.service")
      roundcube.wait_for_unit("nginx.service")
      roundcube.succeed("curl -sSfL http://roundcube/ | grep 'Keep me logged in'")

      with subtest("SQLite database"):
        roundcube.succeed('${nodes.roundcube.system.build.toplevel}/specialisation/sqlite/bin/switch-to-configuration test')
        roundcube.succeed("curl -sSfL http://roundcube/ | grep 'Keep me logged in'")
    '';
}
