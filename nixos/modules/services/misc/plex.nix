{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.plex;
  plex = pkgs.plex;
in
{
  options = {
    services.plex = {
      enable = mkEnableOption "Enable Plex Media Server";

      # FIXME: In order for this config option to work, symlinks in the Plex
      # package in the Nix store have to be changed to point to this directory.
      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plex";
        description = "The directory where Plex stores its data files.";
      };

      user = mkOption {
        type = types.str;
        default = "plex";
        description = "User account under which Plex runs.";
      };

      group = mkOption {
        type = types.str;
        default = "plex";
        description = "Group under which Plex runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Most of this is just copied from the RPM package's systemd service file.
    systemd.services.plex = {
      description = "Plex Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d "${cfg.dataDir}" || {
          echo "Creating initial Plex data directory in \"${cfg.dataDir}\"."
          mkdir -p "${cfg.dataDir}"
          chown -R ${cfg.user}:${cfg.group} "${cfg.dataDir}"
        }
        # Copy the database skeleton files to /var/lib/plex/.skeleton
        test -d "${cfg.dataDir}/.skeleton" || mkdir "${cfg.dataDir}/.skeleton"
        for db in "com.plexapp.plugins.library.db"; do
            cp "${plex}/usr/lib/plexmediaserver/Resources/base_$db" "${cfg.dataDir}/.skeleton/$db"
            chmod u+w "${cfg.dataDir}/.skeleton/$db"
            chown ${cfg.user}:${cfg.group} "${cfg.dataDir}/.skeleton/$db"
        done
     '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "/bin/sh -c '${plex}/usr/lib/plexmediaserver/Plex\\ Media\\ Server'";
      };
      environment = {
        PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=cfg.dataDir;
        PLEX_MEDIA_SERVER_HOME="${plex}/usr/lib/plexmediaserver";
        PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6";
        PLEX_MEDIA_SERVER_TMPDIR="/tmp";
        LD_LIBRARY_PATH="${plex}/usr/lib/plexmediaserver";
        LC_ALL="en_US.UTF-8";
        LANG="en_US.UTF-8";
      };
    };

    users.extraUsers = mkIf (cfg.user == "plex") {
      plex = {
        group = cfg.group;
        uid = config.ids.uids.plex;
      };
    };

    users.extraGroups = mkIf (cfg.group == "plex") {
      plex = {
        gid = config.ids.gids.plex;
      };
    };
  };
}
