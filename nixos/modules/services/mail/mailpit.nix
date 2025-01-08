{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.services.mailpit) instances;
  isNonNull = v: v != null;
  genCliFlags =
    settings: lib.concatStringsSep " " (lib.cli.toGNUCommandLine { } (lib.filterAttrs (lib.const isNonNull) settings));
in
{
  options.services.mailpit.instances = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]
        );
        options = {
          database = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "mailpit.db";
            description = ''
              Specify the local database filename to store persistent data.
              If `null`, a temporary file will be created that will be removed when the application stops.
              It's recommended to specify a relative path. The database will be written into the service's
              state directory then.
            '';
          };
          max = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = 500;
            description = ''
              Maximum number of emails to keep. If the number is exceeded, old emails
              will be deleted.

              Set to `0` to never prune old emails.
            '';
          };
          listen = lib.mkOption {
            default = "127.0.0.1:8025";
            type = lib.types.str;
            description = ''
              HTTP bind interface and port for UI.
            '';
          };
          smtp = lib.mkOption {
            default = "127.0.0.1:1025";
            type = lib.types.str;
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

  config = lib.mkIf (instances != { }) {
    systemd.services = lib.mapAttrs' (
      name: cfg:
      lib.nameValuePair "mailpit-${name}" {
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "mailpit";
          WorkingDirectory = "%S/mailpit";
          ExecStart = "${lib.getExe pkgs.mailpit} ${genCliFlags cfg}";
          Restart = "on-failure";
        };
      }
    ) instances;
  };

  meta.maintainers = lib.teams.flyingcircus.members;
}
