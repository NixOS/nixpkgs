{ config, pkgs, ... }:

with pkgs.lib;

let

  netconfigFile = {
    target = "netconfig";
    source = pkgs.writeText "netconfig" ''
      #
      # The network configuration file. This file is currently only used in
      # conjunction with the TI-RPC code in the libtirpc library.
      #
      # Entries consist of:
      #
      #       <network_id> <semantics> <flags> <protofamily> <protoname> \
      #               <device> <nametoaddr_libs>
      #
      # The <device> and <nametoaddr_libs> fields are always empty in this
      # implementation.
      #
      udp        tpi_clts      v     inet     udp     -       -
      tcp        tpi_cots_ord  v     inet     tcp     -       -
      udp6       tpi_clts      v     inet6    udp     -       -
      tcp6       tpi_cots_ord  v     inet6    tcp     -       -
      rawip      tpi_raw       -     inet      -      -       -
      local      tpi_cots_ord  -     loopback  -      -       -
      unix       tpi_cots_ord  -     loopback  -      -       -
    '';
  };

in

{

  ###### interface

  options = {

    services.rpcbind = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable `rpcbind', an ONC RPC directory service
          notably used by NFS and NIS, and which can be queried
          using the rpcinfo(1) command. `rpcbind` is a replacement for
          `portmap`.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.rpcbind.enable {

    environment.systemPackages = [ pkgs.rpcbind ];

    environment.etc = [ netconfigFile ];

    systemd.services.rpcbind =
      { description = "ONC RPC Directory Service";

        wantedBy = [ "multi-user.target" ];

        requires = [ "basic.target" ];
        after = [ "basic.target" ];

        unitConfig.DefaultDependencies = false; # don't stop during shutdown

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = "@${pkgs.rpcbind}/bin/rpcbind rpcbind";
      };

  };

}
