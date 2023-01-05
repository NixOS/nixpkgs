{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.litestream;
  settingsFormat = pkgs.formats.yaml {};
in
{
  options.services.litestream = {
    enable = mkEnableOption (lib.mdDoc "litestream");

    package = mkOption {
      description = lib.mdDoc "Package to use.";
      default = pkgs.litestream;
      defaultText = literalExpression "pkgs.litestream";
      type = types.package;
    };

    settings = mkOption {
      description = lib.mdDoc ''
        See the [documentation](https://litestream.io/reference/config/).
      '';
      type = settingsFormat.type;
      example = {
        dbs = [
          {
            path = "/var/lib/db1";
            replicas = [
              {
                url = "s3://mybkt.litestream.io/db1";
              }
            ];
          }
        ];
      };
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/litestream";
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets may be passed to the service without adding them to the
        world-readable Nix store, by specifying placeholder variables as
        the option value in Nix and setting these variables accordingly in the
        environment file.

        By default, Litestream will perform environment variable expansion
        within the config file before reading it. Any references to ''$VAR or
        ''${VAR} formatted variables will be replaced with their environment
        variable values. If no value is set then it will be replaced with an
        empty string.

        ```
          # Content of the environment file
          LITESTREAM_ACCESS_KEY_ID=AKIAxxxxxxxxxxxxxxxx
          LITESTREAM_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxx
        ```

        Note that this file needs to be available on the host on which
        this exporter is running.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc = {
      "litestream.yml" = {
        source = settingsFormat.generate "litestream-config.yaml" cfg.settings;
      };
    };

    systemd.services.litestream = {
      description = "Litestream";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/litestream replicate";
        Restart = "always";
        User = "litestream";
        Group = "litestream";
      };
    };

    users.users.litestream = {
      description = "Litestream user";
      group = "litestream";
      isSystemUser = true;
    };
    users.groups.litestream = {};
  };

  # Don't edit the docbook xml directly, edit the md and generate it using md-to-db.sh
  meta.doc = ./default.xml;
}
