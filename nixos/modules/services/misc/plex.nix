{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.plex;
in
{
  options = {
    services.plex = {
      enable = mkEnableOption "Plex Media Server";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plex";
        description = ''
          The directory where Plex stores its data files.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the media server.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "plex";
        description = ''
          User account under which Plex runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "plex";
        description = ''
          Group under which Plex runs.
        '';
      };

      managePlugins = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set to true, this option will cause all of the symlinks in Plex's
          plugin directory to be removed and symlinks for paths specified in
          <option>extraPlugins</option> to be added.
        '';
      };

      extraPlugins = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          A list of paths to extra plugin bundles to install in Plex's plugin
          directory. Every time the systemd unit for Plex starts up, all of the
          symlinks in Plex's plugin directory will be cleared and this module
          will symlink all of the paths specified here to that directory. If
          this behavior is undesired, set <option>managePlugins</option> to
          false.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.plex;
        defaultText = "pkgs.plex";
        description = ''
          The Plex package to use. Plex subscribers may wish to use their own
          package here, pointing to subscriber-only server versions.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Most of this is just copied from the RPM package's systemd service file.
    systemd.services.plex = {
      description = "Plex Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "plex-run-prestart" ''
            #!${pkgs.bash}/bin/bash

            # Create data directory if it doesn't exist
            if ! test -d "$PLEX_DATADIR"; then
              echo "Creating initial Plex data directory in: $PLEX_DATADIR"
              install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$PLEX_DATADIR"
            fi
         '';
        in
          "!${preStartScript}";

        ExecStart = "${cfg.package}/bin/plexmediaserver";
        KillSignal = "SIGQUIT";
        Restart = "on-failure";
      };

      environment = {
        # Configuration for our FHS userenv script
        PLEX_DATADIR=cfg.dataDir;
        PLEX_PLUGINS=concatMapStringsSep ":" builtins.toString cfg.extraPlugins;

        # The following variables should be set by the FHS userenv script:
        #   PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR
        #   PLEX_MEDIA_SERVER_HOME

        # Allow access to GPU acceleration; the Plex LD_LIBRARY_PATH is added
        # by the FHS userenv script.
        LD_LIBRARY_PATH="/run/opengl-driver/lib";

        PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6";
        PLEX_MEDIA_SERVER_TMPDIR="/tmp";
        PLEX_MEDIA_SERVER_USE_SYSLOG="true";
        LC_ALL="en_US.UTF-8";
        LANG="en_US.UTF-8";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 32400 3005 8324 32469 ];
      allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
    };

    users.users = mkIf (cfg.user == "plex") {
      plex = {
        group = cfg.group;
        uid = config.ids.uids.plex;
      };
    };

    users.groups = mkIf (cfg.group == "plex") {
      plex = {
        gid = config.ids.gids.plex;
      };
    };
  };
}
