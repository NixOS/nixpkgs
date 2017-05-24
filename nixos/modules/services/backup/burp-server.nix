{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.burpServer;

in

{

  ###### interface

  options = {

    services.burpServer = {

      enable = mkEnableOption "Enable burp server and open port 4971 in firewall";

      configFile = mkOption {
        default = "/etc/burp/burp-server.conf";
        type = types.path;
        description = "Path to the burp server config file. You need to provide a fully working configuration file and setup all paths yourself. burp will be start as user burp with group burp and tcp port 4971 will be opened in the firewall. Ensure that you have setup the configuration accordingly.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.burp;
        example = literalExample "pkgs.burp";
        description = ''burp package to use.'';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.burpServer.enable {

    users.extraUsers.burp = {
      group = "burp";
      isSystemUser = true;
      description = "burp server user";
    };

    users.extraGroups.burp = {
      name = "burp";
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.burp = {
      description = "burp server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/burp -F -c ${toString cfg.configFile}";
        User = "burp";
        Group = "burp";
	# Hardening
	PrivateTmp = "yes";
	DevicePolicy = "closed";
	NoNewPrivileges = "yes";
	ProtectSystem = "yes";
	# To be added when there's also a config generator included and the paths are known...
	#ReadWriteDirectories = "/var/spool/burp /etc/burp/CA";
      };

    };
  
    networking.firewall.allowedTCPPorts = [ 4971 ];
  };

}
