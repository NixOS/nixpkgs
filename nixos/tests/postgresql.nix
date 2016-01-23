import ./make-test.nix ({ pkgs, ...} : {
  name = "postgresql";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ zagy ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.postgresql.enable = true;
        services.postgresql.initialScript =  pkgs.writeText "postgresql-init.sql"
          ''
          CREATE ROLE postgres WITH superuser login createdb;
          '';
      };
  };

  testScript = ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("echo 'select 1' | sudo -u postgres psql");
  '';
})
