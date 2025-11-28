{
  config,
  pkgs,
  lib,
  ...
}@args:

let
  cfg = config.services.sylkserver;
  settingsFormat = pkgs.formats.ini { };
in

{
  options = {
    services.sylkserver = {
      enable = lib.mkEnableOption "the SylkServer SIP/XMPP/WebRTC Application Server";
      package = lib.mkPackageOption pkgs "sylkserver" { };
      debug = lib.mkEnableOption "verbose logging";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open ports in the firewall for SylkServer.";
      };

      user = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "sylkserver";
        description = "User account under which SylkServer runs.";
      };

      group = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "sylkserver";
        description = "Group under which SylkServer runs.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/sylkserver";
        description = "Directory to store SylkServer data and configuration.";
      };

      # See configuration samples for options
      # e.g. https://github.com/AGProjects/sylkserver/blob/master/config.ini.sample
      settings = lib.mkOption {
        type = lib.types.submodule {
          options = {
            config = lib.mkOption {
              type = lib.types.submodule (import ./config-modules/config.nix args);
              default = { };
              description = "Main SylkServer configuration.";
            };
            conference = lib.mkOption {
              type = lib.types.submodule (import ./config-modules/conference.nix args);
              default = { };
              description = "Conference application configuration.";
            };
            auth = lib.mkOption {
              type = lib.types.submodule {
                freeformType = settingsFormat.type;
                options = { };
              };
              default = { };
              description = "Authentication configuration.";
            };
            playback = lib.mkOption {
              type = lib.types.submodule {
                freeformType = settingsFormat.type;
                options = { };
              };
              default = { };
              description = "Playback application configuration.";
            };
            webrtcgateway = lib.mkOption {
              type = lib.types.submodule {
                freeformType = settingsFormat.type;
                options = { };
              };
              default = { };
              description = "WebRTC gateway configuration.";
            };
            xmppgateway = lib.mkOption {
              type = lib.types.submodule (import ./config-modules/xmppgateway.nix args);
              default = { };
              description = "XMPP gateway configuration.";
            };
            ircconference = lib.mkOption {
              type = lib.types.submodule {
                freeformType = settingsFormat.type;
                options = { };
              };
              default = { };
              description = "IRC conference configuration.";
            };
          };
        };
        default = { };
        description = "SylkServer configuration files.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: dynamic user?
    # there were some issues with using a dynamic user (tied to uid and gid)
    # that may warrant patching the software
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "SylkServer service user";
      home = cfg.stateDir;
      createHome = true;
      isSystemUser = true;
      group = cfg.group;
    };

    # TODO: the server requies `/var/spool/sylkserver` to exist despite
    # changing `spool_dir` to something else. find out why this happens and
    # remove the hardcoded value
    systemd.tmpfiles.settings = {
      "10-sylkserver"."/var/spool/sylkserver".d = {
        group = cfg.group;
        user = cfg.user;
        mode = "075";
      };
    };

    systemd.services.sylkserver = {
      description = "SylkServer SIP/XMPP/WebRTC Application Server";
      wantedBy = [
        "multi-user.target"
      ];
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ];
      requires = [
        "systemd-tmpfiles-setup.service"
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        ExecStart = toString [
          (lib.getExe' cfg.package "sylk-server")
          (lib.optionalString cfg.debug "--debug")
          "--no-fork"
          "--config-dir $STATE_DIRECTORY"
        ];

        LogsDirectory = "sylkserver";
        RuntimeDirectory = "sylkserver";
        StateDirectory = "sylkserver";
        WorkingDirectory = cfg.stateDir;

        Restart = "on-failure";
        RestartSec = 5;
      };

      unitConfig = {
        StartLimitBurst = 5;
        StartLimitInterval = 100;
      };

      preStart = ''
        # create config files
        ${lib.concatMapStringsSep "\n" (name: ''
          cat > $STATE_DIRECTORY/${name}.ini <<EOF
          ${lib.generators.toINI { } cfg.settings.${name}}
          EOF
        '') (lib.attrNames cfg.settings)}
      '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.settings.config.SIP.local_tcp_port
        cfg.settings.config.SIP.local_tls_port
        cfg.settings.config.WebServer.local_port
        cfg.settings.xmppgateway.general.local_port
      ];
      allowedUDPPorts = [
        cfg.settings.config.SIP.local_udp_port
      ];
    };
  };
}
