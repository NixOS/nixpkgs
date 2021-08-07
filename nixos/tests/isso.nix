import ./make-test-python.nix ({ pkgs, ... }: {
  name = "isso";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ asbachb ];
  };

  machine = { config, pkgs, ... }: {
    environment.systemPackages = [ pkgs.isso ];
  };

  testScript = let
    issoConfig = pkgs.writeText "minimal-isso.conf" ''
      [general]
      dbpath = /tmp/isso-comments.db
      host = http://localhost
    '';

    port = 8080;
  in
  ''
    machine.succeed("isso -c ${issoConfig} &")

    machine.wait_for_open_port("${toString port}")

    machine.succeed("curl --fail http://localhost:${toString port}/?uri")
    machine.succeed("curl --fail http://localhost:${toString port}/js/embed.min.js")
  '';
})
