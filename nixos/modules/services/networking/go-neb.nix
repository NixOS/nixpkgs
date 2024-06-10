{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.go-neb;

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "config.yaml" cfg.config;
in {
  options.services.go-neb = {
    enable = mkEnableOption "an extensible matrix bot written in Go";

    bindAddress = mkOption {
      type = types.str;
      description = "Port (and optionally address) to listen on.";
      default = ":4050";
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/go-neb.env";
      description = ''
        Environment variables from this file will be interpolated into the
        final config file using envsubst with this syntax: `$ENVIRONMENT`
        or `''${VARIABLE}`.
        The file should contain lines formatted as `SECRET_VAR=SECRET_VALUE`.
        This is useful to avoid putting secrets into the nix store.
      '';
    };

    baseUrl = mkOption {
      type = types.str;
      description = "Public-facing endpoint that can receive webhooks.";
    };

    config = mkOption {
      inherit (settingsFormat) type;
      description = ''
        Your {file}`config.yaml` as a Nix attribute set.
        See [config.sample.yaml](https://github.com/matrix-org/go-neb/blob/master/config.sample.yaml)
        for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.go-neb = let
      finalConfigFile = if cfg.secretFile == null then configFile else "/var/run/go-neb/config.yaml";
    in {
      description = "Extensible matrix bot written in Go";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        BASE_URL = cfg.baseUrl;
        BIND_ADDRESS = cfg.bindAddress;
        CONFIG_FILE = finalConfigFile;
      };

      serviceConfig = {
        ExecStartPre = lib.optional (cfg.secretFile != null)
          ("+" + pkgs.writeShellScript "pre-start" ''
            umask 077
            export $(xargs < ${cfg.secretFile})
            ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > ${finalConfigFile}
            chown go-neb ${finalConfigFile}
          '');
        RuntimeDirectory = "go-neb";
        ExecStart = "${pkgs.go-neb}/bin/go-neb";
        User = "go-neb";
        DynamicUser = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ hexa maralorn ];
}
