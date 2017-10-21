{ config, lib, pkgs, ... }:

with lib; with import ./common.nix {inherit lib;};

let
  cfg = config.virtualisation.openstack.keystone;
  keystoneConfTpl = pkgs.writeText "keystone.conf" ''
    [DEFAULT]
    admin_token = ${cfg.adminToken.pattern}
    policy_file=${cfg.package}/etc/policy.json

    [database]

    connection = "mysql://${cfg.database.user}:${cfg.database.password.pattern}@${cfg.database.host}/${cfg.database.name}"

    [paste_deploy]
    config_file = ${cfg.package}/etc/keystone-paste.ini

    ${cfg.extraConfig}
  '';
  keystoneConf = "/var/lib/keystone/keystone.conf";

in {
  options.virtualisation.openstack.keystone = {
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
      description = ''
        Enable Keystone, the OpenStack Identity Service
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

    adminToken = mkSecretOption {
      name = "adminToken";
      description = ''
        This is the admin token used to boostrap keystone,
        ie. to provision first resources.
      '';
    };

    bootstrap = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Bootstrap the Keystone service by creating the service
          tenant, an admin account and a public endpoint. This options
          provides a ready-to-use admin account. This is only done at
          the first Keystone execution by the systemd post start.

          Note this option is a helper for setting up development or
          testing environments.
        '';
      };

      endpointPublic = mkOption {
        type = types.str;
        default = "http://localhost:5000/v2.0";
        description = ''
          The public identity endpoint. The link <link
          xlink:href="http://docs.openstack.org/liberty/install-guide-rdo/keystone-services.html">
          create keystone endpoint</link> provides more informations
          about that.
        '';
      };

      adminUsername = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          A keystone admin username.
        '';
      };

      adminPassword = mkSecretOption {
        name = "keystoneAdminPassword";
        description = ''
          The keystone admin user's password.
        '';
      };

      adminTenant = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          A keystone admin tenant name.
        '';
      };
    };

    database = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host of the database.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "keystone";
        description = ''
          Name of the existing database.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "keystone";
        description = ''
          The database user. The user must exist and has access to
          the specified database.
        '';
      };
      password = mkSecretOption {
        name = "mysqlPassword";
        description = "The database user's password";};
    };
  };

  config = mkIf cfg.enable {
    # Note: when changing the default, make it conditional on
    # ‘system.stateVersion’ to maintain compatibility with existing
    # systems!
    virtualisation.openstack.keystone.package = mkDefault pkgs.keystone;

    users.extraUsers = [{
      name = "keystone";
      group = "keystone";
      uid = config.ids.uids.keystone;
    }];
    users.extraGroups = [{
      name = "keystone";
      gid = config.ids.gids.keystone;
    }];

    systemd.services.keystone-all = {
        description = "OpenStack Keystone Daemon";
        after = [ "network.target"];
        path = [ cfg.package pkgs.mysql pkgs.curl pkgs.pythonPackages.keystoneclient pkgs.gawk ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -m 755 -p /var/lib/keystone

          cp ${keystoneConfTpl} ${keystoneConf};
          chown keystone:keystone ${keystoneConf};
          chmod 640 ${keystoneConf}

          ${replaceSecret cfg.database.password keystoneConf}
          ${replaceSecret cfg.adminToken keystoneConf}

          # Initialise the database
          ${cfg.package}/bin/keystone-manage --config-file=${keystoneConf} db_sync
          # Set up the keystone's PKI infrastructure
          ${cfg.package}/bin/keystone-manage --config-file=${keystoneConf} pki_setup --keystone-user keystone --keystone-group keystone
        '';
        postStart = optionalString cfg.bootstrap.enable ''
          set -eu
          # Wait until the keystone is available for use
          count=0
          while ! curl --fail -s  http://localhost:35357/v2.0 > /dev/null 
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

          # We use the service token to create a first admin user
          export OS_SERVICE_ENDPOINT=http://localhost:35357/v2.0
          export OS_SERVICE_TOKEN=${getSecret cfg.adminToken}

          # If the tenant service doesn't exist, we consider
          # keystone is not initialized
          if ! keystone tenant-get service
          then
              keystone tenant-create --name service
              keystone tenant-create --name ${cfg.bootstrap.adminTenant}
              keystone user-create --name ${cfg.bootstrap.adminUsername} --tenant ${cfg.bootstrap.adminTenant} --pass ${getSecret cfg.bootstrap.adminPassword}
              keystone role-create --name admin
              keystone role-create --name Member
              keystone user-role-add --tenant ${cfg.bootstrap.adminTenant} --user ${cfg.bootstrap.adminUsername} --role admin
              keystone service-create --type identity --name keystone
              ID=$(keystone service-get keystone | awk '/ id / { print $4 }')
              keystone endpoint-create --region RegionOne --service $ID --publicurl ${cfg.bootstrap.endpointPublic} --adminurl http://localhost:35357/v2.0 --internalurl http://localhost:5000/v2.0
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
