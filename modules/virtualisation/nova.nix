# Module for Nova, a.k.a. OpenStack Compute.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.virtualisation.nova;

  nova = pkgs.nova;

in

{

  ###### interface

  options = {

    virtualisation.nova.enableSingleNode = 
      mkOption {
        default = false;
        description =
          ''
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

  };


  ###### implementation

  config = mkIf cfg.enableSingleNode {

    environment.systemPackages = [ nova ];

    environment.etc =
      [ # The Paste configuration file for nova-api.
        { source = "${nova}/etc/nova/nova-api.conf";
          target = "nova/nova-api.conf";
        }
      ];

    # Nova requires libvirtd and RabbitMQ.
    virtualisation.libvirtd.enable = true;
    services.rabbitmq.enable = true;

    # `qemu-nbd' required the `nbd' kernel module.
    boot.kernelModules = [ "nbd" ];
      
    # `nova-api' receives and executes external client requests from
    # tools such as euca2ools.  It listens on port 8773 (XML) and 8774
    # (JSON).
    jobs.nova_api =
      { name = "nova-api";

        description = "Nova API service";

        startOn = "ip-up";

        exec = "${nova}/bin/nova-api";
      };

    # `nova-objectstore' is a simple image server.  Useful if you're
    # not running the OpenStack Imaging Service (Swift).  It serves
    # images placed in /var/lib/nova/images/.
    jobs.nova_objectstore =
      { name = "nova-objectstore";

        description = "Nova simple object store service";

        startOn = "ip-up";

        exec = "${nova}/bin/nova-objectstore --nodaemon";
      };

    # `nova-scheduler' schedules VM execution requests.
    jobs.nova_scheduler =
      { name = "nova-scheduler";

        description = "Nova scheduler service";

        startOn = "ip-up";

        exec = "${nova}/bin/nova-scheduler --nodaemon --verbose";
      };

    # `nova-compute' starts and manages virtual machines.
    jobs.nova_compute =
      { name = "nova-compute";

        description = "Nova compute service";

        startOn = "ip-up";

        path =
          [ pkgs.sudo pkgs.vlan pkgs.nettools pkgs.iptables pkgs.qemu_kvm
            pkgs.e2fsprogs pkgs.utillinux
          ];

        exec = "${nova}/bin/nova-compute --nodaemon --verbose";
      };

    # `nova-network' manages networks and allocates IP addresses.
    jobs.nova_network =
      { name = "nova-network";

        description = "Nova network service";

        startOn = "ip-up";

        path =
          [ pkgs.sudo pkgs.vlan pkgs.dnsmasq pkgs.nettools pkgs.iptables
            pkgs.iproute pkgs.bridge_utils pkgs.radvd
          ];

        exec = "${nova}/bin/nova-network --nodaemon --verbose";
      };

  };

}
