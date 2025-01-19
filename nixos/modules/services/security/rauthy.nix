{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    maintainers
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    ;
  inherit (lib.types)
    nullOr
    path
    attrs
    ;

  cfg = config.services.rauthy;
  format = pkgs.formats.ini { };
  configFile = format.generate "rauthy.cfg" cfg.settings;
in
{
  meta.maintainers = with maintainers; [
    gepbird
  ];

  options.services.rauthy = {
    enable = mkEnableOption "Rauthy";

    package = mkPackageOption pkgs "rauthy" { };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      example = "/run/secrets/rauthy.cfg";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

    settings = mkOption {
      type = attrs;
      default = { };
      example = {
        PROXY_MODE = true;
      };
      description = ''
        Additional key-value pair configuration options.
        See https://sebadob.github.io/rauthy/config/production_config.html.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rauthy = {
      description = "rauthy";
      after = [
        "postgresql.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        WorkingDirecotry = "/var/lib/rauthy";
        # rauthy must find rauthy.cfg in the cwd
        ExecStartPre = pkgs.writeShellScript "rauthy-pre" ''
          ln -sf ${configFile} /var/lib/rauthy/rauthy.cfg
        '';
        ExecStart = pkgs.writeShellScript "rauthy-start" ''
          cd /var/lib/rauthy
          ${cfg.package}/bin/rauthy
        '';
        StateDirectory = "rauthy";
        EnvironmentFile = [
          configFile
        ] ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };
}
