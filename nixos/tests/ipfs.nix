
import ./make-test.nix ({ pkgs, ...} : {
  name = "ipfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes = {
    adder =
      { config, pkgs, ... }:
      {
        services.ipfs = {
          enable = true;
          gatewayAddress = "/ip4/127.0.0.1/tcp/2323";
          apiAddress = "/ip4/127.0.0.1/tcp/2324";
        };
      };
    getter =
      { config, pkgs, ... }:
      {
         services.ipfs.enable = true;
      };
  };

  testScript = ''
    startAll;
    $adder->waitForUnit("ipfs");
    # * => needs ipfs dht (internet)
    # $getter->waitForUnit("ipfs");
    $adder->waitUntilSucceeds("ipfs --api /ip4/127.0.0.1/tcp/2324 id");
    $adder->mustSucceed("([[ -n '$(ipfs --api /ip4/127.0.0.1/tcp/2324 config Addresses.gatewayAddress | grep /ip4/127.0.0.1/tcp/2323)' ]])");
    # * $getter->waitUntilSucceeds("ipfs --api /ip4/127.0.0.1/tcp/5001 id");
    # * my $ipfsHash = $adder->mustSucceed("echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | cut -d' ' -f2");
    $adder->mustSucceed("([[ -n '$(echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | grep added)' ]])");
    # * $getter->mustSucceed("ipfs --api /ip4/127.0.0.1/tcp/5001 cat $ipfsHash");
    '';
})
