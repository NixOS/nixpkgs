import ./make-test.nix {
  name = "stanchion";

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.riak.enable = true;
        services.riak.package = pkgs.riak;

        services.stanchion.enable = true;
        services.stanchion.riakHost = "127.0.0.1:8087";
        services.stanchion.listener = "127.0.0.1:8085";
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("riak");
    $master->sleep(20); # Hopefully this is long enough!!

    $master->waitForUnit("stanchion");
    $master->sleep(20);

    $master->succeed("stanchion ping 2>&1");
  '';
}
