{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.snmptrapd;

  configFile = pkgs.writeText "snmptrapd.conf" ''
    ${lib.optionalString (cfg.disableAuthorization) "disableAuthorization yes"}
    ${lib.concatMapStringsSep "\n" (
      community: "authCommunity log,execute,net ${community}"
    ) cfg.authCommunity}
    ${cfg.extraConfig}
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
        The standard SNMP trap port is 162 (UDP).
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the configured port in the firewall for snmptrapd.
      '';
    };

    disableAuthorization = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable access control checks. This is useful for testing or
        in trusted environments, but is NOT recommended for production use.

        Starting with Net-SNMP 5.3, access control is enforced by default.
        Without proper configuration, traps will be dropped.
      '';
    };

    authCommunity = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "public" ];
      description = ''
        List of authorized SNMPv1/v2c community strings. This option is
        ignored if {option}`disableAuthorization` is set to true.

        By default, only traps with the 'public' community string are accepted.
        Modify this list to include additional community strings as needed.

        Note that using common community strings like 'public' may pose
        security risks. Consider using more secure and unique community
        strings in production environments.
      '';
      example = [
        "public"
        "private"
        "mySecureCommunity"
      ];
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional configuration directives to include in the snmptrapd.conf
        file. This allows for further customization of snmptrapd beyond the
        options provided by this module.
      '';
      example = ''
        # Log traps to a specific file
        logFile /var/log/snmptrapd.log

        # Enable SNMPv3 support
        createUser myUser MD5 myPassword DES

        # Set up SNMPv3 access control
        authUser log,execute,net myUser
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = configFile;
      defaultText = lib.literalMD "generated from configuration options";
      description = ''
        Path to the snmptrapd.conf file. This takes precedence over
        options like {option}`authCommunity` and {option}`extraConfig`.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.snmptrapd = {
      description = "Simple Network Management Protocol (SNMP) trap daemon";
      documentation = [
        "man:snmptrapd(8)"
        "man:snmptrapd.conf(5)"
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "snmptrapd"} -f -Lo -c ${cfg.configFile} ${cfg.listenAddress}:${toString cfg.port}";
        Restart = "on-failure";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/log" ];
      };
    };

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ kashu-02 ];
}
