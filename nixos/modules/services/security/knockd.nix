{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.knockd;
  description = "knockd - a port knocking daemon";

  knockOptions = {
    options = with types; {
      sequence = mkOption {
        type = str;
        description = "Specify the sequence of ports in the special knock.";
        example = "7000,8000,9000";
      };

      one_time_sequences = mkOption {
        type = path;
        description = "File containing the one time sequences to be used.";
      };

      seq_timeout = mkOption {
        type = int;
        description = "Time to wait for a sequence to complete in seconds.";
        example = 10;
      };

      tcpflags = mkOption {
        type = str;
        description = ''
          Only pay attention to packets that have this flag set. When using TCP
          flags, knockd will IGNORE tcp packets that don't match the flags.
          This is different than the normal behavior, where an incorrect packet
          would invalidate the entire knock, forcing the client to start over.
          Using "TCPFlags = syn" is useful if you are testing over an SSH
          connection, as the SSH traffic will usually interfere with (and thus
          invalidate) the knock.
        '';
      };

      target = mkOption {
        type = str;
        description = ''
          Use the specified IP address instead of the pre-determined address.
        '';
      };

      start_command = mkOption {
        type = str;
        description = ''
          Specify the command to be executed when a client makes the correct
          port-knock. All instances of %IP% will be replaced with the knocker's
          IP address.
        '';
      };

      cmd_timeout = mkOption {
        default = null;
        type = nullOr str;
        description = ''
          Time to wait (in seconds) between Start_Command and Stop_Command.
          This directive is optional, only required if Stop_Command is used.
        '';
      };

      stop_command = mkOption {
        default = null;
        type = nullOr str;
        description = ''
          Specify the command to be executed when Cmd_Timeout seconds have
          passed since Start_Command has been executed. All instances of %IP%
          will be replaced with the knocker's IP address.
        '';
      };
    };
  };

  fullConfig = { inherit (cfg) options; } // cfg.knocks;
  knockdConf = pkgs.writeText "knockd.conf" (generators.toINI { } fullConfig);
in {
  options.services.knockd = {
    enable = mkEnableOption description;

    extraPackages = mkOption {
      default = with pkgs; [ iptables iproute ];
      type = with types; listOf package;
      description = "Extra packages to add to PATH.";
    };

    options = mkOption {
      type = types.submodule {
        options = {
          useSyslog = mkEnableOption "logging messages through syslog()";

          logfile = mkOption {
            default = /var/log/knockd.log;
            type = types.path;
          };

          pidfile = mkOption {
            default = /var/run/knockd.pid;
            type = types.path;
          };

          interface = mkOption {
            default = "eth0";
            type = types.str;
          };
        };
      };
      description = "Global directives for knockd configuration.";
    };

    knocks = mkOption {
      type = with types; attrsOf (submodule knockOptions);
      description = "Knock/event sets for knockd.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ knock ] ++ cfg.extraPackages;

    environment.etc."knockd.conf".source = knockdConf;

    systemd.services.knockd = {
      inherit description;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      restartTriggers = [ knockdConf ];
      path = cfg.extraPackages;

      unitConfig.Documentation = "man:knockd(1)";

      serviceConfig = {
        ExecStart = "${pkgs.knock}/bin/knockd";
        Restart = "always";
        PIDFile = cfg.options.pidfile;
      };
    };
  };
}
