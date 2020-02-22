{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.cde;
in {
  options.services.xserver.desktopManager.cde = {
    enable = mkEnableOption "Common Desktop Environment";
  };

  config = mkIf (xcfg.enable && cfg.enable) {
    services.rpcbind.enable = true;

    services.xinetd.enable = true;
    services.xinetd.services = [
      {
        name = "cmsd";
        protocol = "udp";
        user = "root";
        server = "${pkgs.cdesktopenv}/opt/dt/bin/rpc.cmsd";
        extraConfig = ''
          type  = RPC UNLISTED
          rpc_number  = 100068
          rpc_version = 2-5
          only_from   = 127.0.0.1/0
        '';
      }
    ];

    users.groups.mail = {};
    security.wrappers = {
      dtmail = {
        source = "${pkgs.cdesktopenv}/bin/dtmail";
        group = "mail";
        setgid = true;
      };
    };

    system.activationScripts.setup-cde = ''
      mkdir -p /var/dt/{tmp,appconfig/appmanager}
      chmod a+w+t /var/dt/{tmp,appconfig/appmanager}
    '';

    services.xserver.desktopManager.session = [
    { name = "CDE";
      start = ''
        exec ${pkgs.cdesktopenv}/opt/dt/bin/Xsession
      '';
    }];
  };

  meta.maintainers = [ maintainers.gnidorah ];
}
