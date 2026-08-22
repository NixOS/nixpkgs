{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.windscribe;
in
{
  options.services.windscribe = {
    enable = lib.mkEnableOption "Windscribe VPN";

    package = lib.mkPackageOption pkgs "windscribe" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # The bundled Go binaries (windscribewstunnel, windscribeamneziawg,
    # windscribectrld) are Windscribe-specific forks and ship with the standard
    # /lib64/ld-linux-x86-64.so.2 interpreter. They are restored unpatched after
    # autoPatchelf because the Go runtime crashes when the dynamic linker is
    # rewritten; nix-ld provides the interpreter path so they can be exec'd.
    programs.nix-ld.enable = true;

    # The helper listens on a 0770 root:windscribe unix socket
    # (/var/run/windscribe/helper.sock). The GUI/CLI reach it by running
    # setgid "windscribe" so they inherit egid=windscribe - exactly what the
    # upstream .deb does in its postinst:
    #   chgrp windscribe /opt/windscribe/Windscribe && chmod 2755 ...
    # The app connects with the inherited group, then drops it (dropHelperGroup).
    #
    # cap_setgid does NOT work here: the app never calls setgid() to *raise*
    # into the windscribe group before connecting (it only ever drops the
    # group), so the capability is never exercised and connect() gets EACCES,
    # which surfaces as "Timed out connecting to helper socket" / "app did not
    # start in time".
    security.wrappers = {
      windscribe = {
        source = "${cfg.package}/opt/windscribe/Windscribe";
        owner = "root";
        group = "windscribe";
        setgid = true;
      };
      windscribe-cli = {
        source = "${cfg.package}/opt/windscribe/windscribe-cli";
        owner = "root";
        group = "windscribe";
        setgid = true;
      };
    };

    systemd.tmpfiles.settings."10-windscribe" = {
      "/etc/windscribe".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
      "/etc/windscribe/platform".f = {
        mode = "0644";
        user = "root";
        group = "root";
        argument = "linux_deb_x64";
      };
      "/etc/windscribe/autostart".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
      "/etc/windscribe/autostart/windscribe.desktop"."L+".argument =
        "${cfg.package}/etc/xdg/autostart/windscribe.desktop";
      "/var/log/windscribe".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
      "/var/tmp/windscribe".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
      # The update-systemd-resolved DNS script writes config here.
      "/usr/local/lib/systemd/resolved.conf.d".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
      # Bind-mount target for the helper service.
      "/opt/windscribe".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
    };

    # The helper creates these imperatively via groupadd/useradd at startup;
    # declare them so they exist before the helper starts.
    users.groups.windscribe = { };
    users.users.windscribe = {
      isSystemUser = true;
      group = "windscribe";
      home = "/var/lib/windscribe";
      createHome = true;
    };

    # Windscribe helper daemon - runs as root, manages firewall rules and
    # VPN tunnels. The GUI/CLI connects via /var/run/windscribe/helper.sock.
    systemd.services.windscribe-helper = {
      description = "Windscribe helper service";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      # /run/wrappers provides setuid sudo, which the helper invokes to drop
      # privileges when starting stunnel/wstunnel for Stealth and WStunnel protocols.
      path = [
        "/run/wrappers"
      ]
      ++ (with pkgs; [
        iptables
        iproute2
        systemd
        util-linux
        kmod
        gnused
        gawk
        gnugrep
        coreutils
        e2fsprogs
        wireguard-tools
        shadow
      ]);
      serviceConfig = {
        Type = "simple";
        ExecStart = "/opt/windscribe/helper";
        Restart = "on-failure";
        # The helper validates child-process paths via realpath() against
        # /opt/windscribe. realpath() is transparent to mount points but
        # resolves through symlinks, so a bind mount is required (a symlink
        # to the store path would resolve to /nix/store/... and fail the check).
        BindReadOnlyPaths = [ "${cfg.package}/opt/windscribe:/opt/windscribe" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ syntheit ];
}
