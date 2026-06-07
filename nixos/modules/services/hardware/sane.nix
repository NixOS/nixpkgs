{
  config,
  lib,
  pkgs,
  ...
}:
let

  pkg = config.hardware.sane.backends-package.override {
    scanSnapDriversUnfree = config.hardware.sane.drivers.scanSnap.enable;
    scanSnapDriversPackage = config.hardware.sane.drivers.scanSnap.package;
  };

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
    SANE_CONFIG_DIR = "/etc/sane-config";
    LD_LIBRARY_PATH = [ "/etc/sane-libs" ];
  };

  backends = [
    pkg
    netConf
  ]
  ++ lib.optional config.services.saned.enable sanedConf
  ++ config.hardware.sane.extraBackends;
  saneConfig = pkgs.mkSaneConfig {
    paths = backends;
    inherit (config.hardware.sane) disabledDefaultBackends;
  };

  enabled = config.hardware.sane.enable || config.services.saned.enable;

in

{

  ###### interface

  options = {

    hardware.sane.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable support for SANE scanners.

        ::: {.note}
        Users in the "scanner" group will gain access to the scanner, or the "lp" group if it's also a printer.
        :::
      '';
    };

    hardware.sane.backends-package = lib.mkPackageOption pkgs "sane-backends" { };

    hardware.sane.snapshot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use a development snapshot of SANE scanner drivers.";
    };

    hardware.sane.extraBackends = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Packages providing extra SANE backends to enable.

        ::: {.note}
        The example contains the package for HP scanners, and the package for
        Apple AirScan and Microsoft WSD support (supports many
        vendors/devices).
        :::
      '';
      example = lib.literalExpression "[ pkgs.hplipWithPlugin pkgs.sane-airscan ]";
    };

    hardware.sane.disabledDefaultBackends = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "v4l" ];
      description = ''
        Names of backends which are enabled by default but should be disabled.
        See `$SANE_CONFIG_DIR/dll.conf` for the list of possible names.
      '';
    };

    hardware.sane.configDir = lib.mkOption {
      type = lib.types.str;
      internal = true;
      description = "The value of SANE_CONFIG_DIR.";
    };

    hardware.sane.netConf = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "192.168.0.16";
      description = ''
        Network hosts that should be probed for remote scanners.
      '';
    };

    hardware.sane.drivers.scanSnap.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable drivers for the Fujitsu ScanSnap scanners.

        The driver files are unfree and extracted from the Windows driver image.
      '';
    };

    hardware.sane.drivers.scanSnap.package = lib.mkPackageOption pkgs [ "sane-drivers" "epjitsu" ] {
      extraDescription = ''
        Useful if you want to extract the driver files yourself.

        The process is described in the {file}`/etc/sane.d/epjitsu.conf` file in
        the `sane-backends` package.
      '';
    };

    hardware.sane.openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports needed for discovery of scanners on the local network, e.g.
        needed for Canon scanners (BJNP protocol).
      '';
    };

    services.saned.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable saned network daemon for remote connection to scanners.

        saned would be run from `scanner` user; to allow
        access to hardware that doesn't have `scanner` group
        you should add needed groups to this user.
      '';
    };

    services.saned.extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "192.168.0.0/24";
      description = ''
        Extra saned configuration lines.
      '';
    };

  };

  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf enabled {
      hardware.sane.configDir = lib.mkDefault "${saneConfig}/etc/sane.d";

      environment.systemPackages = backends;
      environment.sessionVariables = env;
      environment.etc."sane-config".source = config.hardware.sane.configDir;
      environment.etc."sane-libs".source = "${saneConfig}/lib/sane";
      services.udev.packages = backends;
      # sane sets up udev rules that tag scanners with `uaccess`. This way, physically logged in users
      # can access them without belonging to the `scanner` group. However, the `scanner` user used by saned
      # does not have a real logind seat, so `uaccess` is not enough.
      services.udev.extraRules = ''
        ENV{DEVNAME}!="", ENV{libsane_matched}=="yes", RUN+="${pkgs.acl}/bin/setfacl -m g:scanner:rw $env{DEVNAME}"
      '';

      users.groups.scanner.gid = config.ids.gids.scanner;
      networking.firewall.allowedUDPPorts = lib.mkIf config.hardware.sane.openFirewall [ 8612 ];

      systemd.tmpfiles.rules = [
        "d /var/lock/sane 0770 root scanner - -"
      ];
    })

    (lib.mkIf config.services.saned.enable {
      networking.firewall.connectionTrackingModules = [ "sane" ];

      systemd.services."saned@" = {
        description = "Scanner Service";
        environment = lib.mapAttrs (name: val: toString val) env;
        serviceConfig = {
          User = "scanner";
          Group = "scanner";
          ExecStart = "${pkg}/bin/saned";
        };
      };

      systemd.sockets.saned = {
        description = "saned incoming socket";
        wantedBy = [ "sockets.target" ];
        listenStreams = [
          "0.0.0.0:6566"
          "[::]:6566"
        ];
        socketConfig = {
          # saned needs to distinguish between IPv4 and IPv6 to open matching data sockets.
          BindIPv6Only = "ipv6-only";
          Accept = true;
          MaxConnections = 64;
        };
      };

      users.users.scanner = {
        uid = config.ids.uids.scanner;
        group = "scanner";
        extraGroups = [ "lp" ] ++ lib.optionals config.services.avahi.enable [ "avahi" ];
      };
    })
  ];

}
