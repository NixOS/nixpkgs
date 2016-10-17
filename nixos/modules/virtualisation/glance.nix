{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.glance;
  commonConf = ''
    [database]
    connection = mysql://glance:glance@localhost/glance
    notification_driver = noop

    [keystone_authtoken]
    auth_uri = http://localhost:5000
    auth_url = http://localhost:35357
    auth_plugin = password
    project_name = service
    project_domain_id = default
    user_domain_id = default
    username = glance
    password = asdasd

    [glance_store]
    default_store = file
    filesystem_store_datadir = /var/lib/glance/images/
  '';
  glanceApiConf = pkgs.writeText "glance-api.conf" ''
    ${commonConf}

    [paste_deploy]
    flavor = keystone
    config_file = ${cfg.package}/etc/glance-api-paste.ini
  '';
  glanceRegistryConf = pkgs.writeText "glance-registry.conf" ''
    ${commonConf}

    [paste_deploy]
    config_file = ${cfg.package}/etc/glance-registry-paste.ini
  '';
in {

  options.virtualisation.glance = {
    package = mkOption {
      type = types.package;
      example = literalExample "pkgs.glance";
      description = ''
        Glance package to use.
      '';
    };

    # TODO: s/Nova/Glance/
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
  };

  config = mkIf cfg.enableSingleNode {
    # Note: when changing the default, make it conditional on
    # ‘system.stateVersion’ to maintain compatibility with existing
    # systems!
    virtualisation.glance.package = mkDefault pkgs.glance;

    users.extraUsers = [{
      name = "glance";
      group = "glance";
    }];
    users.extraGroups = [{
      name = "glance";
    }];

    systemd.services.glance-registry = {
      description = "OpenStack Glance Registry Daemon";
      after = [ "mysql.service" "network.target"];
      path = [ cfg.package pkgs.mysql pkgs.curl pkgs.pythonPackages.keystoneclient pkgs.gawk ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 775 -p /var/lib/glance/{images,scrubber,image_cache}
        chown glance:glance /var/lib/glance/{images,scrubber,image_cache}

        # TODO: move out of here
        mysql -u root -N -e "create database glance;" || true
        mysql -u root -N -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'glance';"
        mysql -u root -N -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glance';"

        # Initialise the database
        ${cfg.package}/bin/glance-manage --config-file=${glanceApiConf} --config-file=${glanceRegistryConf} db_sync
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

	export OS_AUTH_URL=http://localhost:5000/v2.0
	export OS_USERNAME=${cfg.keystoneAdminUsername}
	export OS_PASSWORD=${cfg.keystoneAdminPassword}
	export OS_TENANT_NAME=${cfg.keystoneAdminTenant}

        # If the service glance doesn't exist, we consider glance is
        # not initialized
        if ! keystone service-get glance
        then
	    keystone service-create --type image --name glance
	    ID=$(keystone service-get glance | awk '/ id / { print $4 }')
	    keystone endpoint-create --region RegionOne --service $ID --internalurl http://localhost:9292 --adminurl http://localhost:9292 --publicurl http://${cfg.endpointPublic}:9292

	    keystone user-create --name glance --tenant service --pass asdasd
	    keystone user-role-add --tenant service --user glance --role admin
        fi
        '';
      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        TimeoutStartSec = "600"; # 10min for initial db migrations
        User = "glance";
        Group = "glance";
        ExecStart = "${cfg.package}/bin/glance-registry --config-file=${glanceRegistryConf}";
      };
    };
    systemd.services.glance-api = {
      description = "OpenStack Glance API Daemon";
      after = [ "glance-registry.service" "rabbitmq.service" "mysql.service" "network.target"];
      path = [ cfg.package pkgs.mysql ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        User = "glance";
        Group = "glance";
        ExecStart = "${cfg.package}/bin/glance-api --config-file=${glanceApiConf}";
      };
    };
  };

}
