{ config, lib, pkgs, ... }:

with lib;

let

  polipoConfig = pkgs.writeText "polipo.conf" config.services.polipo.config;

in

{

  options = {

    services.polipo = {

      enable = mkOption {
        default = false;
	description = "Whether to run the polipo caching web proxy.";
      };

      config = mkOption {
        type = types.lines;
	default = "";
	description = "Polipio configuration";
      };  

    };

  };

  config = mkIf config.services.polipo.enable {

    users.extraUsers = singleton
      { name = "polipo";
        uid = config.ids.uids.polipo;
	description = "Polipo caching proxy user";
	home = "/var/cache/polipo";
	createHome = true;
      };

    systemd.services.polipo = {
      description = "caching web proxy";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target"];
      reloadIfChanged = true;
      serviceConfig = {
        ExecStart  = "${pkgs.polipo}/bin/polipo -c ${polipoConfig}";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
	User = config.ids.uids.polipo;
      };
    };
  };
}