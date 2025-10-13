{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.borgmatic;
  settingsFormat = pkgs.formats.yaml { };

  postgresql = config.services.postgresql.package;
  mysql = config.services.mysql.package;
  requireSudo =
    s:
    s ? postgresql_databases
    && lib.any (d: d ? username && !(d ? password) && !(d ? pg_dump_command)) s.postgresql_databases;
  addRequiredBinaries =
    s:
    s
    // (lib.optionalAttrs (s ? postgresql_databases && s.postgresql_databases != [ ]) {
      postgresql_databases = map (
        d:
        let
          as_user = if d ? username && !(d ? password) then "${pkgs.sudo}/bin/sudo -u ${d.username} " else "";
        in
        {
          pg_dump_command =
            if d.name == "all" && (!(d ? format) || isNull d.format) then
              "${as_user}${postgresql}/bin/pg_dumpall"
            else
              "${as_user}${postgresql}/bin/pg_dump";
          pg_restore_command = "${as_user}${postgresql}/bin/pg_restore";
          psql_command = "${as_user}${postgresql}/bin/psql";
        }
        // d
      ) s.postgresql_databases;
    })
    // (lib.optionalAttrs (s ? mariadb_databases && s.mariadb_databases != [ ]) {
      mariadb_databases = map (
        d:
        {
          mariadb_dump_command = "${mysql}/bin/mariadb-dump";
          mariadb_command = "${mysql}/bin/mariadb";
        }
        // d
      ) s.mariadb_databases;
    })
    // (lib.optionalAttrs (s ? mysql_databases && s.mysql_databases != [ ]) {
      mysql_databases = map (
        d:
        {
          mysql_dump_command = "${mysql}/bin/mysqldump";
          mysql_command = "${mysql}/bin/mysql";
        }
        // d
      ) s.mysql_databases;
    });

  repository =
    with lib.types;
    submodule {
      options = {
        path = lib.mkOption {
          type = str;
          description = ''
            Path to the repository
          '';
        };
        label = lib.mkOption {
          type = str;
          description = ''
            Label to the repository
          '';
        };
      };
    };
  cfgType =
    with lib.types;
    submodule {
      freeformType = settingsFormat.type;
      options = {
        source_directories = lib.mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            List of source directories and files to backup. Globs and tildes are
            expanded. Do not backslash spaces in path names.
          '';
          example = [
            "/home"
            "/etc"
            "/var/log/syslog*"
            "/home/user/path with spaces"
          ];
        };
        repositories = lib.mkOption {
          type = listOf repository;
          default = [ ];
          description = ''
            A required list of local or remote repositories with paths and
            optional labels (which can be used with the --repository flag to
            select a repository). Tildes are expanded. Multiple repositories are
            backed up to in sequence. Borg placeholders can be used. See the
            output of "borg help placeholders" for details. See ssh_command for
            SSH options like identity file or port. If systemd service is used,
            then add local repository paths in the systemd service file to the
            ReadWritePaths list.
          '';
          example = [
            {
              path = "ssh://user@backupserver/./sourcehostname.borg";
              label = "backupserver";
            }
            {
              path = "/mnt/backup";
              label = "local";
            }
          ];
        };
      };
    };

  cfgfile = settingsFormat.generate "config.yaml" (addRequiredBinaries cfg.settings);

  anycfgRequiresSudo =
    requireSudo cfg.settings || lib.any requireSudo (lib.attrValues cfg.configurations);
in
{
  options.services.borgmatic = {
    enable = lib.mkEnableOption "borgmatic";

    settings = lib.mkOption {
      description = ''
        See <https://torsion.org/borgmatic/docs/reference/configuration/>
      '';
      default = null;
      type = lib.types.nullOr cfgType;
    };

    configurations = lib.mkOption {
      description = ''
        Set of borgmatic configurations, see <https://torsion.org/borgmatic/docs/reference/configuration/>
      '';
      default = { };
      type = lib.types.attrsOf cfgType;
    };

    enableConfigCheck = lib.mkEnableOption "checking all configurations during build time" // {
      default = true;
    };
  };

  config =
    let
      configFiles =
        (lib.optionalAttrs (cfg.settings != null) {
          "borgmatic/config.yaml".source = cfgfile;
        })
        // lib.mapAttrs' (
          name: value:
          lib.nameValuePair "borgmatic.d/${name}.yaml" {
            source = settingsFormat.generate "${name}.yaml" (addRequiredBinaries value);
          }
        ) cfg.configurations;
      borgmaticCheck =
        name: f:
        pkgs.runCommandCC "${name} validation" { } ''
          ${pkgs.borgmatic}/bin/borgmatic -c ${f.source} config validate
          touch $out
        '';
    in
    lib.mkIf cfg.enable {

      warnings =
        [ ]
        ++
          lib.optional (cfg.settings != null && cfg.settings ? location)
            "`services.borgmatic.settings.location` is deprecated, please move your options out of sections to the global scope"
        ++
          lib.optional (lib.catAttrs "location" (lib.attrValues cfg.configurations) != [ ])
            "`services.borgmatic.configurations.<name>.location` is deprecated, please move your options out of sections to the global scope";

      environment.systemPackages = [ pkgs.borgmatic ];

      environment.etc = configFiles;

      systemd.packages = [ pkgs.borgmatic ];
      systemd.services.borgmatic.path = [ pkgs.coreutils ];
      systemd.services.borgmatic.serviceConfig = lib.optionalAttrs anycfgRequiresSudo {
        NoNewPrivileges = false;
        CapabilityBoundingSet = "CAP_DAC_READ_SEARCH CAP_NET_RAW CAP_SETUID CAP_SETGID";
      };

      # Workaround: https://github.com/NixOS/nixpkgs/issues/81138
      systemd.timers.borgmatic.wantedBy = [ "timers.target" ];

      system.checks = lib.mkIf cfg.enableConfigCheck (lib.mapAttrsToList borgmaticCheck configFiles);
    };
}
