{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.neutron;
  rootwrapConf = pkgs.writeText "rootwrap.conf" ''
    [DEFAULT]
    # List of directories to load filter definitions from (separated by ',').
    # These directories MUST all be only writeable by root !
    filters_path=${package_set}/etc/neutron/rootwrap.d

    # List of directories to search executables in, in case filters do not
    # explicitely specify a full path (separated by ',')
    # If not specified, defaults to system PATH environment variable.
    # These directories MUST all be only writeable by root !
    exec_dirs=/run/current-system/sw/bin/,${utils_env}/bin,${pkgs.coreutils}/bin

    # Enable logging to syslog
    # Default value is False
    use_syslog=False

    # Which syslog facility to use.
    # Valid values include auth, authpriv, syslog, local0, local1...
    # Default value is 'syslog'
    syslog_log_facility=syslog

    # Which messages to log.
    # INFO means log all usage
    # ERROR means only log unsuccessful attempts
    syslog_log_level=ERROR
  '';
  ml2PluginConf = pkgs.writeText "ml2.conf" ''
    [ml2]
    type_drivers = local, flat
    mechanism_drivers = linuxbridge
    extension_drivers = port_security

    [ml2_type_flat]
    flat_networks = public

    [securitygroup]
    enable_ipset = True

    [linux_bridge]
    # TODO: changeme
    physical_interface_mappings = public:enp0s2

    [vxlan]
    enable_vxlan = False

    [agent]
    prevent_arp_spoofing = True

    [securitygroup]
    enable_security_group = True
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

    ${cfg.extraML2Config}
  '';
  neutronConf = pkgs.writeText "neutron.conf" ''
    [DEFAULT]
    policy_file=${package_set}/etc/neutron/policy.json
    core_plugin = ml2
    # TODO: try without
    service_plugins = router
    auth_strategy = keystone
    allow_overlapping_ips = False
    dhcp_agents_per_network = 1
    interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
    dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
    enable_isolated_metadata = True
    external_network_bridge =

    # TODO: changeme
    metadata_proxy_shared_secret = METADATA_SECRET

    notify_nova_on_port_status_changes = True
    notify_nova_on_port_data_changes = True
    nova_url = http://localhost:8774/v2
    nova_admin_username = nova
    nova_admin_password = asdasd
    nova_admin_auth_url = http://localhost:35357/v2.0

    api_paste_config = ${package_set}/etc/neutron/api-paste.ini

    [nova]
    region_name = RegionOne
    project_domain_id = default
    project_name = service
    user_domain_id = default
    password = asdasd
    username = nova
    auth_url = http://localhost:35357
    auth_plugin = password

    [agent]
    root_helper=/var/setuid-wrappers/sudo ${package_set}/bin/neutron-rootwrap ${rootwrapConf}

    [keystone_authtoken]
    auth_uri = http://localhost:5000
    auth_url = http://localhost:35357
    auth_plugin = password
    project_name = service
    project_domain_id = default
    user_domain_id = default
    username = neutron
    password = asdasd

    [database]
    connection = mysql://neutron:neutron@localhost/neutron

    [oslo_concurrency]
    lock_path = /var/lock/neutron

    [oslo_messaging_rabbit]
    rabbit_host = localhost
  '';
  utils_env = pkgs.buildEnv {
    name = "utils";
    paths = with pkgs; [package_set ebtables bridge-utils iproute procps conntrack_tools iputils dnsmasq coreutils  ipset
      (lib.overrideDerivation iptables (attrs: { configureFlags = iptables.configureFlags + '' --disable-nftables''; })) ];
  };
  package_set = pkgs.python.buildEnv.override {
    extraLibs = [ cfg.package ] ++ cfg.extraPackages;
    ignoreCollisions = true;
  };
in {
  options.virtualisation.neutron = {
    package = mkOption {
      type = types.package;
      example = literalExample "pkgs.neutron";
      description = ''
        Neutron package to use.
      '';
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      example = literalExample "pkgs.snabb-neutron";
      default = [ ];
      description = ''
        List of extra Python packages to be installed in all
        Neutron services. Useful for adding additional Neutron drivers.
      '';
    };

    extraML2Config = mkOption {
      type = types.str;
      default = "";
      description = ''
      '';
    };

    # TODO: s/Nova/Neutron/
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
    virtualisation.neutron.package = mkDefault pkgs.neutron;

    # See https://wiki.openstack.org/wiki/Rootwrap
    security.sudo.enable = true;
    security.sudo.extraConfig = ''
      neutron ALL = (root) NOPASSWD: ${package_set}/bin/neutron-rootwrap ${rootwrapConf} *
    '';

    users.extraUsers = [{
      name = "neutron";
      group = "neutron";
    }];
    users.extraGroups = [{
      name = "neutron";
    }];

    systemd.services.neutron-server = {
      description = "OpenStack Neutron Daemon";
      after = [ "rabbitmq.service" "mysql.service" "network.target"];
      path = [ package_set pkgs.mysql pkgs.curl pkgs.pythonPackages.keystoneclient pkgs.gawk ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p /var/lock/neutron /var/lib/neutron
        chown neutron:neutron /var/lock/neutron/ /var/lib/neutron

        # TODO: move out of here
        mysql -u root -N -e "create database neutron;" || true
        mysql -u root -N -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'neutron';"
        mysql -u root -N -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'neutron';"

        # Initialise the database
        ${package_set}/bin/neutron-db-manage --config-file ${neutronConf} --config-file ${ml2PluginConf} upgrade head
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

        # If the service neutron doesn't exist, we consider neutron is
        # not initialized
        if ! keystone service-get neutron
        then
	    keystone service-create --type network --name neutron
	    ID=$(keystone service-get neutron | awk '/ id / { print $4 }')
	    keystone endpoint-create --region RegionOne --service $ID --internalurl http://localhost:9696 --adminurl http://localhost:9696 --publicurl http://${cfg.endpointPublic}:9696

	    keystone user-create --name neutron --tenant service --pass asdasd
	    keystone user-role-add --tenant service --user neutron --role admin
        fi
        '';
      serviceConfig = {
        TimeoutStartSec = "600"; # 10min for initial db migrations
        ExecStart = "${package_set}/bin/neutron-server --config-file=${neutronConf} --config-file=${ml2PluginConf}";
      };
    };

    systemd.services.neutron-dhcp-agent = {
      description = "OpenStack Neutron DHCP Agent";
      after = [ "rabbitmq.service" "neutron-server.service" "mysql.service" "network.target"];
      path = [ utils_env pkgs.coreutils  ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "neutron";
        Group = "neutron";
        ExecStart = "${package_set}/bin/neutron-dhcp-agent --config-file=${neutronConf} --config-file=${ml2PluginConf}";
      };
    };

    systemd.services.neutron-metadata-agent = {
      description = "OpenStack Neutron Metadata Agent";
      after = [ "rabbitmq.service" "neutron-server.service" "mysql.service" "network.target"];
      path = [ package_set pkgs.mysql ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "neutron";
        Group = "neutron";
        ExecStart = "${package_set}/bin/neutron-metadata-agent --config-file=${neutronConf} --config-file=${ml2PluginConf}";
      };
    };

    systemd.services.neutron-linuxbridge-agent = {
      description = "OpenStack Neutron LinuxBridge Agent";
      after = [ "rabbitmq.service" "neutron-server.service" "mysql.service" "network.target"];
      path = [ utils_env ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "neutron";
        Group = "neutron";
        ExecStart = "${package_set}/bin/neutron-linuxbridge-agent --config-file=${neutronConf} --config-file=${ml2PluginConf}";
      };
    };

    systemd.services.neutron-l3-agent = {
      description = "OpenStack Neutron L3 Agent";
      after = [ "rabbitmq.service" "neutron-server.service" "mysql.service" "network.target"];
      path = [ utils_env ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "neutron";
        Group = "neutron";
        ExecStart = "${package_set}/bin/neutron-l3-agent --config-file=${neutronConf} --config-file=${ml2PluginConf}";
      };
    };
  };

}
