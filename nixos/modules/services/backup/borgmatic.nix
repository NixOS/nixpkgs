{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.borgmatic;
  cfgfile = pkgs.writeText "config.yaml" (builtins.toJSON cfg.settings);
in {
  options.services.borgmatic = {
    enable = mkEnableOption "borgmatic";

    settings = mkOption {
      description = ''
        See https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      type = types.submodule {
        freeformType = with lib.types; attrsOf anything;
        options.location = {
          source_directories = mkOption {
            type = types.listOf types.str;
            description = ''
              List of source directories to backup (required). Globs and
              tildes are expanded.
            '';
            example = [ "/home" "/etc" "/var/log/syslog*" ];
          };
          repositories = mkOption {
            type = types.listOf types.str;
            description = ''
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
