{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  image =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../../nixos/modules/virtualisation/nova-image.nix
        {
          boot.initrd.kernelModules = [ "virtio" "virtio_blk" "virtio_pci" "virtio_ring" ];
          # Hack to make the partition resizing work in QEMU.
          boot.initrd.postDeviceCommands = mkBefore
            ''
              ln -s vda /dev/xvda
              ln -s vda1 /dev/xvda1
            '';
        }
      ];
    }).config.system.build.novaImage;
  bootstrap_sh = pkgs.writeText "bootstrap-openstack.sh" ''
    set -xe
    # Keystone
    ## Create a temporary setup account
    export OS_TOKEN=SuperSecreteKeystoneToken
    export OS_URL=http://localhost:35357/v3
    export OS_IDENTITY_API_VERSION=3

    ## Register keystone service to itself
    openstack service create --name keystone --description "OpenStack Identity" identity
    openstack endpoint create --region RegionOne identity public http://localhost:5000/v2.0
    openstack endpoint create --region RegionOne identity internal http://localhost:5000/v2.0
    openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0

    ## Create projects, users and roles for admin project
    openstack project create --domain default --description "Admin Project" admin
    openstack user create --domain default --password asdasd admin
    openstack role create admin
    openstack role add --project admin --user admin admin

    ## Create service project
    openstack project create --domain default --description "Service Project" service

    ## Create projects, users and roles for service project
    openstack project create --domain default --description "Demo Project" demo
    openstack user create --domain default --password asdasd demo
    openstack role create user
    openstack role add --project demo --user demo user

    ## Use adming login
    unset OS_TOKEN
    unset OS_URL
    export OS_PROJECT_DOMAIN_ID=default
    export OS_USER_DOMAIN_ID=default
    export OS_PROJECT_NAME=admin
    export OS_TENANT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=asdasd
    export OS_AUTH_URL=http://localhost:35357/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

    ## Verify
    openstack token issue

    # Glance
    openstack user create --domain default --password asdasd glance
    openstack role add --project service --user glance admin
    openstack service create --name glance --description "OpenStack Image service" image
    openstack endpoint create --region RegionOne image public http://localhost:9292
    openstack endpoint create --region RegionOne image internal http://localhost:9292
    openstack endpoint create --region RegionOne image admin http://localhost:9292

    ## Verify
    glance image-create --name "nixos" --file ${image}/nixos.img --disk-format qcow2 --container-format bare --visibility public
    glance image-list

    # Nova
    openstack user create --domain default --password asdasd nova
    openstack role add --project service --user nova admin
    openstack service create --name nova --description "OpenStack Compute" compute
    openstack endpoint create --region RegionOne compute public http://localhost:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute internal http://localhost:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute admin http://localhost:8774/v2/%\(tenant_id\)s

    ## Verify
    nova service-list
    nova endpoints
    nova image-list

    # Neutron
    openstack user create --domain default --password asdasd neutron
    openstack role add --project service --user neutron admin
    openstack service create --name neutron --description "OpenStack Networking" network
    openstack endpoint create --region RegionOne network public http://localhost:9696
    openstack endpoint create --region RegionOne network internal http://localhost:9696
    openstack endpoint create --region RegionOne network admin http://localhost:9696

    ## Verify
    neutron ext-list
    neutron agent-list

    # Create public network
    neutron net-create public --shared --provider:physical_network public --provider:network_type flat
    neutron subnet-create public 203.0.113.0/24 --name public --allocation-pool start=203.0.113.101,end=203.0.113.200 --dns-nameserver 8.8.8.8 --gateway 203.0.113.1

    # Use Demo account
    export OS_PROJECT_DOMAIN_ID=default
    export OS_USER_DOMAIN_ID=default
    export OS_PROJECT_NAME=demo
    export OS_TENANT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=asdasd
    export OS_AUTH_URL=http://localhost:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

    # Launch an instance
    ssh-keygen -q -N "" -f id_rsa
    nova keypair-add --pub-key id_rsa.pub mykey
    nova keypair-list
    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
    nova boot --flavor m1.tiny --image nixos --security-group default --key-name mykey public-instance
  '';
in makeTest {
  nodes = {
    allinone = { config, pkgs, ... }:
    {
      virtualisation = {
        keystone.enableSingleNode = true;
        glance.enableSingleNode = true;
        neutron.enableSingleNode = true;
        nova.enableSingleNode = true;
        # openstack needs 2G, 512M is for the nova VM
        memorySize = 2560;
        diskSize = 2 * 1024;
      };

      boot.kernel.sysctl = {
        "net.bridge.bridge-nf-call-arptables" = 1;
        "net.bridge.bridge-nf-call-iptables" = 1;
        "net.bridge.bridge-nf-call-ip6tables" = 1;
        "net.bridge.bridge-nf-filter-vlan-tagged" = 0;
        "net.bridge.bridge-nf-filter-pppoe-tagged" = 0;
      };
      boot.kernelModules = [ "br_netfilter" ];

      networking.extraHosts = ''
        127.0.0.1 controller
      '';

      environment.systemPackages = with pkgs.pythonPackages; with pkgs; [
        openstackclient novaclient glanceclient keystoneclient neutronclient
        # https://github.com/NixOS/nixpkgs/issues/7307#issuecomment-159341755
        # TODO: patch monotonic
        binutils gcc
      ];
    };
  };

  testScript = ''
    startAll;

    $allinone->waitForUnit("keystone-all.service");
    $allinone->waitForUnit("glance-api.service");
    $allinone->waitForUnit("neutron-server.service");
    $allinone->waitForUnit("nova-api.service");

    $allinone->succeed("cat ${bootstrap_sh} > bootstrap.sh");
    $allinone->succeed("chmod +x bootstrap.sh");
    $allinone->succeed("source ./bootstrap.sh");
    $allinone->waitUntilSucceeds("OS_PROJECT_DOMAIN_ID=default OS_USER_DOMAIN_ID=default OS_PROJECT_NAME=demo OS_TENANT_NAME=demo OS_USERNAME=demo OS_PASSWORD=asdasd OS_AUTH_URL=http://localhost:5000/v3 nova list") =~ /ACTIVE/;
  '';
}
