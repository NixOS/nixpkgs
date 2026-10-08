{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  {
    config,
    lib,
    pkgs,
    ...
  }:
  let
    accessKey = "GK85bae09276df06d47a1ed2bf";
    secretKey = "eac031e3379beb05477a9c8381ade716c8f5860f1dffec915ae2a728a88c88c6";

    awsCfg = "${pkgs.writeText "aws.cfg" ''
      [default]
      endpoint_url=https://acme.test
      aws_access_key_id=${accessKey}
      aws_secret_access_key=${secretKey}
      region=garage
    ''}";
  in
  {
    inherit name;
    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes = {
      nextcloud =
        {
          pkgs,
          nodes,
          ...
        }:
        {
          services.nextcloud.config.dbtype = "sqlite";

          environment.variables.AWS_CONFIG_FILE = awsCfg;
          environment.variables.AWS_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";

          services.nextcloud.config.objectstore.s3 = {
            enable = true;
            bucket = "nextcloud";
            verify_bucket_exists = true;
            key = accessKey;
            secretFile = "${pkgs.writeText "secretKey" secretKey}";
            hostname = "acme.test";
            useSsl = true;
            port = 443;
            usePathStyle = true;
            region = "garage";
          };

          security.pki.certificates = [
            (builtins.readFile ../common/acme/server/ca.cert.pem)
          ];

          environment.systemPackages = [ pkgs.awscli2 ];

          # The dummy certs are for acme.test, so we pretend that's the FQDN
          # of the garage VM.
          networking.extraHosts = ''
            ${nodes.garage.networking.primaryIPAddress} acme.test
          '';
        };

      client =
        { pkgs, nodes, ... }:
        {
          environment.variables.AWS_CONFIG_FILE = awsCfg;
          environment.variables.AWS_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";
          environment.systemPackages = [ pkgs.awscli2 ];

          security.pki.certificates = [
            (builtins.readFile ../common/acme/server/ca.cert.pem)
          ];
          networking.extraHosts = ''
            ${nodes.garage.networking.primaryIPAddress} acme.test
          '';
        };

      garage =
        { pkgs, ... }:
        {
          security.pki.certificates = [
            (builtins.readFile ../common/acme/server/ca.cert.pem)
          ];

          services.garage = {
            enable = true;
            package = pkgs.garage_2;
            settings = {
              rpc_bind_addr = "[::]:3901";
              rpc_public_addr = "[::]:3901";
              rpc_secret = "81e5ab61625a5097c5953a09a16a524479c290ca01921560704395b830ad248d";
              replication_factor = 1;

              s3_api = {
                s3_region = "garage";
                api_bind_addr = "[::]:3900";
              };
            };
          };

          services.nginx = {
            enable = true;
            recommendedProxySettings = true;

            virtualHosts."acme.test" = {
              onlySSL = true;
              sslCertificate = ../common/acme/server/acme.test.cert.pem;
              sslCertificateKey = ../common/acme/server/acme.test.key.pem;
              locations."/".proxyPass = "http://127.0.0.1:3900";
            };
          };

          networking.extraHosts = ''
            127.0.0.1 acme.test
          '';

          environment.systemPackages = [ pkgs.gawk ];

          virtualisation.diskSize = 2 * 1024;

          networking.firewall.allowedTCPPorts = [
            3900
            80
            443
          ];
        };
    };

    test-helpers.provision = ''
      garage.start()
      garage.wait_for_open_port(3900)
      garage.wait_for_unit("nginx.service")
      garage.wait_for_open_port(443)

      node_id = garage.succeed("garage status | tail -n1 | awk '{ print $1 }'")
      garage.succeed(
          "garage status",
          f"garage layout assign -c 1GB -z garage {node_id}",
          "garage layout apply --version 1",
          "garage key import ${accessKey} ${secretKey} --yes",
          "garage bucket create nextcloud",
          "garage key list >&2",
          "garage bucket allow --read --write --owner nextcloud --key ${accessKey}"
      )
    '';

    test-helpers.extraTests =
      { nodes, ... }:
      ''

        with subtest("File is not on the filesystem"):
            nextcloud.succeed("test ! -e ${nodes.nextcloud.services.nextcloud.home}/data/root/files/test-shared-file")

        with subtest("Check if file is in S3"):
            files = [
                f.rsplit(' ', 2)
                for f in nextcloud.succeed('aws s3 ls s3://nextcloud/|sort').strip().split('\n')
            ]
            print(files)

            # Cannot assert an exact number here, nc27 writes more stuff initially into S3.
            # For now let's assume it's always the most recently added file.
            assert len(files) > 0, f"""
              Expected to have at least one object in garage/nextcloud. But `mc ls` gave output:

              '{files}'
            """

            _, size, file = files[-1]

            assert size == "3", f"""
              Expected size of uploaded file to be 3 bytes, got {size}
            """

            assert file.startswith('urn:oid'), """
              Expected filename to start with 'urn:oid', instead got '{file}.
            """

        with subtest("Test download from S3"):
            client.succeed(
                f"aws s3 cp s3://nextcloud/{file} test "
                + "--ca-bundle /etc/ssl/certs/ca-bundle.crt"
            )

            client.succeed("test hi = $(cat test)")
      '';
  }
)
