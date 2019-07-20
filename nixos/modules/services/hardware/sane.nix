{ config, lib, pkgs, ... }:

with lib;

let

  pkg = if config.hardware.sane.snapshot
    then pkgs.sane-backends-git
    else pkgs.sane-backends;

  sanedConf = pkgs.writeTextFile {
    name = "saned.conf";
    destination = "/etc/sane.d/saned.conf";
    text = ''
      localhost
      ${config.services.saned.extraConfig}
    '';
  };

  netConf = pkgs.writeTextFile {
    name = "net.conf";
    destination = "/etc/sane.d/net.conf";
    text = ''
      ${lib.optionalString config.services.saned.enable "localhost"}
      ${config.hardware.sane.netConf}
    '';
  };

  env = {
    SANE_CONFIG_DIR = config.hardware.sane.configDir;
    LD_LIBRARY_PATH = [ "${saneConfig}/lib/sane" ];
  };

  backends = [ pkg netConf ] ++ optional config.services.saned.enable sanedConf ++ config.hardware.sane.extraBackends;
  saneConfig = pkgs.mkSaneConfig { paths = backends; };

  enabled = config.hardware.sane.enable || config.services.saned.enable;

in

{

  ###### interface

  options = {

    hardware.sane.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable support for SANE scanners.

        <note><para>
          Users in the "scanner" group will gain access to the scanner, or the "lp" group if it's also a printer.
        </para></note>
      '';
    };

    hardware.sane.snapshot = mkOption {
      type = types.bool;
      default = false;
      description = "Use a development snapshot of SANE scanner drivers.";
    };

    hardware.sane.extraBackends = mkOption {
      type = types.listOf types.path;
      default = [];
      description = ''
        Packages providing extra SANE backends to enable.

        <note><para>
          The example contains the package for HP scanners.
        </para></note>
      '';
      example = literalExample "[ pkgs.hplipWithPlugin ]";
    };

    hardware.sane.configDir = mkOption {
      type = types.string;
      internal = true;
      description = "The value of SANE_CONFIG_DIR.";
    };

    hardware.sane.netConf = mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.16";
      description = ''
        Network hosts that should be probed for remote scanners.
      '';
    };

    services.saned.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable saned network daemon for remote connection to scanners.

        saned would be runned from <literal>scanner</literal> user; to allow
        access to hardware that doesn't have <literal>scanner</literal> group
        you should add needed groups to this user.
      '';
    };

    services.saned.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.0/24";
      description = ''
        Extra saned configuration lines.
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf enabled {
      hardware.sane.configDir = mkDefault "${saneConfig}/etc/sane.d";

      environment.systemPackages = backends;
      environment.sessionVariables = env;
      services.udev.packages = backends;

      users.groups."scanner".gid = config.ids.gids.scanner;
    })

    (mkIf config.services.saned.enable {
      networking.firewall.connectionTrackingModules = [ "sane" ];

      systemd.services."saned@" = {
        description = "Scanner Service";
        environment = mapAttrs (name: val: toString val) env;
        serviceConfig = {
          User = "scanner";
          Group = "scanner";
          ExecStart = "${pkg}/bin/saned";
        };
      };

      systemd.sockets.saned = {
        description = "saned incoming socket";
        wantedBy = [ "sockets.target" ];
        listenStreams = [ "0.0.0.0:6566" "[::]:6566" ];
        socketConfig = {
          # saned needs to distinguish between IPv4 and IPv6 to open matching data sockets.
          BindIPv6Only = "ipv6-only";
          Accept = true;
          MaxConnections = 1;
        };
      };

      users.users."scanner" = {
        uid = config.ids.uids.scanner;
        group = "scanner";
      };
    })
  ];

}
