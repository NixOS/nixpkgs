import ./make-test-python.nix (
  { pkgs, ... }:
  let
    accessKey = "BKIKJAA5BMMU2RHO6IBB";
    secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
    minioPythonScript = pkgs.writeScript "minio-test.py" ''
      #! ${pkgs.python3.withPackages (ps: [ ps.minio ])}/bin/python
      import io
      import os
      from minio import Minio
      minioClient = Minio('localhost:9000',
                    access_key='${accessKey}',
                    secret_key='${secretKey}',
                    secure=False)
      sio = io.BytesIO()
      sio.write(b'Test from Python')
      sio.seek(0, os.SEEK_END)
      sio_len = sio.tell()
      sio.seek(0)
      minioClient.put_object('test-bucket', 'test.txt', sio, sio_len, content_type='text/plain')
    '';
    rootCredentialsFile = "/etc/nixos/minio-root-credentials";
    credsPartial = pkgs.writeText "minio-credentials-partial" ''
      MINIO_ROOT_USER=${accessKey}
    '';
    credsFull = pkgs.writeText "minio-credentials-full" ''
      MINIO_ROOT_USER=${accessKey}
      MINIO_ROOT_PASSWORD=${secretKey}
    '';
  in
  {
    name = "minio";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bachp ];
    };

    nodes = {
      machine =
        { pkgs, ... }:
        {
          services.minio = {
            enable = true;
            inherit rootCredentialsFile;
          };
          environment.systemPackages = [ pkgs.minio-client ];

          # Minio requires at least 1GiB of free disk space to run.
          virtualisation.diskSize = 4 * 1024;

          # Minio pre allocates 2GiB or memory, reserve some more
          virtualisation.memorySize = 4096;
        };
    };

    testScript = ''

      start_all()
      # simulate manually editing root credentials file
      machine.wait_for_unit("multi-user.target")
      machine.copy_from_host("${credsFull}", "${rootCredentialsFile}")

      machine.wait_for_unit("minio.service")
      machine.wait_for_open_port(9000)

      # Create a test bucket on the server
      machine.succeed(
          "mc config host add minio http://localhost:9000 ${accessKey} ${secretKey} --api s3v4"
      )
      machine.succeed("mc mb minio/test-bucket")
      machine.succeed("${minioPythonScript}")
      assert "test-bucket" in machine.succeed("mc ls minio")
      assert "Test from Python" in machine.succeed("mc cat minio/test-bucket/test.txt")
      machine.shutdown()
    '';
  }
)
