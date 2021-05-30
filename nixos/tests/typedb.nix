import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "typedb";
  meta = with lib.maintainers; { maintainers = [ haskie ]; };

  machine = { lib, ... }: {
    environment.systemPackages = [ pkgs.nano ];
  };

  # enableOCR = true;

  testScript = { ... }:
    let user = machine.config.users.users.alice;
    in ''
      machine.execute("typedb server")
      machine.sleep(5)
      machine.send_key("ctrl-x")
      machine.succeed("test -f ~/.typedb_home/typedb")
    '';
})
