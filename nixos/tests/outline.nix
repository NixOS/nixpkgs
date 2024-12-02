import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
  secretKeyFile = pkgs.writeText "outline-secret-key" ''
    ${secretKey}
  '';
  rootCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';
in
{
  name = "outline";

  meta.maintainers = lib.teams.cyberus.members;

  nodes = {
    outline = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = [ pkgs.minio-client ];
      services.outline = {
        enable = true;
        forceHttps = false;
        storage = {
          inherit accessKey secretKeyFile;
          uploadBucketUrl = "http://localhost:9000";
          uploadBucketName = "outline";
          region = config.services.minio.region;
        };
      };
      services.minio = {
        enable = true;
        inherit rootCredentialsFile;
      };
    };
  };

  testScript =
    ''
      machine.wait_for_unit("minio.service")
      machine.wait_for_open_port(9000)

      # Create a test bucket on the server
      machine.succeed(
          "mc config host add minio http://localhost:9000 ${accessKey} ${secretKey} --api s3v4"
      )
      machine.succeed("mc mb minio/outline")

      outline.wait_for_unit("outline.service")
      outline.wait_for_open_port(3000)
      outline.succeed("curl --fail http://localhost:3000/")
    '';
})
