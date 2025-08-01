{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bitbox-bridge;
in
{
  options = {
    services.bitbox-bridge = {
      enable = lib.mkEnableOption "Bitbox bridge daemon, for use with Bitbox hardware wallets.";

      package = lib.mkPackageOption pkgs "bitbox-bridge" { };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8178;
        description = ''
          Listening port for the bitbox-bridge.
        '';
      };

      runOnMount = lib.mkEnableOption null // {
        default = true;
        description = ''
          Run bitbox-bridge.service only when hardware wallet is plugged, also registers the systemd device unit.
          This option is enabled by default to save power, when false, bitbox-bridge service runs all the time instead.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [
      cfg.package
    ]
    ++ lib.optionals (cfg.runOnMount) [
      (pkgs.writeTextFile {
        name = "bitbox-bridge-run-on-mount-udev-rules";
        destination = "/etc/udev/rules.d/99-bitbox-bridge-run-on-mount.rules";
        text = ''
          SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", MODE="0660", GROUP="bitbox", TAG+="systemd", SYMLINK+="bitbox02", ENV{SYSTEMD_WANTS}="bitbox-bridge.service"
        '';
      })
    ];

    systemd.services.bitbox-bridge = {
      description = "BitBox Bridge";
      wantedBy = [ "multi-user.target" ];

      bindsTo = lib.optionals (cfg.runOnMount) [ "dev-bitbox02.device" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/bitbox-bridge -p ${builtins.toString cfg.port}";
        User = "bitbox";
      };
    };

    users.groups.bitbox = { };
    users.users.bitbox = {
      group = "bitbox";
      description = "bitbox-bridge daemon user";
      isSystemUser = true;
      extraGroups = [ "bitbox" ];
    };
  };
}
