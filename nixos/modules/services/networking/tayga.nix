{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.networking.tayga;

  # Converts an address set to a string
  strAddr = addr: "${addr.address}/${toString addr.prefixLength}";

  configFile = pkgs.writeText "tayga.conf" ''
    tun-device nat64

    ipv4-addr ${cfg.ipv4.address}
    ${optionalString (cfg.ipv6.address != null) "ipv6-addr ${cfg.ipv6.address}"}

    prefix ${strAddr cfg.ipv6.pool}
    dynamic-pool ${strAddr cfg.ipv4.pool}
    data-dir ${cfg.dataDir}
  '';

  makeRouteCommands = oper: ''
    ip addr ${oper} ${cfg.ipv4.router.address} dev nat64
    ip addr ${oper} ${cfg.ipv6.router.address} dev nat64
  '';

  addrOpts = v:
    assert v == 4 || v == 6;
    {
      options = {
        address = mkOption {
          type = types.str;
          description = "IPv${toString v} address.";
        };

        prefixLength = mkOption {
          type = types.addCheck types.int (n: n >= 0 && n <= (if v == 4 then 32 else 128));
          description = ''
            Subnet mask of the interface, specified as the number of
            bits in the prefix (<literal>${if v == 4 then "24" else "64"}</literal>).
          '';
        };
      };
    };

  versionOpts = v: {
    options = {
      router = {
        address = mkOption {
          type = types.str;
          description = "The IPv${toString v} address of the router.";
        };
      };

      address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The source IPv${toString v} address for the Tayga server.";
      };

      pool = mkOption {
        type = with types; nullOr (submodule (addrOpts v));
        description = "The pool of IPv${toString v} addresses to use for translation.";
      };
    };
  };
in
{
  options = {
    services.networking.tayga = {
      enable = mkEnableOption "Tayga";

      package = mkOption {
        type = types.package;
        default = pkgs.tayga;
        defaultText = "pkgs.tayga";
        description = "This option specifies the tayga package to use.";
      };

      ipv4 = mkOption {
        type = types.submodule (versionOpts 4);
        description = "IPv4-specific configuration.";
      };

      ipv6 = mkOption {
        type = types.submodule (versionOpts 6);
        description = "IPv6-specific configuration.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/tayga";
        description = "Directory for persistent data";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tayga = {
      description = "Stateless NAT64 implementation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [ pkgs.iproute ];

      postStart = ''
        ip link set nat64 up
        ${makeRouteCommands "add"}
      '';

      preStop = ''
        ${makeRouteCommands "del"}
        ip link set nat64 down
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tayga -n -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        Restart = "always";
      };
    };
  };
}
