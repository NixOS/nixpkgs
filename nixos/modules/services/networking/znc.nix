{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.znc;

in

{
  ###### interface
  options = {
    services.znc.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the ZNC IRC bouncer. ZNC edits its configuration
        at runtime so the inital configuration must be generated manually.
         Use <literal>znc --datadir /var/lib/znc/ --makeconf</literal> to
	create a configuration at <literal>/var/lib/znc/configs/znc.conf</literal>.
      '';
    };
  };

  ###### implementation

  config = mkIf config.services.znc.enable {

    users.extraUsers = singleton
      { name = "znc";
        uid = config.ids.uids.znc;
        home = "/var/lib/znc";
        createHome = true;
      };

    users.extraGroups = singleton
      { name = "znc";
        gid = config.ids.gids.znc;
      };

    systemd.services.znc = {
      description = "IRC bouncer";
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart  = "${pkgs.znc}/bin/znc -f -d /var/lib/znc";
	ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
	ExecStop   = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        User  = config.ids.uids.znc;
	Group = config.ids.gids.znc;
      };
    };

    system.activationScripts.znc = ''
      ${pkgs.coreutils}/bin/chown -R znc:znc /var/lib/znc
    '';

  };

}