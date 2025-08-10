{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    ;

  inherit (lib.modules)
    mkIf
    ;

  inherit (lib.options)
    mkEnableOption
    mkOption
    literalExpression
    ;

  cfg = config.services.ax25.mheard;
in
{
  options = {

    services.ax25.mheard = {

      enable = mkEnableOption "AX.25 mheard daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-tools;
        defaultText = literalExpression "pkgs.ax25-tools";
        description = "The ax25-tools package to use.";
      };

      config = mkOption {
        type = types.str;
        default = "-l";
        description = ''
          Options that will be passed to the mheard daemon.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.ax25.axports != { };
        message = ''
          mheard cannot be used without axports.
          Please define at least one axport with
          <option>config.services.ax25.axports</option>.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.mheard = {
      description = "displays information about most recently heard AX.25 callsigns";
      wantedBy = [ "multi-user.target" ];
      after = [ "ax25-axports.target" ];
      requires = [ "ax25-axports.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/mheardd ${cfg.config}";
        StateDirectory = "ax25/mheard";
      };
    };
  };
}
