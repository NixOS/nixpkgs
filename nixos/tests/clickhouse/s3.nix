{ pkgs, package, ... }:

let
  s3 = {
    bucket = "clickhouse-bucket";
    accessKey = "BKIKJAA5BMMU2RHO6IBB";
    secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
  };

  clickhouseS3StorageConfig = ''
    <clickhouse>
      <storage_configuration>
        <disks>
          <s3_disk>
            <type>s3</type>
            <endpoint>http://minio:9000/${s3.bucket}/</endpoint>
            <access_key_id>${s3.accessKey}</access_key_id>
            <secret_access_key>${s3.secretKey}</secret_access_key>
            <metadata_path>/var/lib/clickhouse/disks/s3_disk/</metadata_path>
          </s3_disk>
          <s3_cache>
            <type>cache</type>
            <disk>s3_disk</disk>
            <path>/var/lib/clickhouse/disks/s3_cache/</path>
            <max_size>10Gi</max_size>
          </s3_cache>
        </disks>
        <policies>
          <s3_main>
            <volumes>
              <main>
                <disk>s3_disk</disk>
              </main>
            </volumes>
          </s3_main>
        </policies>
      </storage_configuration>
    </clickhouse>
  '';
in
{
  name = "clickhouse-s3";
  meta.maintainers = with pkgs.lib.maintainers; [
    jpds
    thevar1able
  ];

  nodes = {
    clickhouse = {
      environment.etc = {
        "clickhouse-server/config.d/s3.xml" = {
          text = "${clickhouseS3StorageConfig}";
        };
      };

      services.clickhouse = {
        enable = true;
        inherit package;
      };
      virtualisation.diskSize = 15 * 1024;
      virtualisation.memorySize = 4 * 1024;
    };

    minio =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;
        networking.firewall.allowedTCPPorts = [ 9000 ];

        services.minio = {
          enable = true;
          inherit (s3) accessKey secretKey;
        };

        environment.systemPackages = [ pkgs.minio-client ];
      };
  };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      tableDDL = pkgs.writeText "ddl.sql" ''
        CREATE TABLE `demo` (
          `value` String
        )
        ENGINE = MergeTree
        ORDER BY value
        SETTINGS storage_policy = 's3_main';
      '';
      insertQuery = pkgs.writeText "insert.sql" "INSERT INTO `demo` (`value`) VALUES ('foo');";
      selectQuery = pkgs.writeText "select.sql" "SELECT * from `demo`";
    in
    ''
      minio.wait_for_unit("minio")
      minio.wait_for_open_port(9000)
      minio.succeed(
        "mc alias set minio "
        + "http://localhost:9000 "
        + "${s3.accessKey} ${s3.secretKey} --api s3v4",
        "mc mb minio/${s3.bucket}",
      )

      clickhouse.start()
      clickhouse.wait_for_unit("clickhouse.service")
      clickhouse.wait_for_open_port(9000)

      clickhouse.wait_until_succeeds(
        """
          journalctl -o cat -u clickhouse.service | grep "Merging configuration file '/etc/clickhouse-server/config.d/s3.xml'"
        """
      )

      clickhouse.succeed(
          "cat ${tableDDL} | clickhouse-client"
      )
      clickhouse.succeed(
          "cat ${insertQuery} | clickhouse-client"
      )
      clickhouse.succeed(
          "cat ${selectQuery} | clickhouse-client | grep foo"
      )

      minio.log(minio.succeed(
        "mc ls minio/${s3.bucket}",
      ))
    '';
}
