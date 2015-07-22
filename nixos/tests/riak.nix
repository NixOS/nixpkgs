import ./make-test.nix {
  name = "riak";

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.riak.enable = true;
        services.riak.package = pkgs.riak2;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("riak");
    $master->sleep(20); # Hopefully this is long enough!!
    $master->succeed("RIAK_DATA_DIR='/var/db/riak' RIAK_LOG_DIR='/var/log/riak' RIAK_ETC_DIR='/etc/riak' riak ping 2>&1");
  '';
}
