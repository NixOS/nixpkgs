import ./make-test-python.nix ({ pkgs, ...} : {
  name = "roundcube";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    roundcube = { config, pkgs, ... }: {
      services.roundcube = {
        enable = true;
        hostName = "roundcube";
        database.password = "not production";
        package = pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
        plugins = [ "persistent_login" ];
      };
      services.nginx.virtualHosts.roundcube = {
        forceSSL = false;
        enableACME = false;
      };
    };
  };

  testScript = ''
    roundcube.start
    roundcube.wait_for_unit("postgresql.service")
    roundcube.wait_for_unit("phpfpm-roundcube.service")
    roundcube.wait_for_unit("nginx.service")
    roundcube.succeed("curl -sSfL http://roundcube/ | grep 'Keep me logged in'")
  '';
})
