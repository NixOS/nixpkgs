import ./make-test.nix ({ pkgs, ...} : {
  name = "minio";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bachp ];
  };

  nodes = {
    machine = { config, pkgs, ... }: {
      services.minio = {
        enable = true;
        accessKey = "BKIKJAA5BMMU2RHO6IBB";
        secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
      };
      environment.systemPackages = [ pkgs.minio-client ];
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("minio.service");
      $machine->waitForOpenPort(9000);
      $machine->succeed("curl --fail http://localhost:9000/minio/index.html");

      # Create a test bucket on the server
      $machine->succeed("mc config host add minio http://localhost:9000 BKIKJAA5BMMU2RHO6IBB V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12 S3v4");
      $machine->succeed("mc mb minio/test-bucket");
      $machine->succeed("mc ls minio") =~ /test-bucket/ or die;
      $machine->shutdown;

    '';
})
