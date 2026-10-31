{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pulse-agent;
in
{
  options.services.pulse-agent = {
    enable = lib.mkEnableOption "pulse-agent service";

    package = lib.mkPackageOption pkgs "pulse-agent" { };

    server = lib.mkOption {
      type = lib.types.str;
      default = "https://pulse.olilo.co.uk";
      description = "Pulse server base URL";
    };

    extraArgs = lib.mkOption {
      types = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments to pass to pulse-agent.";
    };

    environmentFile = lib.mkOption {
      types = lib.types.nullOr lib.types.str;
      default = null;
      description = "Environment file to pass to pulse-agent.";
    };
  };

  config = lib.mkIf (cfg.enable == true) {
    systemd.packages = [ cfg.package ];

    systemd.services.pulse-agent.serviceConfig = {
      User = "none";
      Group = "none";
      DynamicUser = true;
      ExecStart = "${lib.getExe cfg.package} ${cfg.server} ${cfg.extraArgs}";
      EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
    };
  };
}
