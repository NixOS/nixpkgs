{ pkgs, ... }:
{
  name = "roundcube";
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
          database.password = "not production";
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

  testScript = ''
    roundcube.start
    roundcube.wait_for_unit("postgresql.target")
    roundcube.wait_for_unit("phpfpm-roundcube.service")
    roundcube.wait_for_unit("nginx.service")
    roundcube.succeed("curl -sSfL http://roundcube/ | grep 'Keep me logged in'")
  '';
}
