{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.expressvpn;

  # ExpressVPN invokes helpers with a conventional, sanitized PATH.
  fhsTools = pkgs.buildEnv {
    name = "expressvpn-fhs-tools";
    paths = with pkgs; [
      cfg.package
      coreutils
      e2fsprogs
      findutils
      gawk
      gnugrep
      iproute2
      iptables
      procps
      psmisc
      systemd
      util-linux
      zip
    ];
    pathsToLink = [ "/bin" ];
  };
in
{
  options.services.expressvpn = {
    enable = lib.mkEnableOption "ExpressVPN daemon and client";

    package = lib.mkPackageOption pkgs "expressvpn" { };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "alice" ];
      description = ''
        Users allowed to control the ExpressVPN daemon.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    environment.systemPackages = [ cfg.package ];

    users.groups.expressvpn.members = cfg.users;
    users.groups.expressvpnhnsd = { };

    # The daemon authorizes clients by checking that /proc/<pid>/exe is below
    # /opt/expressvpn/bin, so this must be a bind mount rather than a symlink.
    systemd.tmpfiles.rules = [
      "d  /opt/expressvpn         0755 root root - -"
      "d  /opt/expressvpn/bin     0755 root root - -"
      "L+ /opt/expressvpn/lib     - - - - ${cfg.package}/lib"
      "L+ /opt/expressvpn/plugins - - - - ${cfg.package}/plugins"
      "L+ /opt/expressvpn/qml     - - - - ${cfg.package}/qml"
      "L+ /opt/expressvpn/share   - - - - ${cfg.package}/share"
      "d  /opt/expressvpn/etc     0750 root expressvpn - -"
      "d  /opt/expressvpn/var     0750 root expressvpn - -"
      "d  /var/lib/expressvpn     0750 root expressvpn - -"
    ];

    systemd.mounts = [
      {
        description = "ExpressVPN binaries";
        what = "${cfg.package}/libexec/expressvpn";
        where = "/opt/expressvpn/bin";
        type = "none";
        options = "bind,ro";
        wantedBy = [ "local-fs.target" ];
      }
    ];

    systemd.services.expressvpn = {
      description = "ExpressVPN Daemon";
      path = [ fhsTools ];
      unitConfig.RequiresMountsFor = "/opt/expressvpn/bin";
      serviceConfig = {
        ExecStart = "/opt/expressvpn/bin/expressvpn-daemon";
        Restart = "always";
        RestartSec = 5;
        BindReadOnlyPaths = [
          "${pkgs.bash}/bin/bash:/bin/bash"
          "${cfg.package}/bin/expressvpn-support-tool:/bin/expressvpn-support-tool"
          "${fhsTools}/bin:/usr/bin"
          "${pkgs.iproute2}/bin/ip:/sbin/ip"
        ];
      };
      environment.LD_LIBRARY_PATH = "${cfg.package}/lib";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ yureien ];
}
