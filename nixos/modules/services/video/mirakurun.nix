{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mirakurun;
  mirakurun = pkgs.mirakurun;
  username = config.users.users.mirakurun.name;
  groupname = config.users.users.mirakurun.group;
  settingsFmt = pkgs.formats.yaml {};
in
  {
    options = {
      services.mirakurun = {
        enable = mkEnableOption mirakurun.meta.description;

        port = mkOption {
          type = with types; nullOr port;
          default = 40772;
          description = ''
            Port to listen on. If <literal>null</literal>, it won't listen on
            any port.
          '';
        };

        openFirewall = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Open ports in the firewall for Mirakurun.

            <warning>
              <para>
                Exposing Mirakurun to the open internet is generally advised
                against. Only use it inside a trusted local network, or
                consider putting it behind a VPN if you want remote access.
              </para>
            </warning>
          '';
        };

        unixSocket = mkOption {
          type = with types; nullOr path;
          default = "/var/run/mirakurun/mirakurun.sock";
          description = ''
            Path to unix socket to listen on. If <literal>null</literal>, it
            won't listen on any unix sockets.
          '';
        };

        serverSettings = mkOption {
          type = settingsFmt.type;
          default = {};
          example = literalExample ''
            {
              highWaterMark = 25165824;
              overflowTimeLimit = 30000;
            };
          '';
          description = ''
            Options for server.yml.

            Documentation:
            <link xlink:href="https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md"/>
          '';
        };

        tunerSettings = mkOption {
          type = with types; nullOr settingsFmt.type;
          default = null;
          example = literalExample ''
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
            <link xlink:href="https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md"/>
          '';
        };

        channelSettings = mkOption {
          type = with types; nullOr settingsFmt.type;
          default = null;
          example = literalExample ''
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
            <link xlink:href="https://github.com/Chinachu/Mirakurun/blob/master/doc/Configuration.md"/>
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ mirakurun ];
      environment.etc = {
        "mirakurun/server.yml".source = settingsFmt.generate "server.yml" cfg.serverSettings;
        "mirakurun/tuners.yml" = mkIf (cfg.tunerSettings != null) {
          source = settingsFmt.generate "tuners.yml" cfg.tunerSettings;
          mode = "0644";
          user = username;
          group = groupname;
        };
        "mirakurun/channels.yml" = mkIf (cfg.channelSettings != null) {
          source = settingsFmt.generate "channels.yml" cfg.channelSettings;
          mode = "0644";
          user = username;
          group = groupname;
        };
      };

      networking.firewall = mkIf cfg.openFirewall {
        allowedTCPPorts = mkIf (cfg.port != null) [ cfg.port ];
      };

      users.users.mirakurun = {
        description = "Mirakurun user";
        group = "video";
        isSystemUser = true;
      };

      services.mirakurun.serverSettings = {
        logLevel = mkDefault 2;
        path = mkIf (cfg.unixSocket != null) cfg.unixSocket;
        port = mkIf (cfg.port != null) cfg.port;
      };

      systemd.tmpfiles.rules = [
        "d '/etc/mirakurun' - ${username} ${groupname} - -"
      ];

      systemd.services.mirakurun = {
        description = mirakurun.meta.description;
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${mirakurun}/bin/mirakurun";
          User = username;
          Group = groupname;
          RuntimeDirectory="mirakurun";
          StateDirectory="mirakurun";
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
          NODE_ENV = "production";
        };

        restartTriggers = let
          getconf = target: config.environment.etc."mirakurun/${target}.yml".source;
          targets = [
            "server"
          ] ++ optional (cfg.tunerSettings != null) "tuners"
            ++ optional (cfg.channelSettings != null) "channels";
        in (map getconf targets);
      };
    };
  }
