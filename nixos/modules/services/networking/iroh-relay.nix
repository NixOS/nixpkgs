{
  pkgs,
  lib,
  config,
  ...
}:

let
  format = pkgs.formats.toml { };

  cfg = config.services.iroh-relay;

  tomlFormat = pkgs.formats.toml { };
in
{
  options.services.iroh-relay = {
    enable = lib.mkEnableOption "iroh-relay";

    package = lib.mkPackageOption pkgs "iroh-relay" { };

    dev_mode = lib.mkOption {
      description = "Pass the --dev argument to the iroh-relay binary";
      type = lib.types.bool;
      default = false;
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      description = "See [iroh-relay configuration](https://github.com/n0-computer/iroh/tree/main/iroh-relay)";
      example = {
        enable_relay = true;
        http_bind_addr = "[::]:3340";
        limits = {
          access_conn_limit = 1000;
          accept_conn_burst = 1200;
          client.rx = {
            bytes_per_second = 1024;
            max_burst_bytes = 2048;
          };
        };
      };
    };

    user = lib.mkOption {
      description = "The user under which the relay should run";
      type = lib.types.str;
      default = "iroh-relay";
    };

    group = lib.mkOption {
      description = "The group under which the relay should run";
      type = lib.types.str;
      default = "iroh-relay";
    };

    logLevel = lib.mkOption {
      type = lib.types.str;
      default = "info";
      description = ''
        The log level for the firezone application. See
        [RUST_LOG](https://docs.rs/env_logger/latest/env_logger/#enabling-logging)
        for the format.
      '';
    };

    openHttpPort = lib.mkOption {
      description = "Whether to open the HTTP port for the iroh-relay";
      type = lib.types.bool;
      default = false;
    };

    openQuicPort = lib.mkOption {
      description = "Whether to open the QUIC port for the iroh-relay";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "${cfg.group}";
    };

    users.groups."${cfg.group}" = { };

    networking.firewall.allowedTCPPorts =
      let
        httpPort =
          if !isNull cfg.settings.http_bind_addr then
            pkgs.lib.pipe cfg.settings.http_bind_addr [
              (pkgs.lib.strings.splitString ":")
              pkgs.lib.lists.reverseList
              builtins.head
              pkgs.lib.toInt
            ]
          else if cfg.dev_mode then
            3340
          else
            80;
      in
      (lib.optionals cfg.openHttpPort [ httpPort ]) ++ (lib.optionals cfg.openQuicPort [ 7824 ]);

    systemd.services.iroh-relay = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig =
        let
          devFlag = lib.optionalString cfg.dev_mode "--dev";
          configFile = format.generate "config.toml" cfg.settings;
        in
        {
          Type = "simple";
          Environment = [
            "RUST_LOG=${cfg.logLevel}"
          ];
          ExecStart = "${pkgs.lib.getExe cfg.package} --config-path=${configFile} ${devFlag}";

          User = "${cfg.user}";
          Group = "${cfg.group}";

          RuntimeDirectory = "iroh-relay";
          StateDirectory = "iroh-relay";
          ConfigurationDirectory = "iroh-relay";

          PrivateTmp = true;
          PrivateDevices = true;
          PrivateIPC = true;
          ProtectControlGroups = true;
          RemoveIPC = true;

          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
        };
    };
  };
}
