{ lib }:

{
  options = {

    interface = lib.mkOption {
      type = lib.types.str;
      description = ''
        Interface for inside_network, bound by vrrp.
      '';
    };

    state = lib.mkOption {
      type = lib.types.enum [
        "MASTER"
        "BACKUP"
      ];
      default = "BACKUP";
      description = ''
        Initial state. As soon as the other machine(s) come up, an election will
        be held and the machine with the highest "priority" will become MASTER.
        So the entry here doesn't matter a whole lot.
      '';
    };

    virtualRouterId = lib.mkOption {
      type = lib.types.ints.between 1 255;
      description = ''
        Arbitrary unique number 1..255. Used to differentiate multiple instances
        of vrrpd running on the same NIC (and hence same socket).
      '';
    };

    priority = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = ''
        For electing MASTER, highest priority wins. To be MASTER, make 50 more
        than other machines.
      '';
    };

    noPreempt = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        VRRP will normally preempt a lower priority machine when a higher
        priority machine comes online. "nopreempt" allows the lower priority
        machine to maintain the master role, even when a higher priority machine
        comes back online. NOTE: For this to work, the initial state of this
        entry must be BACKUP.
      '';
    };

    useVmac = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use VRRP Virtual MAC.
      '';
    };

    vmacInterface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Name of the vmac interface to use. keepalived will come up with a name
        if you don't specify one.
      '';
    };

    vmacXmitBase = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Send/Recv VRRP messages from base interface instead of VMAC interface.
      '';
    };

    unicastSrcIp = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Default IP for binding vrrpd is the primary IP on interface. If you
        want to hide location of vrrpd, use this IP as src_addr for unicast
        vrrp packets.
      '';
    };

    unicastPeers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Do not send VRRP adverts over VRRP multicast group. Instead it sends
        adverts to the following list of ip addresses using unicast design
        fashion. It can be cool to use VRRP FSM and features in a networking
        environment where multicast is not supported! IP Addresses specified can
        IPv4 as well as IPv6.
      '';
    };

    virtualIps = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          import ./virtual-ip-options.nix {
            inherit lib;
          }
        )
      );
      default = [ ];
      # TODO: example
      description = "Declarative vhost config";
    };

    trackScripts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "chk_cmd1"
        "chk_cmd2"
      ];
      description = "List of script names to invoke for health tracking.";
    };

    trackInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "eth0"
        "eth1"
      ];
      description = "List of network interfaces to monitor for health tracking.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra lines to be added verbatim to the vrrp_instance section.
      '';
    };

  };

}
