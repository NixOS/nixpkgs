{ config, pkgs, ... }:
with pkgs.lib;
let
  fprotUser = "fprot";
  stateDir = "/var/lib/fprot";
  fprotGroup = fprotUser;
  cfg = config.services.fprot;
in {
  options = {

    services.fprot = {
      updater = {
	enable = mkOption {
	  default = false;
	  description = ''
	    Whether to enable automatic F-Prot virus definitions database updates.
	  '';
	};

	productData = mkOption {
	  default = "${pkgs.fprot}/opt/f-prot/product.data";
	  description = ''
	    product.data file. Defaults to the one supplied with installation package.
	  '';
	};

	frequency = mkOption {
	  default = 30;
	  description = ''
	    Update virus definitions every X minutes.
	  '';
	};

	licenseKeyfile = mkOption {
	  default = "${pkgs.fprot}/opt/f-prot/license.key";
	  description = ''
	    License keyfile. Defaults to the one supplied with installation package.
	  '';
	};

      };
    };
  };

  ###### implementation

  config = mkIf cfg.updater.enable {
    environment.systemPackages = [ pkgs.fprot ];
    environment.etc = singleton {
      source = "${pkgs.fprot}/opt/f-prot/f-prot.conf";
      target = "f-prot.conf";
    };

    users.extraUsers = singleton
      { name = fprotUser;
        uid = config.ids.uids.fprot;
        description = "F-Prot daemon user";
        home = stateDir;
      };

    users.extraGroups = singleton
      { name = fprotGroup;
        gid = config.ids.gids.fprot;
      };

    services.cron.systemCronJobs = [ "*/${toString cfg.updater.frequency} * * * * root start fprot-updater" ];

    jobs = {
      fprot_updater = {
	name = "fprot-updater";
	  task = true;

	  # have to copy fpupdate executable because it insists on storing the virus database in the same dir
          preStart = ''
            mkdir -m 0755 -p ${stateDir}
            chown ${fprotUser}:${fprotGroup} ${stateDir}
	    cp ${pkgs.fprot}/opt/f-prot/fpupdate ${stateDir}
	    ln -sf ${cfg.updater.productData} ${stateDir}/product.data
          '';
	  #setuid = fprotUser;
	  #setgid = fprotGroup;
          exec = "/var/lib/fprot/fpupdate --keyfile ${cfg.updater.licenseKeyfile}";
      }; 
    };

 };

}