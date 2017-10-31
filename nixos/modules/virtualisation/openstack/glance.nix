{ config, lib, pkgs, ... }:

with lib; with import ./common.nix {inherit lib;};

let
  cfg = config.virtualisation.openstack.glance;
  commonConf = ''
    [database]
    connection = "mysql://${cfg.database.user}:${cfg.database.password.pattern}@${cfg.database.host}/${cfg.database.name}"
    notification_driver = noop

    [keystone_authtoken]
    auth_url = ${cfg.authUrl}
    auth_plugin = password
    project_name = service
    project_domain_id = default
    user_domain_id = default
    username = ${cfg.serviceUsername}
    password = ${cfg.servicePassword.pattern}

    [glance_store]
    default_store = file
    filesystem_store_datadir = /var/lib/glance/images/
  '';
  glanceApiConfTpl = pkgs.writeText "glance-api.conf" ''
    ${commonConf}

    [paste_deploy]
    flavor = keystone
    config_file = ${cfg.package}/etc/glance-api-paste.ini
  '';
  glanceRegistryConfTpl = pkgs.writeText "glance-registry.conf" ''
    ${commonConf}

    [paste_deploy]
    config_file = ${cfg.package}/etc/glance-registry-paste.ini
  '';
  glanceApiConf = "/var/lib/glance/glance-api.conf";
  glanceRegistryConf = "/var/lib/glance/glance-registry.conf";

in {
  options.virtualisation.openstack.glance = {
    package = mkOption {
      type = types.package;
      default = pkgs.glance;
      defaultText = "pkgs.glance";
      description = ''
        Glance package to use.
      '';
    };

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        This option enables Glance as a single-machine
        installation. That is, all of Glance's components are
        enabled on this machine. This is useful for evaluating and
        experimenting with Glance. Note we are currently not
        providing any configurations for a multi-node setup.
      '';
    };

    authUrl = mkOption {
      type = types.str;
      default = http://localhost:5000;
      description = ''
        Complete public Identity (Keystone) API endpoint. Note this is
        unversionned.
      '';
    };

    serviceUsername = mkOption {
      type = types.str;
      default = "glance";
      description = ''
        The Glance service username. This user is created if bootstrap
        is enable, otherwise it has to be manually created before
        starting this service.
      '';
    };

    servicePassword = mkSecretOption {
      name = "glanceAdminPassword";
      description = ''
        The Glance service user's password.
      '';
    };

    database = databaseOption "glance";

    bootstrap = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Bootstrap the Glance service by creating the service tenant,
          an admin account and a public endpoint. This option provides
          a ready-to-use glance service. This is only done at the
          first Glance execution by the systemd post start section.
          The keystone admin account is used to create required
          Keystone resource for the Glance service.

          <note><para> This option is a helper for setting up
          development or testing environments.</para></note>
        '';
      };

      endpointPublic = mkOption {
        type = types.str;
        default = "http://localhost:9292";
        description = ''
          The public image endpoint. The link <link
          xlink:href="http://docs.openstack.org/liberty/install-guide-rdo/keystone-services.html">
          create endpoint</link> provides more informations
          about that.
        '';
      };

      keystoneAdminUsername = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          The keystone admin user name used to create the Glance account.
        '';
      };

      keystoneAdminPassword = mkSecretOption {
        name = "keystoneAdminPassword";
        description = ''
          The keystone admin user's password.
        '';
      };

      keystoneAdminTenant = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          The keystone admin tenant used to create the Glance account.
        '';
      };
      keystoneAuthUrl = mkOption {
        type = types.str;
        default = "http://localhost:5000/v2.0";
        description = ''
          The keystone auth url used to create the Glance account.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers = [{
      name = "glance";
      group = "glance";
      uid = config.ids.gids.glance;

    }];
    users.extraGroups = [{
      name = "glance";
      gid = config.ids.gids.glance;
    }];

    systemd.services.glance-registry = {
      description = "OpenStack Glance Registry Daemon";
      after = [ "network.target"];
      path = [ pkgs.curl pkgs.pythonPackages.keystoneclient pkgs.gawk ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 775 -p /var/lib/glance/{images,scrubber,image_cache}
        chown glance:glance /var/lib/glance/{images,scrubber,image_cache}

        # Secret file managment
        cp ${glanceRegistryConfTpl} ${glanceRegistryConf};
        chown glance:glance ${glanceRegistryConf};
        chmod 640 ${glanceRegistryConf}
        ${replaceSecret cfg.database.password glanceRegistryConf}
        ${replaceSecret cfg.servicePassword glanceRegistryConf}

        cp ${glanceApiConfTpl} ${glanceApiConf};
        chown glance:glance ${glanceApiConf};
        chmod 640 ${glanceApiConf}
        ${replaceSecret cfg.database.password glanceApiConf}
        ${replaceSecret cfg.servicePassword glanceApiConf}

        # Initialise the database
        ${cfg.package}/bin/glance-manage --config-file=${glanceApiConf} --config-file=${glanceRegistryConf} db_sync
      '';
      postStart = ''
        set -eu
        export OS_AUTH_URL=${cfg.bootstrap.keystoneAuthUrl}
        export OS_USERNAME=${cfg.bootstrap.keystoneAdminUsername}
        export OS_PASSWORD=${getSecret cfg.bootstrap.keystoneAdminPassword}
        export OS_TENANT_NAME=${cfg.bootstrap.keystoneAdminTenant}

        # Wait until the keystone is available for use
        count=0
        while ! keystone user-get ${cfg.bootstrap.keystoneAdminUsername} > /dev/null
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

        # If the service glance doesn't exist, we consider glance is
        # not initialized
        if ! keystone service-get glance
        then
            keystone service-create --type image --name glance
            ID=$(keystone service-get glance | awk '/ id / { print $4 }')
            keystone endpoint-create --region RegionOne --service $ID --internalurl http://localhost:9292 --adminurl http://localhost:9292 --publicurl ${cfg.bootstrap.endpointPublic}

            keystone user-create --name ${cfg.serviceUsername} --tenant service --pass ${getSecret cfg.servicePassword}
            keystone user-role-add --tenant service --user ${cfg.serviceUsername} --role admin
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
      after = [ "glance-registry.service" "network.target"];
      requires = [ "glance-registry.service" "network.target"]; 
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
