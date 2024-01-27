{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.oxalica ];

  ###### interface
  options = {
    programs.partition-manager.enable = mkEnableOption (lib.mdDoc "KDE Partition Manager");
  };

  ###### implementation
  config = mkIf config.programs.partition-manager.enable {
    services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];
    # `kpmcore` need to be installed to pull in polkit actions.
    environment.systemPackages = [ pkgs.libsForQt5.kpmcore pkgs.libsForQt5.partitionmanager ];
  };
}
