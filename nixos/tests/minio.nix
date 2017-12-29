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

      # Minio requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 4 * 1024;
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("minio.service");
      $machine->waitForOpenPort(9000);

      # Create a test bucket on the server
      $machine->succeed("mc config host add minio http://localhost:9000 BKIKJAA5BMMU2RHO6IBB V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12 S3v4");
      $machine->succeed("mc mb minio/test-bucket");
      $machine->succeed("mc ls minio") =~ /test-bucket/ or die;
      $machine->shutdown;

    '';
})
