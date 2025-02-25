{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (pkgs)
    writeText
    ;
  inherit (lib)
    maintainers
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    ;
  inherit (lib.types)
    bool
    int
    float
    str
    path
    attrsOf
    oneOf
    nullOr
    ;

  cfg = config.services.rauthy;
  generateConfig = lib.generators.toKeyValue { };
  configFile = writeText "rauthy.cfg" (generateConfig cfg.settings);
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
      type = nullOr (
        attrsOf (oneOf [
          bool
          int
          float
          str
        ])
      );
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
        StateDirectory = "rauthy";
        StateDirectoryMode = 750;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        # rauthy must find rauthy.cfg in the cwd
        ExecStartPre = pkgs.writeShellScript "rauthy-pre" ''
          ln -sf ${configFile} /var/lib/rauthy/rauthy.cfg
        '';
        ExecStart = pkgs.writeShellScript "rauthy-start" ''
          cd /var/lib/rauthy
          ${cfg.package}/bin/rauthy
        '';

        User = "rauthy";
        DynamicUser = true;
      };
    };
  };
}
