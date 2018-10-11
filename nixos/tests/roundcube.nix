import ./make-test.nix ({ pkgs, ...} : {
  name = "roundcube";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    roundcube = { config, pkgs, ... }: {
      services.roundcube = {
        enable = true;
        hostName = "roundcube";
        nginx.enable = true;
        database.password = "notproduction";
      };
      services.nginx.virtualHosts.roundcube = {
        forceSSL = false;
        enableACME = false;
      };
    };
  };

  testScript = ''
    $roundcube->start;
    $roundcube->waitForUnit("postgresql.service");
    $roundcube->waitForUnit("phpfpm-roundcube.service");
    $roundcube->succeed("curl -sSfL http://roundcube/");
  '';
})
