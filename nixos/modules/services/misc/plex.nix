{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.plex;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "plex"
      "managePlugins"
    ] "Please omit or define the option: `services.plex.extraPlugins' instead.")
  ];

  options = {
    services.plex = {
      enable = lib.mkEnableOption "Plex Media Server";

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/plex";
        description = ''
          The directory where Plex stores its data files.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the media server.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "plex";
        description = ''
          User account under which Plex runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "plex";
        description = ''
          Group under which Plex runs.
        '';
      };

      extraPlugins = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          A list of paths to extra plugin bundles to install in Plex's plugin
          directory. Every time the systemd unit for Plex starts up, all of the
          symlinks in Plex's plugin directory will be cleared and this module
          will symlink all of the paths specified here to that directory.
        '';
        example = lib.literalExpression ''
          [
            (builtins.path {
              name = "Audnexus.bundle";
              path = pkgs.fetchFromGitHub {
                owner = "djdembeck";
                repo = "Audnexus.bundle";
                rev = "v0.2.8";
                sha256 = "sha256-IWOSz3vYL7zhdHan468xNc6C/eQ2C2BukQlaJNLXh7E=";
              };
            })
          ]
        '';
      };

      extraScanners = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          A list of paths to extra scanners to install in Plex's scanners
          directory.

          Every time the systemd unit for Plex starts up, all of the symlinks
          in Plex's scanners directory will be cleared and this module will
          symlink all of the paths specified here to that directory.
        '';
        example = lib.literalExpression ''
          [
            (fetchFromGitHub {
              owner = "ZeroQI";
              repo = "Absolute-Series-Scanner";
              rev = "773a39f502a1204b0b0255903cee4ed02c46fde0";
              sha256 = "4l+vpiDdC8L/EeJowUgYyB3JPNTZ1sauN8liFAcK+PY=";
            })
          ]
        '';
      };

      accelerationDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "*" ];
        example = [ "/dev/dri/renderD128" ];
        description = ''
          A list of device paths to hardware acceleration devices that Plex should
          have access to. This is useful when transcoding media files.
          The special value `"*"` will allow all devices.
        '';
      };

      package = lib.mkPackageOption pkgs "plex" {
        extraDescription = ''
          Plex subscribers may wish to use their own package here,
          pointing to subscriber-only server versions.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        ExecStartPre =
          let
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
        PIDFile = "${cfg.dataDir}/Plex Media Server/plexmediaserver.pid";
        Restart = "on-failure";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = cfg.accelerationDevices == [ ];
        DeviceAllow = lib.mkIf (
          cfg.accelerationDevices != [ ] && !lib.elem "*" cfg.accelerationDevices
        ) cfg.accelerationDevices;
        ProtectSystem = true;
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        # This could be made to work if the namespaces needed were known
        # RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
      };

      environment = {
        # Configuration for our FHS userenv script
        PLEX_DATADIR = cfg.dataDir;
        PLEX_PLUGINS = lib.concatMapStringsSep ":" builtins.toString cfg.extraPlugins;
        PLEX_SCANNERS = lib.concatMapStringsSep ":" builtins.toString cfg.extraScanners;

        # The following variables should be set by the FHS userenv script:
        #   PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR
        #   PLEX_MEDIA_SERVER_HOME

        # Allow access to GPU acceleration; the Plex LD_LIBRARY_PATH is added
        # by the FHS userenv script.
        LD_LIBRARY_PATH = "/run/opengl-driver/lib";

        PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS = "6";
        PLEX_MEDIA_SERVER_TMPDIR = "/tmp";
        PLEX_MEDIA_SERVER_USE_SYSLOG = "true";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        32400
        3005
        8324
        32469
      ];
      allowedUDPPorts = [
        1900
        5353
        32410
        32412
        32413
        32414
      ];
    };

    users.users = lib.mkIf (cfg.user == "plex") {
      plex = {
        group = cfg.group;
        uid = config.ids.uids.plex;
      };
    };

    users.groups = lib.mkIf (cfg.group == "plex") {
      plex = {
        gid = config.ids.gids.plex;
      };
    };
  };
}
