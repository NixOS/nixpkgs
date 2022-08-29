{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.globalprotect;

  execStart =
    if cfg.csdWrapper == null then
      "${pkgs.globalprotect-openconnect}/bin/gpservice"
    else
      "${pkgs.globalprotect-openconnect}/bin/gpservice --csd-wrapper=${cfg.csdWrapper}";
in

{
  options.services.globalprotect = {
    enable = mkEnableOption "globalprotect";

    settings = mkOption {
      description = ''
        GlobalProtect-openconnect configuration. For more information, visit
        <link xlink:href="https://github.com/yuezk/GlobalProtect-openconnect/wiki/Configuration"/>.
      '';
      default = { };
      example = {
        "vpn1.company.com" = {
          openconnect-args = "--script=/path/to/vpnc-script";
        };
      };
      type = types.attrs;
    };

    csdWrapper = mkOption {
      description = lib.mdDoc ''
        A script that will produce a Host Integrity Protection (HIP) report,
        as described at <https://www.infradead.org/openconnect/hip.html>
      '';
      default = null;
      example = literalExpression ''"''${pkgs.openconnect}/libexec/openconnect/hipreport.sh"'';
      type = types.nullOr types.path;
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.globalprotect-openconnect ];

    environment.etc."gpservice/gp.conf".text = lib.generators.toINI { } cfg.settings;

    systemd.services.gpservice = {
      description = "GlobalProtect openconnect DBus service";
      serviceConfig = {
        Type = "dbus";
        BusName = "com.yuezk.qt.GPService";
        ExecStart = execStart;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
  };
}
