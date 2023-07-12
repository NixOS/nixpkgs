{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.unpackerr;
  format = pkgs.formats.toml {};
  configFile = format.generate "unpackerr.conf" cfg.settings;
in
{
  options = {
    services.unpackerr = {
      enable = mkEnableOption (lib.mdDoc "Unpackerr");

      settings = mkOption {
        type = format.type;
        default = {
          # Config needs to be non-empty, otherwise unpackerr
          # crashes. debug=false is the default value.
          debug = false;
        };
        description = lib.mdDoc ''
          Unpackerr configuration. Refer to
          <https://unpackerr.zip/docs/install/configuration> for
          details.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = lib.mdDoc "User account under which Unpackerr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = lib.mdDoc "Group under which Unpackerr runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.unpackerr;
        defaultText = literalExpression "pkgs.unpackerr";
        description = lib.mdDoc ''
          Unpackerr package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.unpackerr = {
      description = "Unpackerr";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/unpackerr -c ${configFile}";
        Restart = "on-failure";
      };
    };
  };
}
