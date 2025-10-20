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

    localWithPostgres = {
      services.atticd = {
        enable = true;
        settings = {
          database = {
            url = "postgres:///atticd?host=/run/postgresql";
          };
        };

        inherit environmentFile;
      };

      services.postgresql = {
        enable = true;

        ensureDatabases = [ "atticd" ];
        ensureUsers = [
          {
            name = "atticd";
            ensureDBOwnership = true;
          }
        ];
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

      def check_push(node) -> None:
          node.wait_for_unit("atticd.service")
          token = node.succeed("atticd-atticadm make-token --sub stop --validity 1y --create-cache '*' --pull '*' --push '*' --delete '*' --configure-cache '*' --configure-cache-retention '*'").strip()

          node.succeed(f"attic login local http://localhost:8080 {token}")
          node.succeed("attic cache create test-cache")
          node.succeed("attic push test-cache ${environmentFile}")

      with subtest("local storage push"):
          check_push(local)

      with subtest("local storage with postgres db push"):
          localWithPostgres.wait_for_unit("postgresql.target")

          check_push(localWithPostgres)

      with subtest("s3 storage push"):
          s3.wait_for_unit("minio.service")
          s3.wait_for_open_port(9000)
          s3.succeed(
              "mc alias set minio "
              + "http://localhost:9000 "
              + "${accessKey} ${secretKey} --api s3v4",
              "mc mb minio/attic",
          )

          check_push(s3)
    '';
}
