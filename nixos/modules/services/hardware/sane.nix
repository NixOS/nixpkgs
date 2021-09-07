{ config, lib, pkgs, ... }:

with lib;

let
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

  saneConfig = pkgs.mkSaneConfig {
    paths = baseDerivs ++ (singleton overridenPkg);
    inherit (config.hardware.sane) disabledDefaultBackends;
  };

  env = {
    SANE_CONFIG_DIR = config.hardware.sane.configDir;
    LD_LIBRARY_PATH = "${saneConfig}/lib/sane";
  };

  overridenPkg = pkgs.sane-backends.override {
    scanSnapDriversUnfree = config.hardware.sane.drivers.scanSnap.enable;
    scanSnapDriversPackage = config.hardware.sane.drivers.scanSnap.package;
  };


  wrappedPkg = pkgs.runCommand "sane-backends-wrapper"
    {
      buildInputs = with pkgs; [ makeWrapper coreutils ];
    }
    (
      let op = overridenPkg;
      in
      ''
        for bin in ${op}/bin/*; do
            fn="$(basename "$bin")"
            makeWrapper $bin $out/bin/"$fn" \
            ${
              concatStringsSep " \\\n "
              (mapAttrsToList (name: value: ''--set ${name} "${value}"'') env)
            }
        done
      ''
    );

  baseDerivs = [ netConf ]
    ++ optional config.services.saned.enable sanedConf
    ++ config.hardware.sane.extraBackends;
  derivsToInstall = baseDerivs ++ (singleton wrappedPkg);

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
      example = literalExpression "[ pkgs.hplipWithPlugin ]";
    };

    hardware.sane.disabledDefaultBackends = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "v4l" ];
      description = ''
        Names of backends which are enabled by default but should be disabled.
        See <literal>$SANE_CONFIG_DIR/dll.conf</literal> for the list of possible names.
      '';
    };

    hardware.sane.configDir = mkOption {
      type = types.str;
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

    hardware.sane.drivers.scanSnap.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable drivers for the Fujitsu ScanSnap scanners.

        The driver files are unfree and extracted from the Windows driver image.
      '';
    };

    hardware.sane.drivers.scanSnap.package = mkOption {
      type = types.package;
      default = pkgs.sane-drivers.epjitsu;
      defaultText = literalExpression "pkgs.sane-drivers.epjitsu";
      description = ''
        Epjitsu driver package to use. Useful if you want to extract the driver files yourself.

        The process is described in the <literal>/etc/sane.d/epjitsu.conf</literal> file in
        the <literal>sane-backends</literal> package.
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

    services.saned.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Configure the firewall to allow saned traffic to pass.";
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

      environment.systemPackages = derivsToInstall;
      services.udev.packages = derivsToInstall;

      users.groups.scanner.gid = config.ids.gids.scanner;
    })

    (mkIf config.services.saned.enable {
      networking.firewall.connectionTrackingModules = [ "sane" ];
      networking.firewall.allowedTCPPorts = mkIf config.services.saned.openFirewall [ 6566 ];

      systemd.services."saned@" = {
        description = "Scanner Service";
        environment = env;
        serviceConfig = {
          User = "scanner";
          Group = "scanner";
          ExecStart = "${wrappedPkg}/bin/saned";
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
