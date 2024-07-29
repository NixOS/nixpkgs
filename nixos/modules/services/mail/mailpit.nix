{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mailpit;
  inherit (lib)
    cli
    concatStringsSep
    const
    filterAttrs
    getExe
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  isNonNull = v: v != null;
  cliFlags = concatStringsSep " " (
    cli.toGNUCommandLine { } (filterAttrs (const isNonNull) cfg.settings)
  );
in
{
  options.services.mailpit = {
    enable = mkEnableOption "mailpit";

    settings = mkOption {
      default = { };
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.str
            types.int
            types.bool
          ]
        );
        options = {
          database = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "mailpit.db";
            description = ''
              Specify the local database filename to store persistent data.
              If `null`, a temporary file will be created that will be removed when the application stops.
              It's recommended to specify a relative path. The database will be written into the service's
              state directory then.
            '';
          };
          max = mkOption {
            type = types.ints.unsigned;
            default = 500;
            description = ''
              Maximum number of emails to keep. If the number is exceeded, old emails
              will be deleted.

              Set to `0` to never prune old emails.
            '';
          };
          listen = mkOption {
            default = "0.0.0.0:8025";
            type = types.str;
            description = ''
              HTTP bind interface and port for UI.
            '';
          };
          smtp = mkOption {
            default = "0.0.0.0:1025";
            type = types.str;
            description = ''
              SMTP bind interface and port.
            '';
          };
        };
      };
      description = ''
        Attribute-set of all flags passed to mailpit. See
        [upstream docs](https://mailpit.axllent.org/docs/configuration/runtime-options/)
        for all available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mailpit = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mailpit";
        WorkingDirectory = "%S/mailpit";
        ExecStart = "${getExe pkgs.mailpit} ${cliFlags}";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = lib.teams.flyingcircus.members;
}
