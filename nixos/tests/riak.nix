import ./make-test.nix {
  name = "riak";

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.riak.enable = true;
        services.riak.package = pkgs.riak;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("riak");
    $master->sleep(20); # Hopefully this is long enough!!
    $master->succeed("riak ping 2>&1");
  '';
}
