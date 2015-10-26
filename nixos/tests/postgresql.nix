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
        services.postgresql.initialScript = "/etc/nixos/postgresql-init.sql";
      };
  };

  testScript = ''
    startAll;

    $master->execute("echo 'create role postgres with superuser login createdb;' > /etc/nixos/postgresql-init.sql");
    $master->waitForUnit("postgresql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("echo 'select 1' | sudo -u postgres psql");
  '';
})
