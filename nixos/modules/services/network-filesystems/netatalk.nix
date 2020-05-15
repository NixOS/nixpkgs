{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.netatalk;

  extmapFile = pkgs.writeText "extmap.conf" cfg.extmap;

  afpToString = x: if builtins.typeOf x == "bool"
                   then boolToString x
                   else toString x;

  volumeConfig = name:
    let vol = getAttr name cfg.volumes; in
    "[${name}]\n " + (toString (
       map
         (key: "${key} = ${afpToString (getAttr key vol)}\n")
         (attrNames vol)
    ));

  afpConf = ''[Global]
    extmap file = ${extmapFile}
    afp port = ${toString cfg.port}

    ${cfg.extraConfig}

    ${if cfg.homes.enable then ''[Homes]
    ${optionalString (cfg.homes.path != "") "path = ${cfg.homes.path}"}
    basedir regex = ${cfg.homes.basedirRegex}
    ${cfg.homes.extraConfig}
    '' else ""}

     ${toString (map volumeConfig (attrNames cfg.volumes))}
  '';

  afpConfFile = pkgs.writeText "afp.conf" afpConf;

in

{
  options = {
    services.netatalk = {

      enable = mkEnableOption "the Netatalk AFP fileserver";

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
          type = types.bool;
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
        default = { };
        type = types.attrsOf (types.attrsOf types.unspecified);
        description =
          ''
            Set of AFP volumes to export.
            See <literal>man apf.conf</literal> for more information.
          '';
        example = literalExample ''
          { srv =
             { path = "/srv";
               "read only" = true;
               "hosts allow" = "10.1.0.0/16 10.2.1.100 2001:0db8:1234::/48";
             };
          }
        '';
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
	ExecStartPre = "${pkgs.coreutils}/bin/mkdir -m 0755 -p /var/lib/netatalk/CNID";
        ExecStart  = "${pkgs.netatalk}/sbin/netatalk -F ${afpConfFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP  $MAINPID";
	ExecStop   = "${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        Restart = "always";
        RestartSec = 1;
      };

    };

    security.pam.services.netatalk.unixAuth = true;

  };

}
