import ./make-test.nix ({ pkgs, ...} : {
  name = "matomo";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ b42 ];
  };

  nodes = {
    matomo = { config, pkgs, ... }: {
      services.matomo = {
        enable = true;
        nginx = {
          forceSSL = false;
          enableACME = false;
        };
      };
      services.mysql = {
        enable = true;
        package = pkgs.mysql;
      };
      services.nginx.enable = true;
    };
  };

  testScript = ''
    $matomo->start;
    $matomo->waitForUnit("mysql.service");
    $matomo->waitForUnit("phpfpm-matomo.service");
    $matomo->waitForUnit("nginx.service");
    $matomo->succeed("curl -sSfL http://matomo/ | grep '<title>Matomo[^<]*Installation'");
  '';
})
