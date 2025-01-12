{ name, pkgs, testBase, system, ... }:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest ({ config, lib, ... }: let
  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";

  rootCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';
in {
  inherit name;
  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ma27 ];
  };

  imports = [ testBase ];

  nodes = {
    nextcloud = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 9000 ];
      environment.systemPackages = [ pkgs.minio-client ];

      services.nextcloud.config.objectstore.s3 = {
        enable = true;
        bucket = "nextcloud";
        autocreate = true;
        key = accessKey;
        secretFile = "${pkgs.writeText "secretKey" secretKey}";
        hostname = "nextcloud";
        useSsl = false;
        port = 9000;
        usePathStyle = true;
        region = "us-east-1";
      };

      services.minio = {
        enable = true;
        listenAddress = "0.0.0.0:9000";
        consoleAddress = "0.0.0.0:9001";
        inherit rootCredentialsFile;
      };
    };
  };

  test-helpers.init = ''
    nextcloud.wait_for_open_port(9000)
  '';

  test-helpers.extraTests = { nodes, ... }: ''
    with subtest("File is not on the filesystem"):
        nextcloud.succeed("test ! -e ${nodes.nextcloud.services.nextcloud.home}/data/root/files/test-shared-file")

    with subtest("Check if file is in S3"):
        nextcloud.succeed(
            "mc config host add minio http://localhost:9000 ${accessKey} ${secretKey} --api s3v4"
        )
        files = nextcloud.succeed('mc ls minio/nextcloud|sort').strip().split('\n')

        # Cannot assert an exact number here, nc27 writes more stuff initially into S3.
        # For now let's assume it's always the most recently added file.
        assert len(files) > 0, f"""
          Expected to have at least one object in minio/nextcloud. But `mc ls` gave output:

          '{files}'
        """

        import re
        ptrn = re.compile("^\[[A-Z0-9 :-]+\] +(?P<details>[A-Za-z0-9 :]+)$")
        match = ptrn.match(files[-1].strip())
        assert match, "Cannot match mc client output!"
        size, type_, file = tuple(match.group('details').split(' '))

        assert size == "3B", f"""
          Expected size of uploaded file to be 3 bytes, got {size}
        """

        assert type_ == 'STANDARD', f"""
          Expected type of bucket entry to be a file, i.e. 'STANDARD'. Got {type_}
        """

        assert file.startswith('urn:oid'), """
          Expected filename to start with 'urn:oid', instead got '{file}.
        """

    with subtest("Test download from S3"):
        client.succeed(
            "env AWS_ACCESS_KEY_ID=${accessKey} AWS_SECRET_ACCESS_KEY=${secretKey} "
            + f"${lib.getExe pkgs.awscli2} s3 cp s3://nextcloud/{file} test --endpoint-url http://nextcloud:9000 "
            + "--region us-east-1"
        )

        client.succeed("test hi = $(cat test)")
  '';
})
