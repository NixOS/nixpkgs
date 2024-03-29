{ config, lib, pkgs, ... }:

{
  meta.maintainers = [ lib.maintainers.oxalica ];

  options = {
    programs.partition-manager.enable = lib.mkEnableOption (lib.mdDoc "KDE Partition Manager");
  };

  config = lib.mkIf config.programs.partition-manager.enable {
    services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];
    # `kpmcore` need to be installed to pull in polkit actions.
    environment.systemPackages = [ pkgs.libsForQt5.kpmcore pkgs.libsForQt5.partitionmanager ];
  };
}
