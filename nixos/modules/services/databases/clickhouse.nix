{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.clickhouse;
  format = pkgs.formats.yaml { };

  serverConfigFile = format.generate "config.yaml" cfg.serverConfig;
  usersConfigFile = format.generate "users.yaml" cfg.usersConfig;
in
{

  meta.maintainers = [ "thevar1able" ];

  ###### interface

  options = {

    services.clickhouse = {

      enable = lib.mkEnableOption "ClickHouse database server";

      package = lib.mkPackageOption pkgs "clickhouse" {
        example = "pkgs.clickhouse-lts";
      };

      serverConfig = lib.mkOption {
        type = format.type;
        default = { };
        example = lib.literalExpression ''
          {
            http_port = 8123;
            tcp_port = 9000;

            remote_servers = {
              default = {
                shard = {
                  replica = [
                    { host = "::"; port = "9000"; }
                    { host = "::"; port = "9001"; }
                    { host = "::"; port = "9002"; }
                  ];
                };
              };
            };
          }
        '';
        description = ''
          Your {file}`config.yaml` as a Nix attribute set.
          Check the [documentation](https://clickhouse.com/docs/operations/configuration-files)
          for possible options.
        '';
      };

      usersConfig = lib.mkOption {
        type = format.type;
        default = { };
        example = lib.literalExpression ''
          {
            profiles = {};

            users = {
              default = {
                profile = "default";
                password_sha256_hex = "36dd292533174299fb0c34665df468bb881756ca9eaf9757d0cfde38f9ededa1";  # `echo -n verysecret | sha256sum`
              };
            };
          }
        '';
        description = ''
          Your {file}`users.yaml` as a Nix attribute set.
          Check the [documentation](https://clickhouse.com/docs/operations/configuration-files#user-settings)
          for possible options.
        '';
      };

      extraServerConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          <clickhouse>
            <max_connections>500</max_connections>
            <keep_alive_timeout>3</keep_alive_timeout>
          </clickhouse>
        '';
        description = "Additional raw XML configuration for ClickHouse server.";
      };

      extraUsersConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          <clickhouse>
            <users>
              <readonly>
                <profile>readonly</profile>
              </readonly>
            </users>
          </clickhouse>
        '';
        description = "Additional raw XML configuration for ClickHouse server.";
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users.clickhouse = {
      name = "clickhouse";
      uid = config.ids.uids.clickhouse;
      group = "clickhouse";
      description = "ClickHouse server user";
    };

    users.groups.clickhouse.gid = config.ids.gids.clickhouse;

    systemd.services.clickhouse = {
      description = "ClickHouse server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "notify";
        User = "clickhouse";
        Group = "clickhouse";
        AmbientCapabilities = "CAP_SYS_NICE";
        StateDirectory = "clickhouse";
        ExecStart = "${cfg.package}/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml";
        TimeoutStartSec = "infinity";
      };

      environment = {
        # Switching off watchdog is very important for sd_notify to work correctly.
        CLICKHOUSE_WATCHDOG_ENABLE = "0";
      };
    };

    environment.etc = {
      "clickhouse-server/config.xml" = {
        source = "${cfg.package}/etc/clickhouse-server/config.xml";
      };

      "clickhouse-server/users.xml" = {
        source = "${cfg.package}/etc/clickhouse-server/users.xml";
      };

      "clickhouse-server/config.d/100-nixos-module-config.yaml" = lib.mkIf (cfg.serverConfig != { }) {
        source = serverConfigFile;
      };

      "clickhouse-server/users.d/100-nixos-module-config.yaml" = lib.mkIf (cfg.usersConfig != { }) {
        source = usersConfigFile;
      };

      "clickhouse-server/config.d/200-nixos-module-extra-config.xml" =
        lib.mkIf (cfg.extraServerConfig != "")
          {
            text = cfg.extraServerConfig;
          };

      "clickhouse-server/users.d/200-nixos-module-extra-config.xml" =
        lib.mkIf (cfg.extraUsersConfig != "")
          {
            text = cfg.extraUsersConfig;
          };
    };

    environment.systemPackages = [ cfg.package ];

    # startup requires a `/etc/localtime` which only if exists if `time.timeZone != null`
    time.timeZone = lib.mkDefault "UTC";

  };

}
