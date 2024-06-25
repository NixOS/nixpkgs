import ./make-test-python.nix ({ pkgs, ... }:
let
  listenPort = 11204;
in
{
  name = "iroh";

  nodes = {
    write = { config, ... }: {
      users.users.alice = {
        isNormalUser = true;
      };

      networking.firewall.allowedTCPPorts = [
        # TODO read listening port fro configuration
        #config.listenPort
        listenPort
      ];

      services.iroh = {
        enable = true;
      };
    };
    # read = { config, ... }: {
    # TODO create multiple nodes, add on one and retrieve on the other.
    # };
  };

  testScript = ''
    start_all()

    # TODO read port from service configuration
    #write.wait_for_open_port(${toString listenPort})
    write.wait_for_unit("default.target")

    with subtest("Add and retrieve data"):
        machine.succeed("echo fnord0 >> test-data")
        iroh_hash = machine.succeed(
            "su -- alice -l -c 'iroh blob add test-data' | grep Blob | cut -d ':' -f 2 | tr -d ' '"
        )
        machine.succeed(f"iroh blob get {iroh_hash} output.txt")
        machine.succeed("cat output.txt | grep fnord0")

    machine.stop_job("iroh")
  '';
})
