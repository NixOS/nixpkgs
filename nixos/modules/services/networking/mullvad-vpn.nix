{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mullvad-vpn;
in
with lib;
{
  options.services.mullvad-vpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables Mullvad VPN daemon.
      '';
    };

    enableExcludeWrapper = mkOption {
      type = types.bool;
      default = true;
      description = ''
        This option activates the wrapper that allows the use of mullvad-exclude.
        Might have minor security impact, so consider disabling if you do not use the feature.
      '';
    };

    package = mkPackageOption pkgs "mullvad" {
      example = "mullvad-vpn";
      extraDescription = ''
        `pkgs.mullvad` only provides the CLI tool, `pkgs.mullvad-vpn` provides both the CLI and the GUI.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    environment.systemPackages = [ cfg.package ];

    # See https://github.com/NixOS/nixpkgs/issues/176603
    security.wrappers.mullvad-exclude = mkIf cfg.enableExcludeWrapper {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/mullvad-exclude";
    };

    systemd.services.mullvad-daemon = {
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
      ];
      # See https://github.com/NixOS/nixpkgs/issues/262681
      path = lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;
      startLimitBurst = 5;
      startLimitIntervalSec = 20;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/mullvad-daemon -v --disable-stdout-timestamps";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };

  meta.maintainers = with maintainers; [
    arcuru
    ymarkus
  ];
}
