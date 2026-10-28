{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.cde;
in
{
  options.services.xserver.desktopManager.cde = {
    enable = mkEnableOption "Common Desktop Environment";

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        xclock
        bitmap
        xlsfonts
        xfd
        xrefresh
        xload
        xwininfo
        xdpyinfo
        xwd
        xwud
      ];
      defaultText = literalExpression ''
        with pkgs; [
          xclock bitmap xlsfonts xfd xrefresh xload xwininfo xdpyinfo xwd xwud
        ]
      '';
      description = ''
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

    users.groups.mail = { };
    security.wrappers = {
      dtmail = {
        setgid = true;
        owner = "root";
        group = "mail";
        source = "${pkgs.cdesktopenv}/bin/dtmail";
      };
    };

    systemd.tmpfiles.settings."10-cde" = {
      "/var/dt".d.mode = "0755";
      "/var/dt/tmp".d.mode = "1777";
      "/var/dt/appconfig".d.mode = "0755";
      "/var/dt/appconfig/appmanager".d.mode = "1777";
    };

    services.xserver.desktopManager.session = [
      {
        name = "CDE";
        start = ''
          exec ${pkgs.cdesktopenv}/bin/Xsession
        '';
      }
    ];
  };

  meta.maintainers = [ ];
}
