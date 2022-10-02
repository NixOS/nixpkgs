{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.borgmatic;
  settingsFormat = pkgs.formats.yaml { };
  cfgfile = settingsFormat.generate "config.yaml" cfg.settings;
in {
  options.services.borgmatic = {
    enable = mkEnableOption (lib.mdDoc "borgmatic");

    settings = mkOption {
      description = lib.mdDoc ''
        See https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      type = types.submodule {
        freeformType = settingsFormat.type;
        options.location = {
          source_directories = mkOption {
            type = types.listOf types.str;
            description = lib.mdDoc ''
              List of source directories to backup (required). Globs and
              tildes are expanded.
            '';
            example = [ "/home" "/etc" "/var/log/syslog*" ];
          };
          repositories = mkOption {
            type = types.listOf types.str;
            description = lib.mdDoc ''
              Paths to local or remote repositories (required). Tildes are
              expanded. Multiple repositories are backed up to in
              sequence. Borg placeholders can be used. See the output of
              "borg help placeholders" for details. See ssh_command for
              SSH options like identity file or port. If systemd service
              is used, then add local repository paths in the systemd
              service file to the ReadWritePaths list.
            '';
            example = [
              "user@backupserver:sourcehostname.borg"
              "user@backupserver:{fqdn}"
            ];
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.borgmatic ];

    environment.etc."borgmatic/config.yaml".source = cfgfile;

    systemd.packages = [ pkgs.borgmatic ];

  };
}
