{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cups-v3;

  cupsLocalDaemon = lib.getExe' cfg.package "cupslocald";
  cupsSharingDaemon = lib.getExe' cfg.sharing.package "cups-sharingd";
  ippUsbDaemon = lib.getExe cfg.ipp-usb.package;

  commonSandbox = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    PrivateIPC = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectClock = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@mount"
    ];
    SystemCallErrorNumber = "EPERM";
  };

in
{

  # ==========================================================================
  # Options
  # ==========================================================================

  options.services.cups-v3 = {

    enable = lib.mkEnableOption "CUPS 3.0 decoupled printing subsystem";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cups-local;
      defaultText = lib.literalExpression "pkgs.cups-local";
      description = "The cups-local package providing cupslocald and the lp/lpr/lpstat/cancel tools.";
    };

    libcupsPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.libcups3;
      defaultText = lib.literalExpression "pkgs.libcups3";
      description = "The libcups3 package. Provides the IPP utility programs and the pkg-config entry that pappl2 and cups-local build against.";
    };

    localMode = lib.mkOption {
      type = lib.types.enum [
        "system"
        "user"
      ];
      default = "system";
      description = ''
        Whether to run cupslocald as a single system service or as a per-user
        instance under each user's systemd session.

        "system" runs as cups3:cups3 and is suitable for multi-user or headless hosts.
        "user" starts automatically with the login session. Requires lingering
        if the user needs printing without an active session (loginctl enable-linger).
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "none"
        "error"
        "warn"
        "info"
        "debug"
        "debug2"
      ];
      default = "warn";
      description = "Log verbosity for cupslocald.";
    };

    extraEnvironment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = lib.literalExpression ''{ CUPS_DEBUG_LEVEL = "5"; }'';
      description = "Additional environment variables for the cupslocald service. System mode only.";
    };

    sharing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable cups-sharingd, the system-wide network print server component of CUPS 3.

          As of June 2026 the upstream repo contains only a build skeleton with no daemon
          source. pkgs.cups-sharing is marked broken. Leave this false until that changes.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.cups-sharing;
        defaultText = lib.literalExpression "pkgs.cups-sharing";
        description = "The cups-sharing package.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 631;
        description = ''
          TCP port for the cups-sharingd IPP listener. Ports below 1024
          are handled automatically via AmbientCapabilities.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open the sharing port in the NixOS firewall.";
      };
    };

    ipp-usb = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable ipp-usb for IPP-over-USB printers and scanners. Requires avahi.enable = true for loopback DNS-SD.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ipp-usb3;
        defaultText = lib.literalExpression "pkgs.ipp-usb3";
        description = "The ipp-usb package.";
      };

      scanning = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable SANE + sane-airscan so USB IPP-Everywhere devices with an eSCL scan unit are usable for scanning, not just printing.";
      };
    };

    avahi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Avahi for mDNS/DNS-SD driverless printer discovery. Set false to manage Avahi yourself; this module will not touch it.";
      };
    };
  };

  # ==========================================================================
  # Implementation
  # ==========================================================================

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      # -------------------------------------------------------------------------
      # Assertions
      # -------------------------------------------------------------------------
      {
        assertions = [
          {
            assertion = !(cfg.localMode == "user" && cfg.sharing.enable);
            message = ''
              services.cups-v3: localMode = "user" and sharing.enable = true
              are incompatible.  cups-sharing is a system-wide daemon and cannot
              operate on a per-user spool.  Set localMode = "system".
            '';
          }
          {
            assertion = !(cfg.ipp-usb.enable && !cfg.avahi.enable);
            message = ''
              services.cups-v3: ipp-usb.enable = true requires avahi.enable = true
              (ipp-usb self-advertises each bridged USB device over loopback
              DNS-SD, which is how driverless discovery finds it).  Either set
              avahi.enable = true or disable ipp-usb and manage it yourself.
            '';
          }
        ];
      }

      # -------------------------------------------------------------------------
      # System user for system-mode cupslocald.
      # lp group gives /dev/usb/lp* access as a fallback; driverless rarely needs it.
      # -------------------------------------------------------------------------
      {
        users.groups.cups3 = { };

        users.users.cups3 = {
          isSystemUser = true;
          group = "cups3";
          extraGroups = [
            "lp"
          ];
          description = "CUPS 3.0 local spooler daemon user";
          home = "/var/lib/cups3";
          createHome = false;
        };
      }

      # -------------------------------------------------------------------------
      # Pre-create persistent dirs via tmpfiles.
      # /run/cups3/ and /var/lib/cups3/ are also created by RuntimeDirectory=/
      # StateDirectory= in each unit, but /etc/cups3/ has no owning service so
      # it must come from here.
      # -------------------------------------------------------------------------
      {
        systemd.tmpfiles.rules = [
          "d /etc/cups3              0755 root  root  - -"
          "d /var/lib/cups3          0750 cups3 cups3 - -"
          "d /var/lib/cups3/sharing  0750 root  root  - -"
        ];
      }

      # -------------------------------------------------------------------------
      # cups-local: SYSTEM MODE
      # -------------------------------------------------------------------------
      (lib.mkIf (cfg.localMode == "system") {

        # Desktop apps (Firefox, GTK/Qt print dialogs, etc.) link against
        # libcups3 with no idea the server lives on a unix socket instead of
        # the classic localhost:631 - without this they fall back to
        # localhost:631, which nothing listens on (cups-sharing is disabled),
        # and print dialogs hang indefinitely on "Getting printer information"
        # instead of failing fast. This requires libcups3 to be built with
        # --sysconfdir=/etc so it actually reads this file.
        environment.etc."cups/client.conf".text = ''
          ServerName /run/cups3/cups.sock
        '';

        # Socket unit owns the VFS lifecycle; service pulls it via Requires=.
        systemd.sockets.cups-local = {
          description = "CUPS 3.0 Local Print Spooler Socket";
          wantedBy = [ "sockets.target" ];
          socketConfig = {
            ListenStream = "/run/cups3/cups.sock";
            SocketMode = "0666";
            RemoveOnStop = true;
          };
        };

        systemd.services.cups-local = {
          description = "CUPS 3.0 Local Print Spooler (cupslocald)";
          documentation = [ "https://openprinting.github.io/cups/cups3.html" ];
          wantedBy = [ "multi-user.target" ];
          requires = [ "cups-local.socket" ];
          after = [
            "network.target"
            "dbus.service"
            "cups-local.socket"
          ]
          ++ lib.optional cfg.avahi.enable "avahi-daemon.service";
          wants = lib.optional cfg.avahi.enable "avahi-daemon.service";
          path = [
            cfg.libcupsPackage
            pkgs.poppler-utils
          ];

          environment = lib.mkMerge [
            {
              CUPS_SERVER = "/run/cups3/cups.sock";
            }
            cfg.extraEnvironment
          ];

          serviceConfig = lib.mkMerge [
            commonSandbox
            {
              Type = "simple";
              ExecStart = lib.escapeShellArgs [
                cupsLocalDaemon
                "-S"
                "/run/cups3/cups.sock"
                "-s"
                "/var/lib/cups3/cups-locald.state"
                "-L"
                cfg.logLevel
                "-d"
                "/var/lib/cups3"
              ];

              Restart = "always";
              RestartSec = "0";

              User = "cups3";
              Group = "cups3";

              SupplementaryGroups = [ "avahi" ];

              PrivateNetwork = lib.mkForce false;
              RuntimeDirectory = "cups3";
              RuntimeDirectoryMode = "0755";
              StateDirectory = "cups3";
              StateDirectoryMode = "0750";

              ReadOnlyPaths = [
                "/etc/cups3"
                "${cfg.package}"
                "${cfg.libcupsPackage}"
              ];
              ReadWritePaths = lib.optional cfg.avahi.enable "/run/avahi-daemon";

              CapabilityBoundingSet = "";
              AmbientCapabilities = "";

              RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";

              LimitNOFILE = 4096;
              SyslogIdentifier = "cups-local";
            }
          ];
        };
        services.dbus.packages = [ cfg.package ];

        environment.systemPackages = [
          cfg.package
          cfg.libcupsPackage
        ];
      })

      # -------------------------------------------------------------------------
      # cups-local: USER MODE
      # Per-user cupslocald under systemd --user, auto-started via default.target.
      # We define the unit ourselves because the packaged cupslocald.service
      # ExecStart still points at sbin/ before postInstall moves it to bin/.
      # -------------------------------------------------------------------------
      (lib.mkIf (cfg.localMode == "user") {

        systemd.user.services.cups-local = {
          description = "CUPS 3.0 Local Print Spooler (per-user cupslocald)";
          documentation = [ "https://openprinting.github.io/cups/cups3.html" ];
          wantedBy = [ "default.target" ];
          after = [ "dbus.socket" ];

          environment = {
            CUPS_SERVER = "%t/cups3/cups.sock";
          };

          serviceConfig = {
            Type = "simple";
            ExecStart = lib.escapeShellArgs [
              cupsLocalDaemon
              "-S"
              "%t/cups3/cups.sock"
              "-s"
              "%S/cups3/cups-locald.state"
              "-L"
              cfg.logLevel
              "-d"
              "%S/cups3"
            ];
            Restart = "on-failure";
            RestartSec = "10s";
            RuntimeDirectory = "cups3";
            RuntimeDirectoryMode = "0700";
            StateDirectory = "cups3";
            StateDirectoryMode = "0700";
            PrivateTmp = true;
            NoNewPrivileges = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            LockPersonality = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = "@system-service ~@privileged ~@mount";
            SystemCallErrorNumber = "EPERM";
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";

            SyslogIdentifier = "cups-local";
          };
        };
      })

      # -------------------------------------------------------------------------
      # cups-sharing: SYSTEM-WIDE NETWORK SERVER
      # Structurally complete but non-functional until upstream ships daemon source
      # and pkgs.cups-sharing is un-broken.
      # -------------------------------------------------------------------------
      (lib.mkIf cfg.sharing.enable {

        systemd.services.cups-sharing = {
          description = "CUPS 3.0 Network Sharing Server (cups-sharingd)";
          documentation = [ "https://openprinting.github.io/cups/cups3.html" ];
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
            "dbus.service"
            "cups-local.service"
          ]
          ++ lib.optional cfg.avahi.enable "avahi-daemon.service";
          wants = [ "network-online.target" ] ++ lib.optional cfg.avahi.enable "avahi-daemon.service";

          environment = {
            PATH = lib.mkForce (
              lib.makeBinPath [
                cfg.libcupsPackage
                cfg.sharing.package
              ]
            );
            CUPS_LOGLEVEL = cfg.logLevel;
            CUPS_SERVER = "localhost:631";
            CUPS_SHARING_DATADIR = "${cfg.sharing.package}/share/cups-sharing";
          };

          serviceConfig = lib.mkMerge [
            commonSandbox
            {
              Type = "simple";
              ExecStart = cupsSharingDaemon;
              Restart = "on-failure";
              RestartSec = "15s";
              User = "root";
              Group = "root";
              RuntimeDirectory = "cups3";
              RuntimeDirectoryMode = "0750";
              StateDirectory = "cups3 cups3/sharing";
              StateDirectoryMode = "0750";
              ConfigurationDirectory = "cups3";
              ConfigurationDirectoryMode = "0750";

              CapabilityBoundingSet = lib.concatStringsSep " " [
                "CAP_NET_BIND_SERVICE"
                "CAP_CHOWN"
                "CAP_FOWNER"
                "CAP_SETUID"
                "CAP_SETGID"
                "CAP_DAC_READ_SEARCH"
              ];
              AmbientCapabilities = lib.optionalString (cfg.sharing.port < 1024) "CAP_NET_BIND_SERVICE";

              MemoryDenyWriteExecute = true;

              RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
              ReadOnlyPaths = [
                "${cfg.sharing.package}"
                "${cfg.libcupsPackage}"
              ];
              ReadWritePaths = [
                "/run/cups3"
                "/var/lib/cups3"
              ]
              ++ lib.optional cfg.avahi.enable "/run/avahi-daemon";

              LimitNOFILE = 65536;
              SyslogIdentifier = "cups-sharing";
            }
          ];
        };

        networking.firewall.allowedTCPPorts = lib.optional cfg.sharing.openFirewall cfg.sharing.port;
      })

      # -------------------------------------------------------------------------
      # Avahi: mDNS/DNS-SD for driverless IPP Everywhere discovery.
      # nssmdns4/6 enable .local resolution in glibc NSS for IPP URIs.
      # -------------------------------------------------------------------------
      (lib.mkIf cfg.avahi.enable {
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          nssmdns6 = true;
          allowPointToPoint = true;

          publish = {
            enable = true;
            addresses = true;
            workstation = false;
            userServices = true;
          };
        };
      })

      # -------------------------------------------------------------------------
      # ipp-usb: IPP-over-USB bridge.
      # ipp-usb bridges each USB device to
      # a loopback HTTP/IPP port and self-advertises via DNS-SD, so
      # driverless discovery (Avahi -> cups-local) picks it up the same way
      # it would a real network printer. Requires avahi.enable = true,
      # enforced by an assertion above.
      # -------------------------------------------------------------------------
      (lib.mkIf cfg.ipp-usb.enable {
        systemd.services.ipp-usb = {
          description = "Daemon for IPP over USB printer/scanner support";
          after = [ "avahi-daemon.service" ];
          wants = [ "avahi-daemon.service" ];

          serviceConfig = lib.mkMerge [
            commonSandbox
            {
              Type = "simple";
              ExecStart = ippUsbDaemon;
              Restart = "on-failure";
              StateDirectory = "ipp-usb";
              LogsDirectory = "ipp-usb";
              ProtectHome = true;
              PrivateUsers = true;
              PrivateMounts = true;
              RemoveIPC = true;
              ProtectProc = "noaccess";
              PrivateDevices = lib.mkForce false;
              ProtectClock = lib.mkForce false;
              CapabilityBoundingSet = "";
              AmbientCapabilities = "";
              RestrictAddressFamilies = [
                "AF_UNIX"
                "AF_NETLINK"
                "AF_INET"
                "AF_INET6"
              ];
            }
          ];
        };

        services.udev.packages = [ cfg.ipp-usb.package ];
      })

      (lib.mkIf (cfg.ipp-usb.enable && cfg.ipp-usb.scanning) {
        hardware.sane.enable = true;
        hardware.sane.extraBackends = [ pkgs.sane-airscan ];
      })

    ]
  );
}
