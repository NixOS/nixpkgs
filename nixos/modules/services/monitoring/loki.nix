{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.loki;

  prettyJSON =
    conf:
    pkgs.runCommand "loki-config.json" { } ''
      echo '${builtins.toJSON conf}' | ${pkgs.jq}/bin/jq 'del(._module)' > $out
    '';

in
{
  options.services.loki = {
    enable = mkEnableOption "loki";

    user = mkOption {
      type = types.str;
      default = "loki";
      description = ''
        User under which the Loki service runs.
      '';
    };

    package = lib.mkPackageOption pkgs "grafana-loki" { };

    group = mkOption {
      type = types.str;
      default = "loki";
      description = ''
        Group under which the Loki service runs.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/loki";
      description = ''
        Specify the directory for Loki.
      '';
    };

    configuration = mkOption {
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Specify the configuration for Loki in Nix.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify a configuration file that Loki should use.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--server.http-listen-port=3101" ];
      description = ''
        Specify a list of additional command line flags,
        which get escaped and are then passed to Loki.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (
          (cfg.configuration == { } -> cfg.configFile != null)
          && (cfg.configFile != null -> cfg.configuration == { })
        );
        message = ''
          Please specify either
          'services.loki.configuration' or
          'services.loki.configFile'.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ]; # logcli

    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "Loki Service User";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services.loki = {
      description = "Loki Service Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig =
        let
          conf =
            if cfg.configFile == null then
              # Config validation may fail when using extraFlags = [ "-config.expand-env=true" ].
              # To work around this, we simply skip it when extraFlags is not empty.
              if cfg.extraFlags == [ ] then
                validateConfig (prettyJSON cfg.configuration)
              else
                prettyJSON cfg.configuration
            else
              cfg.configFile;
          validateConfig =
            file:
            pkgs.runCommand "validate-loki-conf"
              {
                nativeBuildInputs = [ cfg.package ];
              }
              ''
                loki -verify-config -config.file "${file}"
                ln -s "${file}" "$out"
              '';
        in
        {
          ExecStart = "${cfg.package}/bin/loki --config.file=${conf} ${escapeShellArgs cfg.extraFlags}";
          User = cfg.user;
          Restart = "always";
          PrivateTmp = true;
          ProtectHome = true;
          ProtectSystem = "full";
          DevicePolicy = "closed";
          NoNewPrivileges = true;
          WorkingDirectory = cfg.dataDir;
        };
    };
  };
}
