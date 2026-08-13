{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) types;

  cfg = config.services.nebula-lighthouse-service;
  settingsFormat = pkgs.formats.yaml { };
in
{

  options.services.nebula-lighthouse-service = {
    enable = lib.mkEnableOption "nebula-lighthouse-service";
    user = lib.mkOption {
      type = types.str;
      default = "nebula-lighthouse";
      description = ''
        The user and group to run nebula-lighthouse-service as.
      '';
      example = "nebula-lighthouse";
    };
    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for nebula-lighthouse-service.
      '';
      example = {
        max-port = 65535;
        min-port = 49152;
        "webserver.ip" = "127.0.0.1";
        "webserver.port" = 8080;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nebula-lighthouse-service.settings = {
      min-port = lib.mkDefault 49152;
      max-port = lib.mkDefault 65535;
      "webserver.port" = lib.mkDefault 8080;
      "webserver.ip" = lib.mkDefault "127.0.0.1";
    };
    environment.etc."nebula-lighthouse-service/config.yaml".source =
      settingsFormat.generate "nebula-lighthouse-service-config.yaml" cfg.settings;
    systemd.services.nebula-lighthouse-service = {
      description = "Run nebula-lighthouse-service";
      wants = [ "basic.target" ];
      after = [
        "basic.target"
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        Restart = "always";
        ExecStart = "${pkgs.nebula-lighthouse-service}/bin/nebula-lighthouse-service";
        StateDirectory = "nebula-lighthouse-service";
        User = cfg.user;
        Group = cfg.user;
      };
    };
    users.users.${cfg.user} = {
      group = cfg.user;
      description = "nebula-lighthouse-service user";
      isSystemUser = true;
    };
    users.groups.${cfg.user} = { };
  };
  meta.maintainers = with lib.maintainers; [
    bloominstrong
  ];
}
