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

    # The bundled Go binaries (wstunnel, amneziawg, ctrld) cannot be patched
    # by autoPatchelf without crashing, so they retain their original
    # /lib64/ld-linux-x86-64.so.2 interpreter. nix-ld provides this path.
    programs.nix-ld.enable = true;

    # The GUI and CLI need cap_setgid to switch to the windscribe group for
    # helper socket access. security.wrappers creates setcap copies in
    # /run/wrappers/bin/ which is early in PATH and takes precedence.
    security.wrappers = {
      windscribe = {
        source = "${cfg.package}/opt/windscribe/Windscribe";
        capabilities = "cap_setgid+ep";
        owner = "root";
        group = "root";
      };
      windscribe-cli = {
        source = "${cfg.package}/opt/windscribe/windscribe-cli";
        capabilities = "cap_setgid+ep";
        owner = "root";
        group = "root";
      };
    };

    systemd.tmpfiles.rules = [
      "d /etc/windscribe 0755 root root -"
      "f /etc/windscribe/platform 0644 root root - linux_deb_x64"
      "d /etc/windscribe/autostart 0755 root root -"
      "L+ /etc/windscribe/autostart/windscribe.desktop - - - - ${cfg.package}/etc/xdg/autostart/windscribe.desktop"
      "d /var/log/windscribe 0755 root root -"
      "d /var/tmp/windscribe 0755 root root -"
      # The update-systemd-resolved DNS script writes config here
      "d /usr/local/lib/systemd/resolved.conf.d 0755 root root -"
    ];

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
      serviceConfig = {
        Type = "simple";
        # Bind mount /opt/windscribe from the nix store before starting.
        # MUST be a bind mount, not a symlink: the helper uses realpath() to
        # validate sub-process paths start with "/opt/windscribe". Symlinks
        # resolve to /nix/store/... which fails the check and blocks all VPN
        # connections. Bind mounts are transparent to realpath().
        ExecStartPre = pkgs.writeShellScript "setup-windscribe-mount" ''
          # Remove any stale symlink from previous configs
          if [ -L /opt/windscribe ]; then
            ${pkgs.coreutils}/bin/rm /opt/windscribe
          fi
          ${pkgs.coreutils}/bin/mkdir -p /opt/windscribe
          # Always unmount and remount to pick up new store paths after rebuilds.
          # Without this, a stale mount serves old (possibly broken) binaries.
          if ${pkgs.util-linux}/bin/mountpoint -q /opt/windscribe; then
            ${pkgs.util-linux}/bin/umount /opt/windscribe
          fi
          ${pkgs.util-linux}/bin/mount --bind ${cfg.package}/opt/windscribe /opt/windscribe
          ${pkgs.util-linux}/bin/mount -o remount,bind,ro /opt/windscribe
        '';
        ExecStart = "/opt/windscribe/helper";
        Restart = "on-failure";
      };
      # /run/wrappers/bin provides sudo, which the helper uses to drop
      # privileges when starting stunnel/wstunnel for Stealth and WStunnel protocols.
      environment.PATH = lib.mkForce (
        "/run/wrappers/bin:"
        + lib.makeBinPath (
          with pkgs;
          [
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
          ]
        )
      );
    };
  };

  meta.maintainers = with lib.maintainers; [ syntheit ];
}
