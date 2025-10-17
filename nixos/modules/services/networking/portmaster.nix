{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.portmaster;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.portmaster = {
    enable = lib.mkEnableOption "Portmaster application firewall";

    package = lib.mkPackageOption pkgs "portmaster" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          devmode = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Enable development mode. This makes the Portmaster UI available at 127.0.0.1:817.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for Portmaster. Options set here will be passed to portmaster-core.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra command-line arguments to pass to portmaster-core.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Desktop file for GUI access
    services.xserver.desktopManager.session = lib.mkIf config.services.xserver.enable [
      {
        name = "portmaster";
        start = "";
      }
    ];

    environment.etc."xdg/autostart/portmaster.desktop".text = ''
      [Desktop Entry]
      Name=Portmaster
      Comment=Free and open-source application firewall
      Exec=portmaster --data /var/lib/portmaster --log-dir /var/lib/portmaster/logs
      Icon=portmaster
      Type=Application
      Categories=Network;Security;
      StartupNotify=false
      Terminal=false
      Hidden=true
    '';

    boot.kernelModules = [ "netfilter_queue" ];

    systemd.tmpfiles.rules = [
      "d /var/lib/portmaster 0755 root root -"
      "d /var/lib/portmaster/logs 0755 root root -"
      "d /var/lib/portmaster/download_binaries 0755 root root -"
      "d /var/lib/portmaster/updates 0755 root root -"
      "d /var/lib/portmaster/databases 0755 root root -"
      "d /var/lib/portmaster/databases/icons 0755 root root -"
      "d /var/lib/portmaster/config 0755 root root -"
      "d /var/lib/portmaster/intel 0755 root root -"
      "d /var/lib/portmaster/runtime 0755 root root -"
      "d /usr/lib/portmaster 0755 root root -"
      "L+ /var/lib/portmaster/runtime/portmaster-core - - - - ${cfg.package}/usr/lib/portmaster/portmaster-core"
      "L+ /var/lib/portmaster/runtime/portmaster - - - - ${cfg.package}/usr/lib/portmaster/portmaster"
      "L+ /var/lib/portmaster/runtime/portmaster.zip - - - - ${cfg.package}/usr/lib/portmaster/portmaster.zip"
      "L+ /var/lib/portmaster/runtime/assets.zip - - - - ${cfg.package}/usr/lib/portmaster/assets.zip"
      # Portmaster hardcoded expectation - portmaster.zip needs to be accessible from /usr/lib/portmaster/
      "L+ /usr/lib/portmaster/portmaster.zip - - - - ${cfg.package}/usr/lib/portmaster/portmaster.zip"
    ];

    systemd.services.portmaster = {
      description = "Portmaster by Safing";
      documentation = [
        "https://safing.io"
        "https://docs.safing.io"
      ];
      before = [
        "nss-lookup.target"
        "network.target"
        "shutdown.target"
      ];
      after = [
        "systemd-networkd.service"
        "systemd-tmpfiles-setup.service"
      ];
      conflicts = [
        "shutdown.target"
        "firewalld.service"
      ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "systemd-tmpfiles-setup.service" ];

      script =
        let
          baseArgs = [
            "/var/lib/portmaster/runtime/portmaster-core"
            "--data-dir=/var/lib/portmaster/runtime"
            "--log-dir=/var/lib/portmaster/logs"
          ];
          devmodeArgs = lib.optional cfg.settings.devmode "--devmode";
          allArgs = baseArgs ++ devmodeArgs ++ cfg.extraArgs;
        in
        lib.concatStringsSep " " allArgs;

      postStop = ''
        /var/lib/portmaster/runtime/portmaster-core recover-iptables
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "10";
        RestartPreventExitStatus = "24";
        User = "root";
        Group = "root";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        MemoryLow = "2G";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PIDFile = "/var/lib/portmaster/core-lock.pid";
        StateDirectory = "portmaster";
        WorkingDirectory = "/var/lib/portmaster";
        ProtectSystem = true;
        ReadWritePaths = [
          "/var/lib/portmaster"
        ];
        ProtectHome = "read-only";
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        RestrictNamespaces = true;
        AmbientCapabilities = [
          "cap_chown"
          "cap_kill"
          "cap_net_admin"
          "cap_net_bind_service"
          "cap_net_broadcast"
          "cap_net_raw"
          "cap_sys_module"
          "cap_sys_ptrace"
          "cap_dac_override"
          "cap_fowner"
          "cap_fsetid"
          "cap_sys_resource"
          "cap_bpf"
          "cap_perfmon"
        ];
        CapabilityBoundingSet = [
          "cap_chown"
          "cap_kill"
          "cap_net_admin"
          "cap_net_bind_service"
          "cap_net_broadcast"
          "cap_net_raw"
          "cap_sys_module"
          "cap_sys_ptrace"
          "cap_dac_override"
          "cap_fowner"
          "cap_fsetid"
          "cap_sys_resource"
          "cap_bpf"
          "cap_perfmon"
        ];
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ];
        Environment = [
          "LOGLEVEL=info"
          "PORTMASTER_ARGS="
          "PORTMASTER_DATA_DIR=/var/lib/portmaster"
          "PORTMASTER_RUNTIME_DIR=/var/lib/portmaster/runtime"
        ];
        EnvironmentFile = [ "-/etc/default/portmaster" ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.settings.devmode 817;

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  meta.maintainers = with lib.maintainers; [ WitteShadovv ];
}
