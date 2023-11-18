{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.coredns;
  configFile = pkgs.writeText "Corefile" cfg.config;
in {
  options.services.coredns = {
    enable = mkEnableOption (lib.mdDoc "Coredns dns server");

    config = mkOption {
      default = "";
      example = ''
        . {
          whoami
        }
      '';
      type = types.lines;
      description = lib.mdDoc ''
        Verbatim Corefile to use.
        See <https://coredns.io/manual/toc/#configuration> for details.
      '';
    };

    package = mkOption {
      default = pkgs.coredns;
      defaultText = literalExpression "pkgs.coredns";
      type = types.package;
      description = lib.mdDoc "Coredns package to use.";
    };

    extraArgs = mkOption {
      default = [];
      example = [ "-dns.port=53" ];
      type = types.listOf types.str;
      description = lib.mdDoc "Extra arguments to pass to coredns.";
    };
  };

  config = mkIf cfg.enable {
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
        ExecStart = "${getBin cfg.package}/bin/coredns -conf=${configFile} ${lib.escapeShellArgs cfg.extraArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
