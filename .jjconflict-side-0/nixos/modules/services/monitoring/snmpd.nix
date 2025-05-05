{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.snmpd;
  configFile =
    if cfg.configText != "" then
      pkgs.writeText "snmpd.cfg" ''
        ${cfg.configText}
      ''
    else
      null;
in
{
  options.services.snmpd = {
    enable = lib.mkEnableOption "snmpd";

    package = lib.mkPackageOption pkgs "net-snmp" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        The address to listen on for SNMP and AgentX messages.
      '';
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 161;
      description = ''
        The port to listen on for SNMP and AgentX messages.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open port in firewall for snmpd.
      '';
    };

    configText = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        The contents of the snmpd.conf. If the {option}`configFile` option
        is set, this value will be ignored.

        Note that the contents of this option will be added to the Nix
        store as world-readable plain text, {option}`configFile` can be used in
        addition to a secret management tool to protect sensitive data.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = configFile;
      defaultText = lib.literalMD "The value of {option}`configText`.";
      description = ''
        Path to the snmpd.conf file. By default, if {option}`configText` is set,
        a config file will be automatically generated.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services."snmpd" = {
      description = "Simple Network Management Protocol (SNMP) daemon.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "snmpd"} -f -Lo -c ${cfg.configFile} ${cfg.listenAddress}:${toString cfg.port}";
      };
    };

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];
  };

  meta.maintainers = [ lib.maintainers.eliandoran ];

}
