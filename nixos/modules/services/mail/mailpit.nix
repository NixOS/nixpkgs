{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.services.mailpit) instances;
  inherit (lib)
    cli
    concatStringsSep
    const
    filterAttrs
    getExe
    mapAttrs'
    mkIf
    mkOption
    nameValuePair
    types
    ;

  isNonNull = v: v != null;
  genCliFlags =
    settings: concatStringsSep " " (cli.toCommandLineGNU { } (filterAttrs (const isNonNull) settings));
in
{
  options.services.mailpit.instances = mkOption {
    default = { };
    type = types.attrsOf (
      types.submodule {
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
            default = "127.0.0.1:8025";
            type = types.str;
            description = ''
              HTTP bind interface and port for UI.
            '';
          };
          smtp = mkOption {
            default = "127.0.0.1:1025";
            type = types.str;
            description = ''
              SMTP bind interface and port.
            '';
          };
        };
      }
    );
    description = ''
      Configure mailpit instances. The attribute-set values are
      CLI flags passed to the `mailpit` CLI.

      See [upstream docs](https://mailpit.axllent.org/docs/configuration/runtime-options/)
      for all available options.
    '';
  };

  config = mkIf (instances != { }) {
    systemd.services = mapAttrs' (
      name: cfg:
      nameValuePair "mailpit-${name}" {
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "mailpit";
          WorkingDirectory = "%S/mailpit";
          ExecStart = "${getExe pkgs.mailpit} ${genCliFlags cfg}";
          Restart = "on-failure";
        };
      }
    ) instances;
  };

  meta.maintainers = lib.teams.flyingcircus.members;
}
