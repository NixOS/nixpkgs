{ pkgs, ... }:

let
  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";

  rustfsPythonScript =
    pkgs.writers.writePython3 "rustfs-test" { libraries = with pkgs.python3Packages; [ minio ]; }
      /* python */ ''
        import io
        import os
        from minio import Minio

        minioClient = Minio(
          'localhost:9000',
          access_key='${accessKey}',
          secret_key='${secretKey}',
          secure=False
        )
        sio = io.BytesIO()
        sio.write(b'Test from Python')
        sio.seek(0, os.SEEK_END)
        sio_len = sio.tell()
        sio.seek(0)
        minioClient.put_object(
          'test-bucket',
          'test.txt',
          sio,
          sio_len,
          content_type='text/plain'
        )
      '';

in
{
  name = "rustfs";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      marcel
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.rustfs = {
        enable = true;
        environmentFile = builtins.toString (
          pkgs.writeText "rustfs-secrets.env" ''
            RUSTFS_ACCESS_KEY=${accessKey}
            RUSTFS_SECRET_KEY=${secretKey}
          ''
        );
      };

      environment.systemPackages = with pkgs; [ minio-client ];
    };

  testScript = /* python */ ''
    machine.wait_for_unit("rustfs.service")

    machine.succeed("mc alias set rustfs http://localhost:9000 ${accessKey} ${secretKey} --api s3v4")
    machine.succeed("mc mb rustfs/test-bucket")
    machine.succeed("${rustfsPythonScript}")
    assert "test-bucket" in machine.succeed("mc ls rustfs")
    assert "Test from Python" in machine.succeed("mc cat rustfs/test-bucket/test.txt")
    machine.succeed("mc rb --force rustfs/test-bucket")
  '';
}
