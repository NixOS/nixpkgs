
import ./make-test.nix ({ pkgs, ...} : {
  name = "ipfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes = {
    adder =
      { ... }:
      {
        services.ipfs = {
          enable = true;
          defaultMode = "norouting";
          gatewayAddress = "/ip4/127.0.0.1/tcp/2323";
          apiAddress = "/ip4/127.0.0.1/tcp/2324";
        };
        networking.firewall.allowedTCPPorts = [ 4001 ];
      };
    getter =
      { ... }:
      {
        services.ipfs = {
          enable = true;
          defaultMode = "norouting";
          autoMount = true;
        };
        networking.firewall.allowedTCPPorts = [ 4001 ];
      };
  };

  testScript = ''
    startAll;
    $adder->waitForUnit("ipfs-norouting");
    $getter->waitForUnit("ipfs-norouting");

    # wait until api is available
    $adder->waitUntilSucceeds("ipfs --api /ip4/127.0.0.1/tcp/2324 id");
    my $addrId = $adder->succeed("ipfs --api /ip4/127.0.0.1/tcp/2324 id -f=\"<id>\"");
    my $addrIp = (split /[ \/]+/, $adder->succeed("ip -o -4 addr show dev eth1"))[3];

    $adder->mustSucceed("[ -n \"\$(ipfs --api /ip4/127.0.0.1/tcp/2324 config Addresses.Gateway | grep /ip4/127.0.0.1/tcp/2323)\" ]");

    # wait until api is available
    $getter->waitUntilSucceeds("ipfs --api /ip4/127.0.0.1/tcp/5001 id");
    my $ipfsHash = $adder->mustSucceed("echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | cut -d' ' -f2");
    chomp($ipfsHash);

    $adder->mustSucceed("[ -n \"\$(echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | grep added)\" ]");

    $getter->mustSucceed("ipfs --api /ip4/127.0.0.1/tcp/5001 swarm connect /ip4/$addrIp/tcp/4001/ipfs/$addrId");
    $getter->mustSucceed("[ -n \"\$(ipfs --api /ip4/127.0.0.1/tcp/5001 cat /ipfs/$ipfsHash | grep fnord)\" ]");
    $getter->mustSucceed("[ -n \"$(cat /ipfs/$ipfsHash | grep fnord)\" ]");
    '';
})
