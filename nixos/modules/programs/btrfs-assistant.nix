{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.btrfs-assistant;
in
{
  options.programs.btrfs-assistant = {
    enable = lib.mkEnableOption "Btrfs Assistant, a GUI for managing Btrfs subvolumes and Snapper snapshots";

    package = lib.mkPackageOption pkgs "btrfs-assistant" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # The GUI talks to a root helper that the system bus starts on demand
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    # The helper authorizes every request through polkit
    security.polkit.enable = true;
  };

  meta.maintainers = with lib.maintainers; [ mirdukkkkk ];
}
