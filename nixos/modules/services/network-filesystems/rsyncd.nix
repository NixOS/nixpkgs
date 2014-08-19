{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.rsyncd;

  motdFile = pkgs.writeText "rsyncd-motd" cfg.motd;

  rsyncdCfg = ""
    + optionalString (cfg.motd != "") "motd file = ${motdFile}\n"
    + optionalString (cfg.address != "") "address = ${cfg.address}\n"
    + optionalString (cfg.port != 873) "port = ${toString cfg.port}\n"
    + cfg.extraConfig
    + "\n"
    + flip concatMapStrings cfg.modules (m: "[${m.name}]\n\tpath = ${m.path}\n"
      + optionalString (m.comment != "") "\tcomment = ${m.comment}\n"
      + m.extraConfig
      + "\n"
    );

  rsyncdCfgFile = pkgs.writeText "rsyncd.conf" rsyncdCfg;

in

{
  options = {

    services.rsyncd = {

      enable = mkOption {
        default = false;
	description = "Whether to enable the rsync daemon.";
      };

      motd = mkOption {
        type = types.string;
        default = "";
	description = ''
	  Message of the day to display to clients on each connect.
	  This usually contains site information and any legal notices.
	'';
      };

      port = mkOption {
        default = 873;
	type = types.int;
	description = "TCP port the daemon will listen on.";
      };

      address = mkOption {
        default = "";
	example = "192.168.1.2";
	description = ''
	  IP address the daemon will listen on; rsyncd will listen on
	  all addresses if this is not specified.
	'';
      };

      extraConfig = mkOption {
        type = types.lines;
	default = "";
	description = ''
	  Lines of configuration to add to rsyncd globally.
	  See <literal>man rsyncd.conf</literal> for more options.
	'';
      };

      modules = mkOption {
        default = [ ];
	example = [ 
	  { name = "ftp"; 
	    path = "/home/ftp"; 
	    comment = "ftp export area";
	    extraConfig = ''
	      secrets file = /etc/rsyncd.secrets
	    '';
	  }
	];
	description = "The list of file paths to export.";
	type = types.listOf types.optionSet;

	options = {

	  name = mkOption {
	    example = "ftp";
	    type = types.string;
	    description = "Name of export module.";
	  };

	  comment = mkOption {
	    default = "";
	    description = ''
	      Description string that is displayed next to the module name
	      when clients obtain a list of available modules.
	    '';
	  };

	  path = mkOption {
	    example = "/home/ftp";
	    type = types.string;
	    description = "Directory to make available in this module.";
   	  };

          extraConfig = mkOption {
            type = types.lines;
	    default = "";
            description = ''
	      Lines of configuration to add to this module.
	      See <literal>man rsyncd.conf</literal> for more options.
	    '';
          };
	};
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = singleton
    { source = rsyncdCfgFile;
      target = "rsyncd.conf";
    };

    systemd.services.rsyncd = {
      description = "Rsync daemon";
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.rsync ];

      serviceConfig.ExecStart = "${pkgs.rsync}/bin/rsync --daemon --no-detach";
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
