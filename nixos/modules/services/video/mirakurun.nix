{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mirakurun;
  mirakurun = pkgs.mirakurun;
  username = config.users.users.mirakurun.name;
  groupname = config.users.users.mirakurun.group;
  settingsFmt = pkgs.formats.yaml { };

  polkitRule = pkgs.writeTextDir "share/polkit-1/rules.d/10-mirakurun.rules" ''
    polkit.addRule(function (action, subject) {
      if (
        (action.id == "org.debian.pcsc-lite.access_pcsc" ||
          action.id == "org.debian.pcsc-lite.access_card") &&
        subject.user == "${username}"
      ) {
        return polkit.Result.YES;
      }
    });
  '';
in
{
  options = {
    services.mirakurun = {
      enable = lib.mkEnableOption "the Mirakurun DVR Tuner Server";

      port = lib.mkOption {
        type = with lib.types; nullOr port;
        default = 40772;
        description = ''
          Port to listen on. If `null`, it won't listen on
          any port.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Mirakurun.

          ::: {.warning}
          Exposing Mirakurun to the open internet is generally advised
          against. Only use it inside a trusted local network, or
          consider putting it behind a VPN if you want remote access.
          :::
        '';
      };

      unixSocket = lib.mkOption {
        type = with lib.types; nullOr path;
        default = "/var/run/mirakurun/mirakurun.sock";
        description = ''
          Path to unix socket to listen on. If `null`, it
          won't listen on any unix sockets.
        '';
      };

      allowSmartCardAccess = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Install polkit rules to allow Mirakurun to access smart card readers
          which is commonly used along with tuner devices.
        '';
      };

      serverSettings = lib.mkOption {
        type = settingsFmt.type;
        default = { };
        example = lib.literalExpression ''
          {
            highWaterMark = 25165824;
            overflowTimeLimit = 30000;
          };
        '';
        description = ''
          Options for server.yml.

          Documentation:
          <https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md>
        '';
      };

      tunerSettings = lib.mkOption {
        type = with lib.types; nullOr settingsFmt.type;
        default = null;
        example = lib.literalExpression ''
          [
            {
              name = "tuner-name";
              types = [ "GR" "BS" "CS" "SKY" ];
              dvbDevicePath = "/dev/dvb/adapterX/dvrX";
            }
          ];
        '';
        description = ''
          Options which are added to tuners.yml. If none is specified, it will
          automatically be generated at runtime.

          Documentation:
          <https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md>
        '';
      };

      channelSettings = lib.mkOption {
        type = with lib.types; nullOr settingsFmt.type;
        default = null;
        example = lib.literalExpression ''
          [
            {
              name = "channel";
              types = "GR";
              channel = "0";
            }
          ];
        '';
        description = ''
          Options which are added to channels.yml. If none is specified, it
          will automatically be generated at runtime.

          Documentation:
          <https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ mirakurun ] ++ lib.optional cfg.allowSmartCardAccess polkitRule;
    environment.etc = {
      "mirakurun/server.yml".source = settingsFmt.generate "server.yml" cfg.serverSettings;
      "mirakurun/tuners.yml" = lib.mkIf (cfg.tunerSettings != null) {
        source = settingsFmt.generate "tuners.yml" cfg.tunerSettings;
        mode = "0644";
        user = username;
        group = groupname;
      };
      "mirakurun/channels.yml" = lib.mkIf (cfg.channelSettings != null) {
        source = settingsFmt.generate "channels.yml" cfg.channelSettings;
        mode = "0644";
        user = username;
        group = groupname;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = lib.mkIf (cfg.port != null) [ cfg.port ];
    };

    users.users.mirakurun = {
      description = "Mirakurun user";
      group = "video";
      isSystemUser = true;

      # NPM insists on creating ~/.npm
      home = "/var/cache/mirakurun";
    };

    services.mirakurun.serverSettings = {
      logLevel = lib.mkDefault 2;
      path = lib.mkIf (cfg.unixSocket != null) cfg.unixSocket;
      port = lib.mkIf (cfg.port != null) cfg.port;
    };

    systemd.tmpfiles.settings."10-mirakurun"."/etc/mirakurun".d = {
      user = username;
      group = groupname;
    };

    systemd.services.mirakurun = {
      description = mirakurun.meta.description;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${mirakurun}/bin/mirakurun start";
        User = username;
        Group = groupname;
        CacheDirectory = "mirakurun";
        RuntimeDirectory = "mirakurun";
        StateDirectory = "mirakurun";
        Nice = -10;
        IOSchedulingClass = "realtime";
        IOSchedulingPriority = 7;
      };

      environment = {
        SERVER_CONFIG_PATH = "/etc/mirakurun/server.yml";
        TUNERS_CONFIG_PATH = "/etc/mirakurun/tuners.yml";
        CHANNELS_CONFIG_PATH = "/etc/mirakurun/channels.yml";
        SERVICES_DB_PATH = "/var/lib/mirakurun/services.json";
        PROGRAMS_DB_PATH = "/var/lib/mirakurun/programs.json";
        LOGO_DATA_DIR_PATH = "/var/lib/mirakurun/logos";
        NODE_ENV = "production";
      };

      restartTriggers =
        let
          getconf = target: config.environment.etc."mirakurun/${target}.yml".source;
          targets =
            [
              "server"
            ]
            ++ lib.optional (cfg.tunerSettings != null) "tuners"
            ++ lib.optional (cfg.channelSettings != null) "channels";
        in
        (map getconf targets);
    };
  };
}
