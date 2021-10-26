{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.globalprotect;

  execStart = if cfg.csdWrapper == null then
      "${pkgs.globalprotect-openconnect}/bin/gpservice"
    else
      "${pkgs.globalprotect-openconnect}/bin/gpservice --csd-wrapper=${cfg.csdWrapper}";
in

{
  options.services.globalprotect = {
    enable = mkEnableOption "globalprotect";

    csdWrapper = mkOption {
      description = ''
        A script that will produce a Host Integrity Protection (HIP) report,
        as described at <link xlink:href="https://www.infradead.org/openconnect/hip.html" />
      '';
      default = null;
      example = literalExpression ''"''${pkgs.openconnect}/libexec/openconnect/hipreport.sh"'';
      type = types.nullOr types.path;
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.globalprotect-openconnect ];

    systemd.services.gpservice = {
      description = "GlobalProtect openconnect DBus service";
      serviceConfig = {
        Type="dbus";
        BusName="com.yuezk.qt.GPService";
        ExecStart=execStart;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
  };
}
