{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.cde;
in {
  options.services.xserver.desktopManager.cde = {
    enable = mkEnableOption (lib.mdDoc "Common Desktop Environment");

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs.xorg; [
        xclock bitmap xlsfonts xfd xrefresh xload xwininfo xdpyinfo xwd xwud
      ];
      defaultText = literalExpression ''
        with pkgs.xorg; [
          xclock bitmap xlsfonts xfd xrefresh xload xwininfo xdpyinfo xwd xwud
        ]
      '';
      description = lib.mdDoc ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf (xcfg.enable && cfg.enable) {
    environment.systemPackages = cfg.extraPackages;

    services.rpcbind.enable = true;

    services.xinetd.enable = true;
    services.xinetd.services = [
      {
        name = "cmsd";
        protocol = "udp";
        user = "root";
        server = "${pkgs.cdesktopenv}/bin/rpc.cmsd";
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
        setgid = true;
        owner = "root";
        group = "mail";
        source = "${pkgs.cdesktopenv}/bin/dtmail";
      };
    };

    system.activationScripts.setup-cde = ''
      mkdir -p /var/dt/{tmp,appconfig/appmanager}
      chmod a+w+t /var/dt/{tmp,appconfig/appmanager}
    '';

    services.xserver.desktopManager.session = [
    { name = "CDE";
      start = ''
        exec ${pkgs.cdesktopenv}/bin/Xsession
      '';
    }];
  };

  meta.maintainers = [ ];
}
