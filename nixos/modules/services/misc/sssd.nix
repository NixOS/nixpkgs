{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.sssd;
in {
  options = {
    services.sssd = {
      enable = mkEnableOption "Whether to enable the System Security Services daemon.";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.sssd = {
      description = "System Security Services Daemon";
      wantedBy    = [ "multi-user.target" ];
      before = [ "systemd-user-sessions.service" "nss-user-lookup.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wants = [ "nss-user-lookup.target" ];
      script = ''
        export LDB_MODULES_PATH+="''${LDB_MODULES_PATH+:}${pkgs.ldb}/modules/ldb:${pkgs.sssd}/modules/ldb"
        mkdir -p /var/lib/sss/{pubconf,db,mc,pipes,gpo_cache} /var/lib/sss/pipes/private /var/lib/sss/pubconf/krb5.include.d
        "${pkgs.sssd}/bin/sssd" -D
      '';
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/sssd.pid";
      };
    };

  };
}
