import ./make-test-python.nix ({ pkgs, ... }:
let
  listenPort = 12345;
in
{
  name = "iroh";

  nodes = {
    write = { config, ... }: {
      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ config.services.iroh.group ];
      };

      networking.firewall.allowedTCPPorts = [ listenPort ];

      services.iroh = {
        enable = true;
        listenPort = listenPort;
        dataDir = "/mnt/iroh";
      };
    };
    # read = { config, ... }: {
    # TODO create multiple nodes, add on one and retrieve on the other.
    # };
  };

  testScript = ''
    start_all()

    write.wait_for_open_port(${toString listenPort})

    with subtest("Add and retrieve data"):
        iroh_hash = machine.succeed(
            "echo fnord0 >> test-data && su alice -l -c 'iroh blob add test-data' | grep Blob | cut -d ':' -f 2 | tr -d ' '"
        )
        machine.succeed(f"iroh blob get {iroh_hash} output.txt")
        machine.succeed("cat output.txt | grep fnord0")

    machine.stop_job("iroh")
  '';
})
