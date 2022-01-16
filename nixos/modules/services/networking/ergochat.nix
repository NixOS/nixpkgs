{ config, lib, options, pkgs, ... }: let
  cfg = config.services.ergochat;
in {
  options = {
    services.ergochat = {

      enable = lib.mkEnableOption "Ergo IRC daemon";

      openFilesLimit = lib.mkOption {
        type = lib.types.int;
        default = 1024;
        description = ''
          Maximum number of open files. Limits the clients and server connections.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = (pkgs.formats.yaml {}).generate "ergo.conf" cfg.settings;
        defaultText = "generated config file from <literal>.settings</literal>";
        description = ''
          Path to configuration file.
          Setting this will skip any configuration done via <literal>.settings</literal>
        '';
      };

      settings = lib.mkOption {
        type = (pkgs.formats.yaml {}).type;
        description = ''
          Ergo IRC daemon configuration file.
          https://raw.githubusercontent.com/ergochat/ergo/master/default.yaml
        '';
        default = {
          network = {
            name = "testnetwork";
          };
          server = {
            name = "example.com";
            listeners = {
              ":6667" = {};
            };
            casemapping = "permissive";
            enforce-utf = true;
            lookup-hostnames = false;
            ip-cloaking = {
              enabled = false;
            };
            forward-confirm-hostnames = false;
            check-ident = false;
            relaymsg = {
              enabled = false;
            };
            max-sendq = "1M";
            ip-limits = {
              count = false;
              throttle = false;
            };
          };
          datastore = {
            autoupgrade = true;
            # this points to the StateDirectory of the systemd service
            path = "/var/lib/ergo/ircd.db";
          };
          accounts = {
            authentication-enabled = true;
            registration = {
              enabled = true;
              allow-before-connect = true;
              throttling = {
                enabled = true;
                duration = "10m";
                max-attempts = 30;
              };
              bcrypt-cost = 4;
              email-verification.enabled = false;
            };
            multiclient = {
              enabled = true;
              allowed-by-default = true;
              always-on = "opt-out";
              auto-away = "opt-out";
            };
          };
          channels = {
            default-modes = "+ntC";
            registration = {
              enabled = true;
            };
          };
          limits = {
            nicklen = 32;
            identlen = 20;
            channellen = 64;
            awaylen = 390;
            kicklen = 390;
            topiclen = 390;
          };
          history = {
            enabled = true;
            channel-length = 2048;
            client-length = 256;
            autoresize-window = "3d";
            autoreplay-on-join = 0;
            chathistory-maxmessages = 100;
            znc-maxmessages = 2048;
            restrictions = {
              expire-time = "1w";
              query-cutoff = "none";
              grace-period = "1h";
            };
            retention = {
              allow-individual-delete = false;
              enable-account-indexing = false;
            };
            tagmsg-storage = {
              default = false;
              whitelist = [
                "+draft/react"
                "+react"
              ];
            };
          };
        };
      };

    };
  };
  config = lib.mkIf cfg.enable {

    environment.etc."ergo.yaml".source = cfg.configFile;

    # merge configured values with default values
    services.ergochat.settings =
      lib.mapAttrsRecursive (_: lib.mkDefault) options.services.ergochat.settings.default;

    systemd.services.ergochat = {
      description = "Ergo IRC daemon";
      wantedBy = [ "multi-user.target" ];
      # reload is not applying the changed config. further investigation is needed
      # at some point this should be enabled, since we don't want to restart for
      # every config change
      # reloadIfChanged = true;
      restartTriggers = [ cfg.configFile ];
      serviceConfig = {
        ExecStart = "${pkgs.ergochat}/bin/ergo run --conf /etc/ergo.yaml";
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
        DynamicUser = true;
        StateDirectory = "ergo";
        LimitNOFILE = toString cfg.openFilesLimit;
      };
    };

  };
  meta.maintainers = with lib.maintainers; [ lassulus tv ];
}
