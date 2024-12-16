{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.borgmatic;
  settingsFormat = pkgs.formats.yaml { };

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

  cfgfile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.borgmatic = {
    enable = lib.mkEnableOption "borgmatic";

    settings = lib.mkOption {
      description = ''
        See https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      default = null;
      type = lib.types.nullOr cfgType;
    };

    configurations = lib.mkOption {
      description = ''
        Set of borgmatic configurations, see https://torsion.org/borgmatic/docs/reference/configuration/
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
        (lib.optionalAttrs (cfg.settings != null) { "borgmatic/config.yaml".source = cfgfile; })
        // lib.mapAttrs' (
          name: value:
          lib.nameValuePair "borgmatic.d/${name}.yaml" {
            source = settingsFormat.generate "${name}.yaml" value;
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

      # Workaround: https://github.com/NixOS/nixpkgs/issues/81138
      systemd.timers.borgmatic.wantedBy = [ "timers.target" ];

      system.checks = lib.mkIf cfg.enableConfigCheck (lib.mapAttrsToList borgmaticCheck configFiles);
    };
}
