{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.keystone;
  keystoneConf = pkgs.writeText "keystone.conf" ''
    [DEFAULT]
    # TODO: openssl rand -hex 10
    admin_token = ${cfg.adminToken}
    policy_file=${cfg.package}/etc/policy.json

    [database]
    connection = mysql://${cfg.dbUser}:${cfg.dbPassword}@${cfg.dbHost}/${cfg.dbName}

    [paste_deploy]
    config_file = ${cfg.package}/etc/keystone-paste.ini

    ${cfg.extraConfig}
  '';
in {

  options.virtualisation.keystone = {
    package = mkOption {
      type = types.package;
      example = literalExample "pkgs.keystone";
      description = ''
        Keystone package to use.
      '';
    };

    enable = mkOption {
      default = false;
      type = types.bool;
      description = "This option enables Keystone.";
    };

    databaseConnection = mkOption {
      type = types.string;
      description = ''
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Additional text appended to <filename>keystone.conf</filename>,
        the main Keystone configuration file.
      '';
    };

        endpointPublic = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
      '';
    };

    keystoneAdminUsername = mkOption {
      type = types.str;
      default = "admin";
      description = ''
      '';
    };

    keystoneAdminPassword = mkOption {
      type = types.str;
      default = "admin";
      description = ''
      '';
    };

    keystoneAdminTenant = mkOption {
      type = types.str;
      default = "admin";
      description = ''
      '';
    };

    adminToken = mkOption {
      type = types.str;
      default = "mySuperToken";
      description = ''
        This is the admin token used to boostrap keystone,
        ie. to provision first resources.'';
    };

    dbHost = mkOption {
      default = "localhost";
      description = "The location of the database server.";
      example = "localhost";
    };
    dbName = mkOption {
      default = "keystone";
      description = "Name of the database that holds the Keystone data.";
      example = "localhost";
    };
    dbUser = mkOption {
      default = "keystone";
      description = "The dbUser, read: the username, for the database.";
      example = "keystone";
    };
    dbPassword = mkOption {
      default = "keystone";
      description = "The mysql password to the respective dbUser.";
      example = "keystone";
    };

  };


  config = mkIf cfg.enable {
    # Note: when changing the default, make it conditional on
    # ‘system.stateVersion’ to maintain compatibility with existing
    # systems!
    virtualisation.keystone.package = mkDefault pkgs.keystone;

    # TODO: don't enable mysql if dbHost is not localhost
    services.mysql.enable = mkDefault true;
    services.mysql.package = mkDefault pkgs.mysql;

    users.extraUsers = [{
      name = "keystone";
      group = "keystone";
    }];
    users.extraGroups = [{
      name = "keystone";
    }];

    systemd.services.keystone-all = {
        description = "OpenStack Keystone Daemon";
        after = [ "mysql.service" "network.target"];
        path = [ cfg.package pkgs.mysql pkgs.curl pkgs.pythonPackages.keystoneclient pkgs.gawk ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -m 755 -p /var/lib/keystone

          # TODO: move out of here
          mysql -u root -N -e "create database ${cfg.dbName};" || true
          mysql -u root -N -e "GRANT ALL PRIVILEGES ON ${cfg.dbName}.* TO '${cfg.dbUser}'@'${cfg.dbHost}' IDENTIFIED BY '${cfg.dbPassword}';"
          mysql -u root -N -e "GRANT ALL PRIVILEGES ON ${cfg.dbName}.* TO '${cfg.dbUser}'@'%' IDENTIFIED BY '${cfg.dbPassword}';"

          # Initialise the database
          ${cfg.package}/bin/keystone-manage --config-file=${keystoneConf} db_sync

          # Set up the keystone's PKI infrastructure
          ${cfg.package}/bin/keystone-manage --config-file=${keystoneConf} pki_setup --keystone-user keystone --keystone-group keystone
        '';
	postStart = ''
	    # Wait until the keystone is available for use
            count=0
            while ! curl -s  http://localhost:35357/v2.0 > /dev/null 
            do
                if [ $count -eq 30 ]
                then
                    echo "Tried 30 times, giving up..."
                    exit 1
                fi

                echo "Keystone not yet started. Waiting for 1 second..."
                count=$((count++))
                sleep 1
            done

	    export OS_SERVICE_ENDPOINT=http://localhost:35357/v2.0
	    export OS_SERVICE_TOKEN=${cfg.adminToken}

	    # If the tenant service doesn't exist, we consider
	    # keystone is not initialized
	    if ! keystone tenant-get service
	    then
                keystone tenant-create --name service
                keystone tenant-create --name ${cfg.keystoneAdminTenant}
                # TODO: change password
                keystone user-create --name ${cfg.keystoneAdminUsername} --tenant ${cfg.keystoneAdminTenant} --pass ${cfg.keystoneAdminPassword}
                keystone role-create --name admin
                keystone role-create --name Member
                keystone user-role-add --tenant ${cfg.keystoneAdminTenant} --user ${cfg.keystoneAdminUsername} --role admin
                keystone service-create --type identity --name keystone
                ID=$(keystone service-get keystone | awk '/ id / { print $4 }')
                keystone endpoint-create --region RegionOne --service $ID --publicurl http://${cfg.endpointPublic}:5000/v2.0 --adminurl http://localhost:35357/v2.0 --internalurl http://localhost:5000/v2.0
            fi
	'';
        serviceConfig = {
          PermissionsStartOnly = true; # preStart must be run as root
          TimeoutStartSec = "600"; # 10min for initial db migrations
          User = "keystone";
          Group = "keystone";
          ExecStart = "${cfg.package}/bin/keystone-all --config-file=${keystoneConf}";
        };
      };
  };
}
