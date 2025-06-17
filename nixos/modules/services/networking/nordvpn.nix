{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nordvpn;
  defaultUser = "nordvpn";
  defaultGroup = "nordvpn";

  nordvpn =
    let
      cli = cfg.package.cli.overrideAttrs (old: {
        preBuild =
          if cfg.group == defaultGroup then
            old.preBuild or ""
          else
            ''
              sed -i 's/\[\]string{"nordvpn"}/\[\]string{"${cfg.group}"}/' internal/permissions.go
              sed -i 's/NordvpnGroup = "nordvpn"/NordvpnGroup = "${cfg.group}"/' internal/constants.go
              ${old.preBuild or ""}
            '';
        postFixup = "";
      });
    in
    pkgs.symlinkJoin {
      inherit (cfg.package) pname version meta;
      paths = [
        cli
        cfg.package.gui
      ];
    };
in
{
  options.services.nordvpn = {
    enable = lib.mkEnableOption "Enable NordVPN";
    package = lib.mkPackageOption pkgs "nordvpn" { };
    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
      description = ''
        Group under which `nordvpnd` is run.
        If overriding the default, a group with the same
        name must exist.
      '';
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        User under which `nordvpnd` is run.
        If overriding the default, a user with the same
        name must exist.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    users.groups = lib.mkIf (cfg.group == defaultGroup) {
      ${defaultGroup} = { };
    };

    users.users = lib.mkIf (cfg.user == defaultUser) {
      ${defaultUser} = {
        description = "User that runs nordvpnd.";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    # nordvpnd uses resolved to configure dns
    services.resolved.enable = true;

    # policy that allows nordvpnd to configure dns
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.resolve1.set-dns-servers"
              && subject.isInGroup("${cfg.group}")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    environment.systemPackages = [
      nordvpn
    ];

    systemd.services.nordvpnd = {
      after = [ "network-online.target" ];
      description = "NordVPN daemon.";
      path = (
        with pkgs;
        [
          e2fsprogs
          iproute2
          iptables
          libxslt
          procps
          wireguard-tools
        ]
        ++ [
          nordvpn
        ]
      );
      serviceConfig = {
        # nordvpnd needs CAP_NET_ADMIN to configure network interfaces
        AmbientCapabilities = "CAP_NET_ADMIN";
        CapabilityBoundingSet = "CAP_NET_ADMIN";
        ExecStart = lib.getExe' nordvpn "nordvpnd";
        Group = cfg.group;
        KillMode = "process";
        NonBlocking = true;
        Requires = "nordvpnd.socket";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "nordvpn";
        StateDirectoryMode = "0750";
        User = cfg.user;
      };
      wantedBy = [ "default.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.sockets.nordvpnd = {
      description = "NordVPN Daemon Socket";
      listenStreams = [ "/run/nordvpn/nordvpnd.sock" ];
      partOf = [ "nordvpnd.service" ];
      socketConfig = {
        DirectoryMode = "0750";
        NoDelay = true;
        SocketGroup = cfg.group;
        SocketMode = "0770";
        SocketUser = cfg.user;
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.services.norduserd = {
      after = [ "network-online.target" ];
      description = "NordUserD Service";
      serviceConfig = {
        ExecStart = lib.getExe' nordvpn "norduserd";
        NonBlocking = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = [ "graphical-session.target" ];
      wants = [ "network-online.target" ];
    };

  };

  meta = {
    doc = ./nordvpn.md;
    maintainers = with lib.maintainers; [ different-error ];
  };
}
