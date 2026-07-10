{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hardware.openlinkhub;

  # Upstream sets OWNER="openlinkhub" in the udev rule, which requires the daemon
  # to run as root to take ownership of device nodes. We replace it with
  # GROUP="openlinkhub" so the daemon can run as an unprivileged system user.
  udevRulesPkg = pkgs.runCommand "openlinkhub-udev-rules" { } ''
    install -Dm 644 \
      ${cfg.package}/etc/udev/rules.d/99-openlinkhub.rules \
      $out/lib/udev/rules.d/99-openlinkhub.rules
    substituteInPlace $out/lib/udev/rules.d/99-openlinkhub.rules \
      --replace-fail 'OWNER="openlinkhub"' 'GROUP="openlinkhub"'
  '';
in
{
  options.services.hardware.openlinkhub = {
    enable = lib.mkEnableOption "OpenLinkHub, a controller daemon for Corsair iCUE LINK devices, AIOs and hubs";

    package = lib.mkPackageOption pkgs "openlinkhub" { };
  };

  config = lib.mkIf cfg.enable {
    users.users.openlinkhub = {
      isSystemUser = true;
      group = "openlinkhub";
      description = "OpenLinkHub daemon user";
    };
    users.groups.openlinkhub = { };

    services.udev.packages = [ udevRulesPkg ];

    systemd.services.openlinkhub = {
      description = "OpenLinkHub - Corsair iCUE LINK / AIO / Hub controller";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "dev-usb.device" ];

      preStart = ''
        # web/ and static/ live in the read-only store; symlink them into the
        # writable StateDirectory so the daemon can serve them at runtime.
        ln -sfnT ${cfg.package}/opt/OpenLinkHub/web web
        ln -sfnT ${cfg.package}/opt/OpenLinkHub/static static
        mkdir -p database
        # Seed the database on first start. -n (no-clobber) preserves user data
        # (device profiles, settings) on subsequent restarts and rebuilds.
        cp -rn --no-preserve=mode,ownership \
          ${cfg.package}/opt/OpenLinkHub/database/. database/
        chmod -R u+w database
      '';

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        WorkingDirectory = "/var/lib/openlinkhub";
        StateDirectory = "openlinkhub";
        StateDirectoryMode = "0750";
        User = "openlinkhub";
        Group = "openlinkhub";
        SupplementaryGroups = [ "input" ];
        # Restart=always handles the residual race between udev rule application
        # and first device open: if the daemon starts before GROUP="openlinkhub"
        # is applied to a device node, it fails and retries after RestartSec.
        Restart = "always";
        RestartSec = "5s";

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        CapabilityBoundingSet = [ "" ];
        AmbientCapabilities = [ "" ];
        DevicePolicy = "closed";
        DeviceAllow = [
          "char-hidraw rw"
          "char-usb_device rw"
          "/dev/uinput rw"
        ];
        UMask = "0027";
      };
    };
  };

  meta = {
    maintainers = [ ];
    doc = ./openlinkhub.md;
  };
}
