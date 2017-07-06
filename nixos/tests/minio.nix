import ./make-test.nix ({ pkgs, ...} : {
  name = "minio";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bachp ];
  };

  machine = { config, pkgs, ... }: {
    services.minio.enable = true;
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("minio.service");
      $machine->waitForOpenPort(9000);
      $machine->succeed("curl --fail http://localhost:9000/minio/index.html");
      $machine->shutdown;
    '';
})
