{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  publicGatewayIp = "203.0.113.1";
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

    ## Use admin login
    export OS_PROJECT_DOMAIN_ID=default
    export OS_USER_DOMAIN_ID=default
    export OS_PROJECT_NAME=admin
    export OS_TENANT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=admin
    export OS_AUTH_URL=http://localhost:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

    ## Verify admin account
    openstack token issue

    ## Verify neutron
    neutron ext-list
    neutron agent-list

    # Create public network
    neutron net-create public --shared --router:external True --provider:physical_network public --provider:network_type flat
    neutron subnet-create public 203.0.113.0/24 --name public --allocation-pool start=203.0.113.101,end=203.0.113.200 --dns-nameserver 8.8.8.8 --gateway ${publicGatewayIp}

    ## Create projects, users and roles for demo project
    openstack project create --domain default --description "Demo Project" demo
    openstack user create --domain default --password asdasd demo
    openstack role create user
    openstack role add --project demo --user demo user

    # Switch to Demo account
    export OS_PROJECT_DOMAIN_ID=default
    export OS_USER_DOMAIN_ID=default
    export OS_PROJECT_NAME=demo
    export OS_TENANT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=asdasd
    export OS_AUTH_URL=http://localhost:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

    ## Verify demo account
    openstack token issue

    ## Add glance image
    glance image-create --name "nixos" --file ${image}/nixos.img --disk-format qcow2 --container-format bare --visibility public
    glance image-list

    ## Verify nova
    # nova service-list # Not allowed
    nova endpoints
    nova image-list

    # Launch an instance
    ssh-keygen -q -N "" -f id_rsa
    nova keypair-add --pub-key id_rsa.pub mykey
    nova keypair-list
    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
    nova boot --flavor m1.tiny --image nixos --security-group default --key-name mykey public-instance

    # TODO: should be moved out of here
    ip route add 203.0.113.0/24 via 203.0.113.1

  '';
in makeTest {
  nodes = {
    allinone = { config, pkgs, ... }:
    {
      virtualisation = {
        keystone.enable = true;
        glance.enableSingleNode = true;
        neutron.enableSingleNode = true;
	neutron.publicInterface = "eth2";
        nova.enableSingleNode = true;
        # openstack needs 2G, 512M is for the nova VM
	# memorySize = 2560; 
        memorySize = 4096; # TODO: remove
	
        diskSize = 4 * 1024;
	qemu.networkingOptions = [
            "-net nic,vlan=0,model=virtio"
            "-net user,vlan=0,hostfwd=tcp::2222-:22\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
	    # We use it for the neutron public interface
	    "-net nic,vlan=0,model=virtio"

          ];
      };

      networking.interfaces.eth2.ip4 = [ { address = publicGatewayIp; prefixLength = 32; } ];
      # We should add the route here
      # ip route add 203.0.113.0/24 via 203.0.113.1

      boot.kernel.sysctl = {
        "net.bridge.bridge-nf-call-arptables" = 1;
        "net.bridge.bridge-nf-call-iptables" = 1;
        "net.bridge.bridge-nf-call-ip6tables" = 1;
        "net.bridge.bridge-nf-filter-vlan-tagged" = 0;
        "net.bridge.bridge-nf-filter-pppoe-tagged" = 0;
      };
      boot.kernelModules = [ "br_netfilter" ];

      nixpkgs.config.allowBroken = true; 

      networking.extraHosts = ''
        127.0.0.1 controller
      '';

      environment.systemPackages = with pkgs.pythonPackages; with pkgs; [
        openstackclient novaclient glanceclient keystoneclient neutronclient
	# TODO REMOVE
	pkgs.tcpdump pkgs.bridge_utils
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
    $allinone->waitUntilSucceeds("OS_PROJECT_DOMAIN_ID=default OS_USER_DOMAIN_ID=default OS_PROJECT_NAME=admin OS_TENANT_NAME=admin OS_USERNAME=admin OS_PASSWORD=admin OS_AUTH_URL=http://localhost:5000/v3 nova list") =~ /ACTIVE/;
    $allinone->waitUntilSucceeds("ping -c 1 203.0.113.102");


  '';
}
