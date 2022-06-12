import ./make-test-python.nix ({ pkgs, ... }: {
  name = "airsonic";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ sumnerevans ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.airsonic = {
        enable = true;
        maxMemory = 800;
      };
    };

  testScript = ''
    def airsonic_is_up(_) -> bool:
        return machine.succeed("curl --fail http://localhost:4040/login")


    machine.start()
    machine.wait_for_unit("airsonic.service")
    machine.wait_for_open_port(4040)

    with machine.nested("Waiting for UI to work"):
        retry(airsonic_is_up)
  '';
})
