import ./make-test-python.nix ({ pkgs, ... }: {
  name = "gonic";

  nodes.machine = { ... }: {
    services.gonic = {
      enable = true;
      settings = {
        music-path = [ "/tmp" ];
        podcast-path = "/tmp";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("gonic")
    machine.wait_for_open_port(4747)
  '';
})
