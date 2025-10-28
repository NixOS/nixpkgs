{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.networkmanager;
  toml = pkgs.formats.toml { };

  enabled = (lib.length cfg.ensureProfiles.secrets.entries) > 0;

  nmFileSecretAgentConfig = {
    entry = builtins.map (
      i:
      {
        key = i.key;
        file = i.file;
      }
      // lib.optionalAttrs (i.matchId != null) { match_id = i.matchId; }
      // lib.optionalAttrs (i.matchUuid != null) { match_uuid = i.matchUuid; }
      // lib.optionalAttrs (i.matchType != null) { match_type = i.matchType; }
      // lib.optionalAttrs (i.matchIface != null) { match_iface = i.matchIface; }
      // lib.optionalAttrs (i.matchSetting != null) {
        match_setting = i.matchSetting;
      }
    ) cfg.ensureProfiles.secrets.entries;
  };
  nmFileSecretAgentConfigFile = toml.generate "config.toml" nmFileSecretAgentConfig;
in
{
  meta = {
    maintainers = [ lib.maintainers.lilioid ];
  };

  ####### interface
  options = {
    networking.networkmanager.ensureProfiles.secrets = {
      package = lib.mkPackageOption pkgs "nm-file-secret-agent" { };
      entries = lib.mkOption {
        description = ''
          A list of secrets to provide to NetworkManager by reading their values from configured files.

          Note that NetworkManager should be configured to read secrets from a secret agent.
          This can be done for example through the `networking.networkmanager.ensureProfiles.profiles` options.
        '';
        default = [ ];
        example = [
          {
            matchId = "My WireGuard VPN";
            matchType = "wireguard";
            matchSetting = "wireguard";
            key = "private-key";
            file = "/root/wireguard_key";
          }
        ];
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              matchId = lib.mkOption {
                description = ''
                  connection id used by NetworkManager. Often displayed as name in GUIs.

                  NetworkManager describes this as a human readable unique identifier for the connection, like "Work Wi-Fi" or "T-Mobile 3G".
                '';
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "wifi1";
              };
              matchUuid = lib.mkOption {
                description = ''
                  UUID of the connection profile

                  UUIDs are assigned once on connection creation and should never change as long as the connection still applies to the same network.
                '';
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "669ea4c9-4cb3-4901-ab52-f9606590976e";
              };
              matchType = lib.mkOption {
                description = ''
                  NetworkManager connection type

                  The NetworkManager configuration settings reference roughly corresponds to connection types.
                  More might be available on your system depending on the installed plugins.

                  <https://networkmanager.dev/docs/api/latest/ch01.html>
                '';
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "wireguard";
              };
              matchIface = lib.mkOption {
                description = "interface name of the NetworkManager connection";
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              matchSetting = lib.mkOption {
                description = "name of the setting section for which secrets are requested";
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              key = lib.mkOption {
                description = "key in the setting section for which this entry provides a value";
                type = lib.types.str;
              };
              file = lib.mkOption {
                description = "file from which the secret value is read";
                type = lib.types.str;
              };
            };
          }
        );
      };
    };
  };

  ####### implementation
  config = lib.mkIf enabled {
    # start nm-file-secret-agent if required
    systemd.services."nm-file-secret-agent" = {
      description = "NetworkManager secret agent that responds with the content of preconfigured files";
      documentation = [ "https://github.com/lilioid/nm-file-secret-agent/" ];
      requires = [ "NetworkManager.service" ];
      after = [ "NetworkManager.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ nmFileSecretAgentConfigFile ];
      script = "${lib.getExe cfg.ensureProfiles.secrets.package} --conf ${nmFileSecretAgentConfigFile}";
    };
  };
}
