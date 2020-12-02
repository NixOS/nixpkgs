import ./make-test-python.nix ({ pkgs, ... }: {
  name = "navidrome";

  machine = { ... }: {
    services.navidrome.enable = true;
    services.navidrome.settings = {
      MusicFolder = "/var/music";
      Port = 4535;
    };
  };

  testScript = ''
    machine.wait_for_unit("navidrome")
    machine.wait_for_open_port("4535")
  '';
})
