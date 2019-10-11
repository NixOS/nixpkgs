import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    system.maxClosureSize = 640 * 1024 * 1024;
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
