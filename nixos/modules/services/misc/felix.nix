# Felix server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.felix;

in

{

  ###### interface

  options = {

    services.felix = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the Apache Felix OSGi service";
      };

      bundles = mkOption {
        default = [ pkgs.felix_remoteshell ];
        description = "List of bundles that should be activated on startup";
      };

      user = mkOption {
        default = "osgi";
        description = "User account under which Apache Felix runs.";
      };

      group = mkOption {
        default = "osgi";
        description = "Group account under which Apache Felix runs.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    users.extraGroups = singleton
      { name = "osgi";
        gid = config.ids.gids.osgi;
      };

    users.extraUsers = singleton
      { name = "osgi";
        uid = config.ids.uids.osgi;
        description = "OSGi user";
        home = "/homeless-shelter";
      };

    jobs.felix =
      { description = "Felix server";

        preStart =
	  ''
	    # Initialise felix instance on first startup
	    if [ ! -d /var/felix ]
	    then
	        # Symlink system files

	        mkdir -p /var/felix
		chown ${cfg.user}:${cfg.group} /var/felix

		for i in ${pkgs.felix}/*
		do
		    if [ "$i" != "${pkgs.felix}/bundle" ]
		    then
		        ln -sfn $i /var/felix/$(basename $i)
		    fi
		done

		# Symlink bundles
		mkdir -p /var/felix/bundle
		chown ${cfg.user}:${cfg.group} /var/felix/bundle

		for i in ${pkgs.felix}/bundle/* ${toString cfg.bundles}
		do
		    if [ -f $i ]
		    then
		        ln -sfn $i /var/felix/bundle/$(basename $i)
		    elif [ -d $i ]
		    then
		        for j in $i/bundle/*
			do
			    ln -sfn $j /var/felix/bundle/$(basename $j)
			done
		    fi
		done
	    fi
	  '';

        script =
          ''
	    cd /var/felix
            ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c '${pkgs.jre}/bin/java -jar bin/felix.jar'
          '';
      };

  };

}
