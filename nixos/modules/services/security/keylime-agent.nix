{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keylime-agent;
in
{
  options = {
    services.keylime-agent = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to enable keylime-agent service.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/keylime/";
        defaultText = literalExpression "/var/lib/keylime/";
        description = lib.mdDoc "State directory for keylime";
      };

      user = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "User which runs keylime.";
      };

      group = mkOption {
        type = types.str;
        default = "tss";
        description = lib.mdDoc "Group which runs keylime.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."keylime/agent.conf".source = "${pkgs.rust-keylime}/etc/keylime/agent.conf";

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0770 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/cv_ca 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.keylime-agent = {
      description = "Keylime configuration filesystem";
      after = [ "network-online.target" "tpm2-abrmd.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "var-lib-keylime-secure.mount" "tpm2-abrmd.service" ];
      unitConfig = {
        StartLimitIntervalSec = 10;
        StartLimitBurst = 5;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rust-keylime}/bin/keylime_agent";
        TimeoutSec = 60;
        Restart = "on-failure";
        RestartSec = 120;
        Environment="RUST_LOG=keylime_agent=info";
      };
    };

    systemd.mounts = [
      {
        description = "Secure mount for keylime-agent";
        what = "tmpfs";
        where = "${cfg.stateDir}/secure";
        type = "tmpfs";
        options = "mode=0700,size=1m,uid=${cfg.user},gid=${cfg.group}";
      }
    ];

    users.users.keylime = {
      description = "Keylime user";
      group = "${cfg.group}";
      isSystemUser = true;
    };

    users.groups.tss = {};
  };
}

