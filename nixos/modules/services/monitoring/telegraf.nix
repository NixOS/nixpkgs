{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.telegraf;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "config.toml" cfg.extraConfig;
in
{
  ###### interface
  options = {
    services.telegraf = {
      enable = mkEnableOption "telegraf server";

      package = mkPackageOption pkgs "telegraf" { };

      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/keys/telegraf.env" ];
        description = ''
          File to load as environment file. Environment variables from this file
          will be interpolated into the config file using envsubst with this
          syntax: `$ENVIRONMENT` or `''${VARIABLE}`.
          This is useful to avoid putting secrets into the nix store.
        '';
      };

      extraConfig = mkOption {
        default = { };
        description = "Extra configuration options for telegraf";
        type = settingsFormat.type;
        example = {
          outputs.influxdb = {
            urls = [ "http://localhost:8086" ];
            database = "telegraf";
          };
          inputs.statsd = {
            service_address = ":8125";
            delete_timings = true;
          };
        };
      };
    };
  };

  ###### implementation
  config = mkIf config.services.telegraf.enable {
    services.telegraf.extraConfig = {
      inputs = { };
      outputs = { };
    };
    systemd.services.telegraf =
      let
        finalConfigFile =
          if config.services.telegraf.environmentFiles == [ ] then
            configFile
          else
            "/var/run/telegraf/config.toml";
      in
      {
        description = "Telegraf Agent";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        path = lib.optional (config.services.telegraf.extraConfig.inputs ? procstat) pkgs.procps;
        serviceConfig = {
          EnvironmentFile = config.services.telegraf.environmentFiles;
          ExecStartPre = lib.optional (config.services.telegraf.environmentFiles != [ ]) (
            pkgs.writeShellScript "pre-start" ''
              umask 077
              ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > /var/run/telegraf/config.toml
            ''
          );
          ExecStart = "${cfg.package}/bin/telegraf -config ${finalConfigFile}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          RuntimeDirectory = "telegraf";
          User = "telegraf";
          Group = "telegraf";
          Restart = "on-failure";
          # for ping probes
          AmbientCapabilities = [ "CAP_NET_RAW" ];
        };
      };

    users.users.telegraf = {
      uid = config.ids.uids.telegraf;
      group = "telegraf";
      description = "telegraf daemon user";
    };

    users.groups.telegraf = { };
  };
}
