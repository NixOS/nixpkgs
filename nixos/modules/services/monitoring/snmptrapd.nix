{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.snmptrapd;
  configFile = pkgs.writeText "snmptrapd.conf" ''
    ${cfg.configText}
  '';
in
{
  options.services.snmptrapd = {
    enable = lib.mkEnableOption "snmptrapd";

    package = lib.mkPackageOption pkgs "net-snmp" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        The address to listen on for SNMP trap messages.
      '';
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 162;
      description = ''
        The port to listen on for SNMP trap messages.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open port in firewall for snmptrapd.
      '';
    };

    configText = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        The contents of the snmptrapd.conf. If the {option}`configFile` option
        is set, this value will be ignored.

        Note that the contents of this option will be added to the Nix
        store as world-readable plain text, {option}`configFile` can be used in
        addition to a secret management tool to protect sensitive data, such as
        SNMPv3 authentication and privacy credentials.
      '';
      example = ''
        authCommunity log,execute,net public
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = configFile;
      defaultText = lib.literalMD "The value of {option}`configText`.";
      description = ''
        Path to the snmptrapd.conf file. By default, a config file is
        automatically generated from {option}`configText`.

        Use this option with a secret management tool for SNMPv3 configuration
        containing credentials.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.snmptrapd = {
      description = "Simple Network Management Protocol (SNMP) trap daemon.";
      documentation = [
        "man:snmptrapd(8)"
        "man:snmptrapd.conf(5)"
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "snmptrapd"} -f -Lo -c ${cfg.configFile} ${cfg.listenAddress}:${toString cfg.port}";
      };
    };

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];
  };

  meta.maintainers = [ lib.maintainers.kashu-02 ];
}
