{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    maintainers
    optional
    singleton
    getExe'
    ;

  cfg = config.services.mullvad-vpn;
in
{
  options.services.mullvad-vpn = {
    enable = mkEnableOption "the Mullvad VPN service";
    package = mkPackageOption pkgs "mullvad" { };

    enableExcludeWrapper =
      (mkEnableOption "the security wrapper the allows the use of `mullvad-exclude`, a command that tunnels a single command directly to the clearnet, bypassing the system-wide VPN. It is recommended to disable this option for security models where privileged (`setuid`) binaries are a concern")
      // {
        default = true;
      };

    enableEarlyBootBlocking = mkEnableOption "an additional systemd service that ensures that the Mullvad VPN daemon will block all traffic early in the boot process, as opposed to blocking traffic after the network has been set up. Enabling this option matches what upstream Mullvad distributes for their supported distros, but is disabled by default in NixOS as it may conflict with non-Mullvad network configurations. If you do not have a custom network configuration, it is recommended to enable this option in order to prevent network leaks during the boot process";

    gui = {
      enable = mkEnableOption "the Mullvad VPN graphical user interface";
      package = mkPackageOption pkgs "mullvad-vpn" { };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package.hasMullvadDaemon or false;
        message = "'services.mullvad-vpn.package' is using '${
          cfg.package.name or "unknown-package"
        }', but this package has indicated that it does not contain a Mullvad VPN Daemon. This may be due to the fact that you have configured 'services.mullvad-vpn.package' to point to 'pkgs.mullvad-vpn', which no longer contains the Mullvad Daemon. Please unset 'services.mullvad-vpn.package' and enable 'services.mullvad-vpn.gui.enable' if you wish to use Mullvad VPN's graphical user interface.";
      }
    ];

    warnings =
      optional (cfg.gui.enable && !(cfg.gui.package.hasMullvadGUI or false))
        "'services.mullvad-vpn.gui.package' reports that it does not contain a Mullvad VPN graphical user interface. The Mullvad VPN desktop app may be unavailable.";

    boot.kernelModules = [ "tun" ];

    environment.systemPackages = singleton cfg.package ++ optional cfg.gui.enable cfg.gui.package;

    # See https://github.com/NixOS/nixpkgs/issues/176603
    security.wrappers.mullvad-exclude = mkIf cfg.enableExcludeWrapper {
      setuid = true;
      owner = "root";
      group = "root";
      source = getExe' cfg.package "mullvad-exclude";
    };

    # Mullvad prefers systemd-resolved for setting up their DNS servers.
    services.resolved.enable = lib.mkDefault true;

    # See https://github.com/mullvad/mullvadvpn-app/blob/2025.14/dist-assets/linux/mullvad-early-boot-blocking.service.
    systemd.services = {
      mullvad-early-boot-blocking = mkIf cfg.enableEarlyBootBlocking {
        description = "Mullvad early boot network blocker";
        wantedBy = [ "mullvad-daemon.service" ];
        before = [
          "basic.target"
          "mullvad-daemon.service"
        ];
        unitConfig = {
          DefaultDependencies = "no";
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${getExe' cfg.package "mullvad-daemon"} --initialize-early-boot-firewall";
        };
      };

      mullvad-daemon = {
        description = "Mullvad VPN daemon";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "network.target"
          "network-online.target"
        ];
        after = [
          "network-online.target"
          "NetworkManager.service"
          "systemd-resolved.service"
        ]
        ++ optional cfg.enableEarlyBootBlocking "mullvad-early-boot-blocking.service";

        path =
          # Necessary for certain obfuscation types (pre-v2026.4) and DAITA.
          # TODO: Drop iproute2 once the dependency on the `ip` command is dropped upstream.
          singleton pkgs.iproute2
          # See https://github.com/NixOS/nixpkgs/issues/262681
          ++ optional config.networking.resolvconf.enable config.networking.resolvconf.package;
        startLimitBurst = 5;
        startLimitIntervalSec = 20;
        serviceConfig = {
          ExecStart = "${getExe' cfg.package "mullvad-daemon"} -v --disable-stdout-timestamps";
          Restart = "always";
          RestartSec = 1;
        };
      };
    };
  };

  meta.maintainers = with maintainers; [
    arcuru
    sigmasquadron
    jackr
  ];
}
