# Module for Nova, a.k.a. OpenStack Compute.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.nova;

  nova = pkgs.nova;

  novaConf = pkgs.writeText "nova.conf"
    ''
      --nodaemon
      --verbose
      ${cfg.extraConfig}
    '';

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

    virtualisation.nova.extraConfig =
      mkOption {
        default = "";
        description =
          ''
            Additional text appended to <filename>nova.conf</filename>,
            the main Nova configuration file.
          '';
      };

  };


  ###### implementation

  config = mkIf cfg.enableSingleNode {

    environment.systemPackages = [ nova pkgs.euca2ools pkgs.novaclient ];

    environment.etc =
      [ { source = novaConf;
          target = "nova/nova.conf";
        }
      ];

    # Nova requires libvirtd and RabbitMQ.
    virtualisation.libvirtd.enable = true;
    services.rabbitmq.enable = true;

    # `qemu-nbd' required the `nbd' kernel module.
    boot.kernelModules = [ "nbd" ];

    system.activationScripts.nova =
      ''
        mkdir -m 755 -p /var/lib/nova
        mkdir -m 755 -p /var/lib/nova/networks
        mkdir -m 700 -p /var/lib/nova/instances
        mkdir -m 700 -p /var/lib/nova/keys

        # Allow the CA certificate generation script (called by
        # nova-api) to work.
        mkdir -m 700 -p /var/lib/nova/CA /var/lib/nova/CA/private

        # Initialise the SQLite database.
        ${nova}/bin/nova-manage db sync
      '';

    # `nova-api' receives and executes external client requests from
    # tools such as euca2ools.  It listens on port 8773 (XML) and 8774
    # (JSON).
    jobs.nova_api =
      { name = "nova-api";

        description = "Nova API service";

        startOn = "ip-up";

        # `openssl' is required to generate the CA.  `openssh' is
        # required to generate key pairs.
        path = [ pkgs.openssl config.programs.ssh.package pkgs.bash ];

        respawn = false;

        exec = "${nova}/bin/nova-api --flagfile=${novaConf} --api_paste_config=${nova}/etc/nova/api-paste.ini";
      };

    # `nova-objectstore' is a simple image server.  Useful if you're
    # not running the OpenStack Imaging Service (Swift).  It serves
    # images placed in /var/lib/nova/images/.
    jobs.nova_objectstore =
      { name = "nova-objectstore";

        description = "Nova Simple Object Store Service";

        startOn = "ip-up";

        preStart =
          ''
            mkdir -m 700 -p /var/lib/nova/images
          '';

        exec = "${nova}/bin/nova-objectstore --flagfile=${novaConf}";
      };

    # `nova-scheduler' schedules VM execution requests.
    jobs.nova_scheduler =
      { name = "nova-scheduler";

        description = "Nova Scheduler Service";

        startOn = "ip-up";

        exec = "${nova}/bin/nova-scheduler --flagfile=${novaConf}";
      };

    # `nova-compute' starts and manages virtual machines.
    jobs.nova_compute =
      { name = "nova-compute";

        description = "Nova Compute Service";

        startOn = "ip-up";

        path =
          [ pkgs.sudo pkgs.vlan pkgs.nettools pkgs.iptables pkgs.qemu_kvm
            pkgs.e2fsprogs pkgs.utillinux pkgs.multipath-tools pkgs.iproute
            pkgs.bridge-utils
          ];

        exec = "${nova}/bin/nova-compute --flagfile=${novaConf}";
      };

    # `nova-network' manages networks and allocates IP addresses.
    jobs.nova_network =
      { name = "nova-network";

        description = "Nova Network Service";

        startOn = "ip-up";

        path =
          [ pkgs.sudo pkgs.vlan pkgs.dnsmasq pkgs.nettools pkgs.iptables
            pkgs.iproute pkgs.bridge-utils pkgs.radvd
          ];

        exec = "${nova}/bin/nova-network --flagfile=${novaConf}";
      };

  };

}
