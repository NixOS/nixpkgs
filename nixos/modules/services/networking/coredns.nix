{ config, lib, pkgs, ... }:
let
  cfg = config.services.coredns;
  configFile = pkgs.writeText "Corefile" cfg.config;
in {
  options.services.coredns = {
    enable = lib.mkEnableOption "Coredns dns server";

    config = lib.mkOption {
      default = "";
      example = ''
        . {
          whoami
        }
      '';
      type = lib.types.lines;
      description = ''
        Verbatim Corefile to use.
        See <https://coredns.io/manual/toc/#configuration> for details.
      '';
    };

    package = lib.mkPackageOption pkgs "coredns" { };

    extraArgs = lib.mkOption {
      default = [];
      example = [ "-dns.port=53" ];
      type = lib.types.listOf lib.types.str;
      description = "Extra arguments to pass to coredns.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.coredns = {
      description = "Coredns dns server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        CapabilityBoundingSet = "cap_net_bind_service";
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        DynamicUser = true;
        ExecStart = "${lib.getBin cfg.package}/bin/coredns -conf=${configFile} ${lib.escapeShellArgs cfg.extraArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
