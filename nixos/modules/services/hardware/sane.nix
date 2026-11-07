{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.sane;
  sanedCfg = config.services.saned;

  pkg = cfg.backends-package.override {
    scanSnapDriversUnfree = cfg.drivers.scanSnap.enable;
    scanSnapDriversPackage = cfg.drivers.scanSnap.package;
  };
  enabled = cfg.enable || sanedCfg.enable;

  dllConf =
    let
      disableBackend = backend: ''
        grep -w -q '${backend}' $out || { echo '${backend} is not a default plugin in /etc/sane.d/dll.conf'; exit 1; }
        sed -i 's/\b${backend}\b/# ${backend} disabled by nixos config/' $out
      '';
    in
    pkgs.runCommand "sane-dll.conf" { } ''
      cp ${pkg}/etc/sane.d/dll.conf $out
      ${lib.concatMapStrings disableBackend cfg.disabledDefaultBackends}
    '';

  getBackendNames =
    backend:
    backend.saneBackendNames or (throw ''
      ${backend} is configured as a SANE backend, but does not set `passthru.saneBackendNames`.

      If this package comes from nixpkgs, please report an issue; otherwise set `passthru.saneBackendNames`
      to a list of SANE backend names it provides.
    '');
  extraBackendNames = builtins.concatMap getBackendNames cfg.extraBackends;
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

    hardware.sane.extraBackends = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Packages providing extra SANE backends to enable.

        The package needs to provide the `passthru.saneBackendNames` attribute,
        containing a list of backend names.

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
        See `/etc/sane.d/dll.conf` for the list of possible names.
      '';
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
  imports = [
    (lib.mkRemovedOptionModule [
      "hardware"
      "sane"
      "snapshot"
    ] "`hardware.sane.snapshot` did nothing and was removed.")
  ];

  config = lib.mkMerge [
    (lib.mkIf enabled {
      environment.systemPackages = [ pkg ] ++ cfg.extraBackends;
      environment.etc = {
        "sane.d/dll.conf" = lib.mkIf (cfg.disabledDefaultBackends != [ ]) {
          source = dllConf;
        };
        "sane.d/net.conf" = lib.mkIf (cfg.netConf != "" || sanedCfg.enable) {
          text = ''
            ${lib.optionalString sanedCfg.enable "localhost"}
            ${cfg.netConf}
          '';
        };
        "sane.d/saned.conf" = lib.mkIf sanedCfg.enable {
          text = ''
            localhost
            ${sanedCfg.extraConfig}
          '';
        };
        "sane.d/dll.d/nixos.conf" = lib.mkIf (extraBackendNames != [ ]) {
          text = lib.concatStringsSep "\n" extraBackendNames;
        };
      };
      services.udev.packages = [ pkg ] ++ cfg.extraBackends;
      # sane sets up udev rules that tag scanners with `uaccess`. This way, physically logged in users
      # can access them without belonging to the `scanner` group. However, the `scanner` user used by saned
      # does not have a real logind seat, so `uaccess` is not enough.
      services.udev.extraRules = ''
        ENV{DEVNAME}!="", ENV{libsane_matched}=="yes", RUN+="${pkgs.acl}/bin/setfacl -m g:scanner:rw $env{DEVNAME}"
      '';

      users.groups.scanner.gid = config.ids.gids.scanner;
      networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ 8612 ];

      systemd.tmpfiles.rules = [
        "d /var/lock/sane 0770 root scanner - -"
      ];
    })

    (lib.mkIf sanedCfg.enable {
      networking.firewall.connectionTrackingModules = [ "sane" ];

      systemd.services."saned@" = {
        description = "Scanner Service";
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
