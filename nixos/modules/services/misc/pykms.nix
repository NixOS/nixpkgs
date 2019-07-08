{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pykms;

in {
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  options = {
    services.pykms = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the PyKMS service.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "The IP address on which to listen.";
      };

      port = mkOption {
        type = types.int;
        default = 1688;
        description = "The port on which to listen.";
      };

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Show verbose output.";
      };

      openFirewallPort = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the listening port should be opened automatically.";
      };

      memoryLimit = mkOption {
        type = types.str;
        default = "64M";
        description = "How much memory to use at most.";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewallPort [ cfg.port ];

    systemd.services.pykms = let
      home = "/var/lib/pykms";
    in {
      description = "Python KMS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # python programs with DynamicUser = true require HOME to be set
      environment.HOME = home;
      serviceConfig = with pkgs; {
        DynamicUser = true;
        StateDirectory = baseNameOf home;
        ExecStartPre = "${getBin pykms}/bin/create_pykms_db.sh ${home}/clients.db";
        ExecStart = lib.concatStringsSep " " ([
          "${getBin pykms}/bin/server.py"
          cfg.listenAddress
          (toString cfg.port)
        ] ++ lib.optional cfg.verbose "--verbose");
        WorkingDirectory = home;
        Restart = "on-failure";
        MemoryLimit = cfg.memoryLimit;
      };
    };
  };
}
