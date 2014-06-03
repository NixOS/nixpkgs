{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.netatalk;

  extmapFile = pkgs.writeText "extmap.conf" cfg.extmap;

  afpConf = ''[Global]
    extmap file = ${extmapFile}
    afp port = ${toString cfg.port}

    ${if cfg.homes.enable then ''[Homes]
    ${optionalString (cfg.homes.path != "") "path = ${cfg.homes.path}"}
    basedir regex = ${cfg.homes.basedirRegex}
    ${cfg.homes.extraConfig}
    '' else ""}

    ${flip concatMapStrings cfg.volumes (v: ''[${v.name}]
    path = ${v.path}
    ${v.extraConfig}
    '')}
  '';

  afpConfFile = pkgs.writeText "afp.conf" afpConf;

in

{
  options = {
    services.netatalk = {

      enable = mkOption {
          default = false;
          description = "Whether to enable the Netatalk AFP fileserver.";
        };

      port = mkOption {
        default = 548;
        description = "TCP port to be used for AFP.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "uam list = uams_guest.so";
        description = ''
          Lines of configuration to add to the <literal>[Global]</literal> section.
          See <literal>man apf.conf</literal> for more information.
        '';
      };

      homes = {
        enable = mkOption {
          default = false;
          description = "Enable sharing of the UNIX server user home directories.";
        };

        path = mkOption {
          default = "";
          example = "afp-data";
          description = "Share not the whole user home but this subdirectory path.";
        };

        basedirRegex = mkOption {
          example = "/home";
          description = "Regex which matches the parent directory of the user homes.";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Lines of configuration to add to the <literal>[Homes]</literal> section.
            See <literal>man apf.conf</literal> for more information.
          '';
         };
      };

      volumes = mkOption {
        default = [ ];
        description = "List of volumes to export to clients.";
        type = types.listOf types.optionSet;

        options = {
          name = mkOption {
            example = "baz";
	    description = "Share name";
          };
          path = mkOption {
            default = "";
            example = "/foo/bar";
            description = "Directory to share.";
	    # Can be empty, but it's a long story, see man afp.conf.
	  };
          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
	      Lines of configuration to add to this volume section.
	      See <literal>man apf.conf</literal> for more information.
            '';
          };
        };

        example = [
          { name = "My AFP Volume";
            path = "/path/to/volume";
            extraConfig = "hosts allow = 10.1.0.0/16 10.2.1.100 2001:0db8:1234::/48";
          }
        ];
      };

      extmap = mkOption {
        type = types.lines;
	default = "";
	description = ''
	  File name extension mappings.
	  See <literal>man extmap.conf</literal> for more information.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.services.netatalk = {
      description = "Netatalk AFP fileserver for Macintosh clients";
      unitConfig.Documentation = "man:afp.conf(5) man:netatalk(8) man:afpd(8) man:cnid_metad(8) man:cnid_dbd(8)";
      after = [ "network.target" "avahi-daemon.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.netatalk ];

      serviceConfig = {
        Type = "forking";
        GuessMainPID = "no";
        PIDFile = "/run/lock/netatalk";
	ExecStartPre = "${pkgs.coreutils}/bin/mkdir -m 0755 -p /var/lib/netatalk";
        ExecStart  = "${pkgs.netatalk}/sbin/netatalk -F ${afpConfFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP  $MAINPID";
	ExecStop   = "${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        Restart = "always";
        RestartSec = 1;
      };

    };

  };

}