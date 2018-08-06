import ./make-test.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ thoughtpolice lsix ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = {
          enable = true;
          plugins = p: with p; [ postgis ];
        };
      };
  };

  testScript = ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis;'");
  '';
})
