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
    connection = mysql://keystone:keystone@localhost/keystone

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

    # TODO: s/Nova/Keystone/
    enableSingleNode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        This option enables Nova, also known as OpenStack Compute,
        a cloud computing system, as a single-machine
        installation.  That is, all of Nova's components are
        enabled on this machine, using SQLite as Nova's database.
        This is useful for evaluating and experimenting with Nova.
        However, for a real cloud computing environment, you'll
        want to enable some of Nova's services on other machines,
        and use a database such as MySQL.
      '';
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
        ie. to provision first resources.''
      '';
    };
  };


  config = mkIf cfg.enableSingleNode {
    # Note: when changing the default, make it conditional on
    # ‘system.stateVersion’ to maintain compatibility with existing
    # systems!
    virtualisation.keystone.package = mkDefault pkgs.keystone;

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
          mysql -u root -N -e "create database keystone;" || true
          mysql -u root -N -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';"
          mysql -u root -N -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';"

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
