{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vdr;
  libDir = "/var/lib/vdr";
in {

  ###### interface

  options = {

    services.vdr = {
      enable = mkEnableOption (lib.mdDoc "VDR. Please put config into ${libDir}");

      package = mkPackageOption pkgs "vdr" {
        example = "wrapVdr.override { plugins = with pkgs.vdrPlugins; [ hello ]; }";
      };

      videoDir = mkOption {
        type = types.path;
        default = "/srv/vdr/video";
        description = lib.mdDoc "Recording directory";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Additional command line arguments to pass to VDR.";
      };

      enableLirc = mkEnableOption (lib.mdDoc "LIRC");
    };
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [{
    systemd.tmpfiles.rules = [
      "d ${cfg.videoDir} 0755 vdr vdr -"
      "Z ${cfg.videoDir} - vdr vdr -"
    ];

    systemd.services.vdr = {
      description = "VDR";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/vdr \
            --video="${cfg.videoDir}" \
            --config="${libDir}" \
            ${escapeShellArgs cfg.extraArguments}
        '';
        User = "vdr";
        CacheDirectory = "vdr";
        StateDirectory = "vdr";
        Restart = "on-failure";
      };
    };

    users.users.vdr = {
      group = "vdr";
      home = libDir;
      isSystemUser = true;
    };

    users.groups.vdr = {};
  }

  (mkIf cfg.enableLirc {
    services.lirc.enable = true;
    users.users.vdr.extraGroups = [ "lirc" ];
    services.vdr.extraArguments = [
      "--lirc=${config.passthru.lirc.socket}"
    ];
  })]);
}
