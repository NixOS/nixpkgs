{ pkgs, package, ... }:

let
  s3 = {
    bucket = "clickhouse-bucket";
    accessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
    secretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  };

  clickhouseS3StorageConfig = ''
    <clickhouse>
      <storage_configuration>
        <disks>
          <s3_disk>
            <type>s3</type>
            <endpoint>http://garage:9000/${s3.bucket}/</endpoint>
            <access_key_id>${s3.accessKey}</access_key_id>
            <secret_access_key>${s3.secretKey}</secret_access_key>
            <region>garage</region>
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
  name = "clickhouse-${package.version}-s3";
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

    garage =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;
        networking.firewall.allowedTCPPorts = [ 9000 ];

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
              api_bind_addr = "0.0.0.0:9000";
            };
          };
        };
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
      garage.wait_for_unit("garage.service")
      garage.wait_for_open_port(3901)
      garage_node_id = garage.succeed("garage status | tail -n1 | awk '{ print $1 }'")
      garage.succeed(
          f"garage layout assign -c 100MB -z garage {garage_node_id}",
          "garage layout apply --version 1",
          "garage key import ${s3.accessKey} ${s3.secretKey} --yes",
          "garage bucket create ${s3.bucket}",
          "garage bucket allow --read --write --owner ${s3.bucket} --key ${s3.accessKey}",
      )
      garage.wait_for_open_port(9000)

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
    '';
}
