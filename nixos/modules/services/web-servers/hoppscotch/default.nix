{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;
  cfg = config.services.hoppscotch;
in
{
  options.services.hoppscotch = {
    enable = mkEnableOption "Hoppscotch Community Edition";

    package = mkPackageOption pkgs "hoppscotch-community-edition" { };

    createDatabaseLocally = mkOption {
      description = ''
        Whether a PostgreSQL database should be automatically created and
        configured on the local host. If set to `false`, you need to provision
        a database yourself and make sure to create the hstore extension in it.
      '';
      type = types.bool;
      default = true;
    };

    environmentFile = mkOption {
      description = ''
        Environment file to be passed to the systemd service.
        For an exhaustive list of accepted variables, refer to
        <https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build#configuring-the-environment>
      '';
      type = types.nullOr types.path;
      default = null;
      example = "/var/lib/secrets/hoppscotchSecrets";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.postgresql = mkIf cfg.createDatabaseLocally {
      enable = true;

      # FIXME: These should be configurable by the user.
      # It also will conflict with DATABASE_URL otherwise.
      ensureDatabases = [ "hoppscotch-community-edition" ];
      ensureUsers = [
        {
          name = "hoppscotch-community-edition";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
