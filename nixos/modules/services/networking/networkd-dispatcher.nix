{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.networkd-dispatcher;
in {
  options = {
    services.networkd-dispatcher = {

      enable = mkEnableOption (mdDoc ''
        Networkd-dispatcher service for systemd-networkd connection status
        change. See [https://gitlab.com/craftyguy/networkd-dispatcher](upstream instructions)
        for usage.
      '');

      scriptDir = mkOption {
        type = types.path;
        default = "/var/lib/networkd-dispatcher";
        description = mdDoc ''
          This directory is used for keeping various scripts read and run by
          networkd-dispatcher. See [https://gitlab.com/craftyguy/networkd-dispatcher](upstream instructions)
          for directory structure and script usage.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd = {

      packages = [ pkgs.networkd-dispatcher ];
      services.networkd-dispatcher = {
        wantedBy = [ "multi-user.target" ];
        # Override existing ExecStart definition
        serviceConfig.ExecStart = [
          ""
          "${pkgs.networkd-dispatcher}/bin/networkd-dispatcher -v --script-dir ${cfg.scriptDir} $networkd_dispatcher_args"
        ];
      };

      # Directory structure required according to upstream instructions
      # https://gitlab.com/craftyguy/networkd-dispatcher
      tmpfiles.rules = [
        "d '${cfg.scriptDir}'               0750 root root - -"
        "d '${cfg.scriptDir}/routable.d'    0750 root root - -"
        "d '${cfg.scriptDir}/dormant.d'     0750 root root - -"
        "d '${cfg.scriptDir}/no-carrier.d'  0750 root root - -"
        "d '${cfg.scriptDir}/off.d'         0750 root root - -"
        "d '${cfg.scriptDir}/carrier.d'     0750 root root - -"
        "d '${cfg.scriptDir}/degraded.d'    0750 root root - -"
        "d '${cfg.scriptDir}/configuring.d' 0750 root root - -"
        "d '${cfg.scriptDir}/configured.d'  0750 root root - -"
      ];

    };


  };
}

