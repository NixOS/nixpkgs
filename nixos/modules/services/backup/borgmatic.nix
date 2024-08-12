{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.borgmatic;
  settingsFormat = pkgs.formats.yaml { };

  repository = with types; submodule {
    options = {
      path = mkOption {
        type = str;
        description = ''
          Path to the repository
        '';
      };
      label = mkOption {
        type = str;
        description = ''
          Label to the repository
        '';
      };
    };
  };
  cfgType = with types; submodule {
    freeformType = settingsFormat.type;
    options = {
      source_directories = mkOption {
        type = listOf str;
        default = [];
        description = ''
          List of source directories and files to backup. Globs and tildes are
          expanded. Do not backslash spaces in path names.
        '';
        example = [ "/home" "/etc" "/var/log/syslog*" "/home/user/path with spaces" ];
      };
      repositories = mkOption {
        type = listOf repository;
        default = [];
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
          { path="ssh://user@backupserver/./sourcehostname.borg"; label="backupserver"; }
          { path="/mnt/backup"; label="local"; }
        ];
      };
    };
  };

  cfgfile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.borgmatic = {
    enable = mkEnableOption "borgmatic";

    settings = mkOption {
      description = ''
        See https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      default = null;
      type = types.nullOr cfgType;
    };

    configurations = mkOption {
      description = ''
        Set of borgmatic configurations, see https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      default = { };
      type = types.attrsOf cfgType;
    };

    enableConfigCheck = mkEnableOption "checking all configurations during build time" // { default = true; };
  };

  config =
    let
      configFiles =
        (optionalAttrs (cfg.settings != null) { "borgmatic/config.yaml".source = cfgfile; }) //
        mapAttrs'
          (name: value: nameValuePair
            "borgmatic.d/${name}.yaml"
            { source = settingsFormat.generate "${name}.yaml" value; })
          cfg.configurations;
      borgmaticCheck = name: f: pkgs.runCommandCC "${name} validation" { } ''
            ${pkgs.borgmatic}/bin/borgmatic -c ${f.source} config validate
            touch $out
          '';
    in
      mkIf cfg.enable {

        warnings = []
          ++ optional (cfg.settings != null && cfg.settings ? location)
            "`services.borgmatic.settings.location` is deprecated, please move your options out of sections to the global scope"
          ++ optional (catAttrs "location" (attrValues cfg.configurations) != [])
            "`services.borgmatic.configurations.<name>.location` is deprecated, please move your options out of sections to the global scope"
        ;

        environment.systemPackages = [ pkgs.borgmatic ];

        environment.etc = configFiles;

        systemd.packages = [ pkgs.borgmatic ];

        # Workaround: https://github.com/NixOS/nixpkgs/issues/81138
        systemd.timers.borgmatic.wantedBy = [ "timers.target" ];

        system.checks = mkIf cfg.enableConfigCheck (mapAttrsToList borgmaticCheck configFiles);
      };
}
