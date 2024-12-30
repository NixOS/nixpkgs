import ./make-test-python.nix ({ pkgs, ... }:
  let
    tls-cert =
      pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
        openssl req \
          -x509 -newkey rsa:4096 -sha256 -days 365 \
          -nodes -out cert.pem -keyout key.pem \
          -subj '/CN=minio' -addext "subjectAltName=DNS:localhost"

        mkdir -p $out
        cp key.pem cert.pem $out
      '';

    rootUser = "abc"; # intentionally as short as the minimum length we document
    rootPassword = "12345678"; # intentionally as short as the minimum length we document
    minioPythonScript = pkgs.writeScript "minio-test.py" ''
      #! ${pkgs.python3.withPackages(ps: [ ps.minio ])}/bin/python
      import io
      import os
      import sys
      from minio import Minio

      if len(sys.argv) > 1 and sys.argv[1] == 'tls':
        tls = True
      else:
        tls = False

      minioClient = Minio('localhost:9000',
                    access_key='${rootUser}',
                    secret_key='${rootPassword}',
                    secure=tls,
                    cert_check=False)
      sio = io.BytesIO()
      sio.write(b'Test from Python')
      sio.seek(0, os.SEEK_END)
      sio_len = sio.tell()
      sio.seek(0)
      minioClient.put_object('test-bucket', 'test.txt', sio, sio_len, content_type='text/plain')
    '';
    rootPasswordFile = "/etc/nixos/minio-root-password";
  in
  {
    name = "minio";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bachp ];
    };

    nodes = {
      machine = { pkgs, ... }: {
        services.minio = {
          enable = true;
          inherit rootUser rootPasswordFile;
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
      machine.copy_from_host("${rootPassword}", "${rootPasswordFile}")

      # Test non-TLS server
      machine.wait_for_unit("minio.service")
      machine.wait_for_open_port(9000)

      # Create a test bucket on the server
      machine.succeed(
          "mc config host add minio http://localhost:9000 ${rootUser} ${rootPassword} --api s3v4"
      )
      machine.succeed("mc mb minio/test-bucket")
      machine.succeed("${minioPythonScript}")
      assert "test-bucket" in machine.succeed("mc ls minio")
      assert "Test from Python" in machine.succeed("mc cat minio/test-bucket/test.txt")
      machine.succeed("mc rb --force minio/test-bucket")
      machine.systemctl("stop minio.service")

      # Test TLS server
      machine.copy_from_host("${tls-cert}/cert.pem", "/var/lib/minio/certs/public.crt")
      machine.copy_from_host("${tls-cert}/key.pem", "/var/lib/minio/certs/private.key")

      machine.systemctl("start minio.service")
      machine.wait_for_unit("minio.service")
      machine.wait_for_open_port(9000)

      # Create a test bucket on the server
      machine.succeed(
          "mc config host add minio https://localhost:9000 ${rootUser} ${rootPassword} --api s3v4"
      )
      machine.succeed("mc --insecure mb minio/test-bucket")
      machine.succeed("${minioPythonScript} tls")
      assert "test-bucket" in machine.succeed("mc --insecure ls minio")
      assert "Test from Python" in machine.succeed("mc --insecure cat minio/test-bucket/test.txt")
      machine.succeed("mc --insecure rb --force minio/test-bucket")

      machine.shutdown()
    '';
  })
