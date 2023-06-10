{ config, lib, options, pkgs, ... }:

with lib;

let

  pkg = pkgs.sane-backends.override {
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
      ${lib.strings.concatStringsSep "\n" config.hardware.sane.remoteHosts}
    '';
  };

  env = {
    SANE_CONFIG_DIR = "/etc/sane-config";
    LD_LIBRARY_PATH = [ "/etc/sane-libs" ];
  };

  backends = [ pkg netConf ]
    ++ optional config.services.saned.enable sanedConf
    ++ (
      if
        # airscan was explicitly disabled
        (options.hardware.sane.airscan.enable == true && config.hardware.sane.airscan.enable == false)
      then
        # ...ensure, the sane-airscan pkg is not listed in extraBackends
        lib.lists.remove pkgs.sane-airscan config.hardware.sane.extraBackends
      else
        # ...just use extraBackends and if airscan is enabled, add sane-airscan
        lib.lists.unique (config.hardware.sane.extraBackends ++ (optional config.hardware.sane.airscan.enable pkgs.sane-airscan))
    );
  saneConfig = pkgs.mkSaneConfig { paths = backends; inherit (config.hardware.sane) disabledDefaultBackends enabledDefaultBackends; };

  enabled = config.hardware.sane.enable || config.services.saned.enable;

  listenStreams = map (address: "${address}:${toString config.services.saned.listenPort}") config.services.saned.listenAddresses;

in

{

  imports = [
    (mkRemovedOptionModule ["hardware" "sane" "netConf"] ''
      The configuration for SANE remote hosts has been moved to the `remoteHosts` option,
      which accepts now a list of IP addresses or hostnames as input.
    '')
  ];

  ###### interface

  options = {

    hardware.sane.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable support for SANE scanners.

        ::: {.note}
        Users in the "scanner" group will gain access to the scanner, or the "lp" group if it's also a printer.
        :::
      '';
    };

    hardware.sane.snapshot = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use a development snapshot of SANE scanner drivers.";
    };

    hardware.sane.extraBackends = mkOption {
      type = types.listOf types.path;
      default = [];
      description = lib.mdDoc ''
        Packages providing extra SANE backends to enable.

        ::: {.note}
        The example contains the package for HP scanners, and the package for
        Apple AirScan and Microsoft WSD support (supports many
        vendors/devices).
        :::
      '';
      example = literalExpression "[ pkgs.hplipWithPlugin pkgs.sane-airscan ]";
    };

    hardware.sane.airscan.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable SANE AirScan, to use network connected scanners based on
        the WSD or eSCL protocol.
      '';
    };

    hardware.sane.disabledDefaultBackends = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "v4l" ];
      description = lib.mdDoc ''
        Names of backends which are enabled by default but should be disabled.
        See `$SANE_CONFIG_DIR/dll.conf` for the list of possible names.
      '';
    };

    hardware.sane.enabledDefaultBackends = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "plustek_pp" ];
      description = lib.mdDoc ''
        Names of backends which are disabled by default but should be enabled.
        See `$SANE_CONFIG_DIR/dll.conf` for the list of possible names.
      '';
    };

    hardware.sane.configDir = mkOption {
      type = types.str;
      internal = true;
      description = lib.mdDoc "The value of SANE_CONFIG_DIR.";
    };

    hardware.sane.remoteHosts = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["192.168.0.16" "192.168.0.38"];
      description = lib.mdDoc ''
        Network hosts providing scanners via a `saned`.
      '';
    };

    hardware.sane.drivers.scanSnap.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = lib.mdDoc ''
        Whether to enable drivers for the Fujitsu ScanSnap scanners.

        The driver files are unfree and extracted from the Windows driver image.
      '';
    };

    hardware.sane.drivers.scanSnap.package = mkOption {
      type = types.package;
      default = pkgs.sane-drivers.epjitsu;
      defaultText = literalExpression "pkgs.sane-drivers.epjitsu";
      description = lib.mdDoc ''
        Epjitsu driver package to use. Useful if you want to extract the driver files yourself.

        The process is described in the `/etc/sane.d/epjitsu.conf` file in
        the `sane-backends` package.
      '';
    };

    hardware.sane.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports needed for discovery of scanners on the local network, e.g.
        needed for Canon scanners (BJNP protocol).
      '';
    };

    services.saned.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable `saned` network daemon to share local scanners with other remote SANE
        instances which utilize the `net` backend to connect to remote `saned` instances.
      '';
    };

    services.saned.extraGroups = mkOption {
      type = types.listOf types.string;
      default = [];
      example = literalExpression "[ \"video\" \"usb\" ]";
      description = lib.mdDoc ''
        Additional groups to which the `saned` service will get access to.
        This might be required, when `saned` needs to access device nodes of scanners
        protected by a group membership.
      '';
    };

    services.saned.listenAddresses = mkOption {
      type = types.listOf types.string;
      default = [ "0.0.0.0" "[::]" ];
      example = [ "192.168.25.3" "[2041:0000:140f::875b:131b]" ];
      description = lib.mdDoc ''
        The IPv4/IPv6 address(es) on which `saned` binds to and listens for incoming requests.
      '';
    };

    # it's a deliberate decision to make `listenPort` read-only,
    # since the `sane-net` backend doesn't allow to define a custom port per remote scanner,
    # but instead relies on `sane-port` from `/etc/services`, which would then have to be the
    # same port for all remote devices.
    # Besides that, `/etc/services` isn't easily customizable on NixOS, but is instead taken
    # as-is from pkgs.iana-etc
    services.saned.listenPort = mkOption {
      type = types.port;
      default = 6566;
      example = literalExpression "7654";
      description = lib.mdDoc ''
        Port on which `saned` listens for incoming requests.
      '';
      readOnly = true;
      visible = false;
    };

    services.saned.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.0/24";
      description = lib.mdDoc ''
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
      environment.etc."sane-config".source = config.hardware.sane.configDir;
      environment.etc."sane-libs".source = "${saneConfig}/lib/sane";
      services.udev.packages = backends;

      users.groups.scanner.gid = config.ids.gids.scanner;
      networking.firewall.allowedUDPPorts = mkIf config.hardware.sane.openFirewall [ 8612 ];
    })

    (mkIf config.services.saned.enable {
      networking.firewall.connectionTrackingModules = [ "sane" ];

      systemd.services."saned@" = {
        description = "Scanner Service";
        environment = mapAttrs (name: val: toString val) env;
        serviceConfig = {
          User = "saned";
          Group = "saned";
          DynamicUser = true;
          SupplementaryGroups = [ "lp" "scanner" ] ++ config.services.saned.extraGroups;
          ExecStart = "${pkg}/bin/saned";
        };
      };

      systemd.sockets.saned = {
        description = "saned incoming socket";
        wantedBy = [ "sockets.target" ];
        listenStreams = listenStreams;
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
        extraGroups = [ "lp" ] ++ optionals config.services.avahi.enable [ "avahi" ];
      };
    })
  ];

}
