import ./make-test-python.nix ({ pkgs, ... }: {
  name = "mindustry";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ oro ]; };

  nodes = {
    server = { ... }: {
      services.mindustry = {
        enable = true;
        extraConfig.socketInput = true;
      };
    };
  };

  testScript = ''
    server.start()
    with subtest("should start mindustry service"):
        server.wait_for_unit("mindustry.service")
        server.wait_for_open_port(6567)

    with subtest("should display version"):
        server.succeed('echo "version" | nc -w1 127.0.0.1 6859')
        server.succeed('journalctl -u mindustry | grep -q -i "${pkgs.mindustry-server.version}"')
  '';

})
