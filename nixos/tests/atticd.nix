{ lib, pkgs, ... }:

let
  accessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
  secretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  s3Addr = "127.0.0.1:9000";

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
            region = "garage";
            endpoint = "http://${s3Addr}";

            credentials = {
              access_key_id = accessKey;
              secret_access_key = secretKey;
            };
          };
        };

        inherit environmentFile;
      };

      services.garage = {
        enable = true;
        package = pkgs.garage_2;
        settings = {
          rpc_bind_addr = "127.0.0.1:3901";
          rpc_public_addr = "127.0.0.1:3901";
          rpc_secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
          replication_factor = 1;

          s3_api = {
            s3_region = "garage";
            api_bind_addr = s3Addr;
          };
        };
      };

      environment.systemPackages = [
        pkgs.attic-client
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
          s3.wait_for_unit("garage.service")
          s3.wait_for_open_port(3901)
          garage_node_id = s3.succeed("garage status | tail -n1 | awk '{ print $1 }'")
          s3.succeed(
              f"garage layout assign -c 100MB -z garage {garage_node_id}",
              "garage layout apply --version 1",
              "garage key import ${accessKey} ${secretKey} --yes",
              "garage bucket create attic",
              "garage bucket allow --read --write --owner attic --key ${accessKey}"
          )

          s3.wait_for_unit("atticd.service")
          s3.wait_for_open_port(9000)
          token = s3.succeed("atticd-atticadm make-token --sub stop --validity 1y --create-cache '*' --pull '*' --push '*' --delete '*' --configure-cache '*' --configure-cache-retention '*'").strip()

          s3.succeed(f"attic login s3 http://localhost:8080 {token}")
          s3.succeed("attic cache create test-cache")
          s3.succeed("attic push test-cache ${environmentFile}")
    '';
}
