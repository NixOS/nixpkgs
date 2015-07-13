import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
