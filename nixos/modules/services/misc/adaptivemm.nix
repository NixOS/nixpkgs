{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.adaptivemm;
in {
  options = {
    services.adaptivemm = {
      enable = mkEnableOption (lib.mdDoc "Proactively tune kernel free memory configuration");

      package = mkOption {
        type = types.package;
        default = pkgs.adaptivemm;
        defaultText = literalExpression "pkgs.adaptivemm";
        description = lib.mdDoc ''
          Which adaptivemm package to use.
        '';
      };

      verbosity = mkOption {
        type = types.int;
        default = 0;
        defaultText = literalExpression "0";
        description = lib.mdDoc ''
          Verbosity, from 0 to 5.
        '';
      };

      maxWatermarkGap = mkOption {
        type = types.int;
        default = 5;
        defaultText = literalExpression "5";
        description = lib.mdDoc ''
          Maximum allowed gap between high and low watermarks in GB.
        '';
      };

      aggressiveness = mkOption {
        type = types.int;
        default = 2;
        defaultText = literalExpression "2";
        description = lib.mdDoc ''
          Aggressiveness level (1=high, 2=normal, 3=low).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."sysconfig/adaptivemmd".source = "${cfg.package}/etc/sysconfig/adaptivemmd";
    };

    systemd.services.adaptivemmd = {
      serviceConfig = {
        Type = "forking";
        EnvironmentFile = "/etc/sysconfig/adaptivemmd";
        ExecStart = let
          verboseFlag = assert (cfg.verbosity >= 0 && cfg.verbosity <= 5);
            if cfg.verbosity == 0 then ""
            else lib.concatStrings (["-"] ++ (lib.replicate cfg.verbosity "v"));
          aggressivenessFlag = assert (cfg.aggressiveness >= 1 && cfg.aggressiveness <= 3);
            "-a ${builtins.toString cfg.aggressiveness}";
          gapFlag = "-m ${builtins.toString cfg.maxWatermarkGap}";
        in "${cfg.package}/bin/adaptivemmd ${verboseFlag} ${aggressivenessFlag} ${gapFlag}";
        KillMode = "control-group";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      unitConfig = {
        Description = "Adaptive free memory optimizer daemon";
        Documentation = "man:adaptivemmd(8)";
        After = [ "systemd-sysctl.service" "local-fs.target" ];
      };

      wantedBy = [ "multi-user.target" ];
    };
  };

  meta = {
    maintainers = with maintainers; [ cmm ];
  };
}
