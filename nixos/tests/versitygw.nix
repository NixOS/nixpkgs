{ pkgs, ... }:

let
  # Public fixtures only; production credentials must never enter the store.
  rootEnvironment = pkgs.writeText "versitygw-test.env" ''
    ROOT_ACCESS_KEY=fixture-root
    ROOT_SECRET_KEY=fixture-root-secret
  '';
  users = pkgs.writeText "versitygw-test-users.json" (
    builtins.toJSON {
      accessAccounts.fixture-reader = {
        access = "fixture-reader";
        secret = "fixture-reader-secret";
        role = "user";
        userID = 1001;
        groupID = 1001;
        projectID = 0;
      };
    }
  );
  checkS3 =
    pkgs.writers.writePython3 "versitygw-check-s3"
      {
        libraries = [ pkgs.python3Packages.boto3 ];
      }
      ''
        import json
        import sys

        import boto3
        from botocore.config import Config
        from botocore.exceptions import ClientError


        def client(access, secret):
            return boto3.client(
                "s3", endpoint_url="http://127.0.0.1:7070",
                region_name="us-east-1", aws_access_key_id=access,
                aws_secret_access_key=secret,
                config=Config(s3={"addressing_style": "path"}),
            )


        root = client("fixture-root", "fixture-root-secret")
        reader = client("fixture-reader", "fixture-reader-secret")
        bucket = "test-bucket"
        if sys.argv[1] == "external-storage":
            root.create_bucket(Bucket=bucket)
            root.put_bucket_versioning(
                Bucket=bucket, VersioningConfiguration={"Status": "Enabled"},
            )
            first = root.put_object(
                Bucket=bucket, Key="versioned", Body=b"first",
                Metadata={"revision": "first"},
            )["VersionId"]
            second = root.put_object(
                Bucket=bucket, Key="versioned", Body=b"second",
                Metadata={"revision": "second"},
            )["VersionId"]
            assert first != second
            for version, body in [(first, b"first"), (second, b"second")]:
                response = root.get_object(
                    Bucket=bucket, Key="versioned", VersionId=version,
                )
                assert response["Body"].read() == body
                assert response["Metadata"] == {"revision": body.decode()}
            sys.exit(0)
        if sys.argv[1] == "create":
            root.create_bucket(Bucket=bucket)
            root.put_object(Bucket=bucket, Key="hello", Body=b"hello, S3")
            root.put_bucket_policy(Bucket=bucket, Policy=json.dumps({
                "Version": "2012-10-17",
                "Statement": [{
                    "Effect": "Allow",
                    "Principal": {"AWS": ["fixture-reader"]},
                    "Action": ["s3:GetObject"],
                    "Resource": ["arn:aws:s3:::test-bucket/*"],
                }],
            }))
        assert bucket in [item["Name"] for item in root.list_buckets()["Buckets"]]
        response = reader.get_object(Bucket=bucket, Key="hello")
        assert response["Body"].read() == b"hello, S3"
        try:
            reader.put_object(Bucket=bucket, Key="forbidden", Body=b"no")
        except ClientError as error:
            assert error.response["Error"]["Code"] == "AccessDenied"
        else:
            raise AssertionError("read-only account could write an object")
      '';
in
{
  name = "versitygw";

  nodes.machine = {
    virtualisation.memorySize = 1024;
    services.versitygw = {
      enable = true;
      rootDirectory = "/srv/versitygw data";
      environmentFile = "/run/versitygw-test/root.env";
      usersFile = "/run/versitygw-test/users.json";
      settings = {
        VGW_PORT = "127.0.0.1:7070";
        VGW_QUIET = true;
        VGW_MAX_REQUESTS = 100;
        VGW_UNUSED = null;
      };
    };
    systemd.tmpfiles.rules = [
      "d /run/versitygw-test 0700 root root -"
      "C /run/versitygw-test/root.env 0600 root root - ${rootEnvironment}"
      "C /run/versitygw-test/users.json 0600 root root - ${users}"
    ];
  };

  nodes.unseeded = {
    virtualisation.memorySize = 1024;
    services.versitygw = {
      enable = true;
      rootDirectory = "/srv/versitygw";
      environmentFile = "/run/versitygw-test/root.env";
      settings = {
        VGW_PORT = "127.0.0.1:7070";
        VGW_META_SIDECAR = "/srv/s3-metadata";
        VGW_VERSIONING_DIR = "/srv/s3-versions";
      };
    };
    systemd.tmpfiles.rules = [
      "d /run/versitygw-test 0700 root root -"
      "C /run/versitygw-test/root.env 0600 root root - ${rootEnvironment}"
      "d /srv/s3-metadata 0750 versitygw versitygw -"
      "d /srv/s3-versions 0750 versitygw versitygw -"
    ];
    systemd.services.versitygw.serviceConfig.ReadWritePaths = [
      "/srv/s3-metadata"
      "/srv/s3-versions"
    ];
  };

  testScript = ''
    start_all()
    unseeded.wait_for_unit("versitygw.service")
    unseeded.wait_for_open_port(7070, timeout=60)
    unseeded.succeed("test -d /var/lib/versitygw/iam")
    machine.wait_for_unit("versitygw.service")
    machine.wait_for_open_port(7070)

    with subtest("external sidecar metadata and version storage"):
        unseeded.succeed("${checkS3} external-storage")
        unseeded.succeed("test -n \"$(find /srv/s3-metadata -type f -print -quit)\"")
        unseeded.succeed("test -n \"$(find /srv/s3-versions -type f -print -quit)\"")

    with subtest("runtime credentials, IAM seeding and S3 access"):
        machine.fail("runuser -u versitygw -- test -r /run/versitygw-test/users.json")
        assert machine.succeed("stat -c '%U:%G:%a' /var/lib/versitygw/iam/users.json").strip() == "versitygw:versitygw:600"
        machine.succeed("${checkS3} create")
        machine.succeed("test -f '/srv/versitygw data/test-bucket/hello'")

    with subtest("restart preserves objects and restores the declared account set"):
        machine.succeed("printf '%s' '{\"accessAccounts\":{}}' > /var/lib/versitygw/iam/users.json")
        machine.succeed("systemctl restart versitygw.service")
        machine.wait_for_unit("versitygw.service")
        machine.wait_for_open_port(7070)
        machine.succeed("${checkS3} verify")

    with subtest("IAM symlink cannot modify a root-owned directory"):
        machine.succeed("systemctl stop versitygw.service")
        machine.succeed("mkdir -m 0755 /root/iam-target; echo sentinel > /root/iam-target/users.json")
        machine.succeed("mv /var/lib/versitygw/iam /var/lib/versitygw/iam-backup")
        machine.succeed("runuser -u versitygw -- ln -s /root/iam-target /var/lib/versitygw/iam")
        status, _ = machine.execute("systemctl start versitygw.service")
        assert status != 0
        assert machine.succeed("stat -c '%U:%G:%a' /root/iam-target").strip() == "root:root:755"
        assert machine.succeed("cat /root/iam-target/users.json").strip() == "sentinel"

    machine.shutdown()
    unseeded.shutdown()
  '';
}
