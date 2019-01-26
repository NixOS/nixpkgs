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
    $roundcube->waitForUnit("nginx.service");
    $roundcube->succeed("curl -sSfL http://roundcube/");
  '';
})
