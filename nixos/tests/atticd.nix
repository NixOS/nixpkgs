{ lib, pkgs, ... }:

let
  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";

  minioCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';
  environmentFile = pkgs.runCommand "atticd-env" { } ''
    echo ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="$(${lib.getExe pkgs.openssl} genrsa -traditional 4096 | ${pkgs.coreutils}/bin/base64 -w0)" > $out
  '';
in

{
  name = "atticd";

  nodes = {
    local = {
      services.atticd = {
        enable = true;

        inherit environmentFile;
      };

      environment.systemPackages = [
        pkgs.attic-client
      ];
    };

    s3 = {
      services.atticd = {
        enable = true;
        settings = {
          storage = {
            type = "s3";
            bucket = "attic";
            region = "us-east-1";
            endpoint = "http://127.0.0.1:9000";

            credentials = {
              access_key_id = accessKey;
              secret_access_key = secretKey;
            };
          };
        };

        inherit environmentFile;
      };

      services.minio = {
        enable = true;
        rootCredentialsFile = minioCredentialsFile;
      };

      environment.systemPackages = [
        pkgs.attic-client
        pkgs.minio-client
      ];
    };
  };

  testScript = # python
    ''
      start_all()

      with subtest("local storage push"):
          local.wait_for_unit("atticd.service")
          token = local.succeed("atticd-atticadm make-token --sub stop --validity 1y --create-cache '*' --pull '*' --push '*' --delete '*' --configure-cache '*' --configure-cache-retention '*'").strip()

          local.succeed(f"attic login local http://localhost:8080 {token}")
          local.succeed("attic cache create test-cache")
          local.succeed("attic push test-cache ${environmentFile}")

      with subtest("s3 storage push"):
          s3.wait_for_unit("atticd.service")
          s3.wait_for_unit("minio.service")
          s3.wait_for_open_port(9000)
          s3.succeed(
              "mc config host add minio "
              + "http://localhost:9000 "
              + "${accessKey} ${secretKey} --api s3v4",
              "mc mb minio/attic",
          )
          token = s3.succeed("atticd-atticadm make-token --sub stop --validity 1y --create-cache '*' --pull '*' --push '*' --delete '*' --configure-cache '*' --configure-cache-retention '*'").strip()

          s3.succeed(f"attic login s3 http://localhost:8080 {token}")
          s3.succeed("attic cache create test-cache")
          s3.succeed("attic push test-cache ${environmentFile}")
    '';
}
