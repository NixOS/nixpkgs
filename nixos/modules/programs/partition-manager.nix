{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.partition-manager;
in
{
  meta.maintainers = [ lib.maintainers.oxalica ];

  options = {
    programs.partition-manager = {
      enable = lib.mkEnableOption "KDE Partition Manager";

      package = lib.mkPackageOption pkgs [ "libsForQt5" "partitionmanager" ] { };
    };
  };

  config = lib.mkIf config.programs.partition-manager.enable {
    services.dbus.packages = [ cfg.package.kpmcore ];
    # `kpmcore` need to be installed to pull in polkit actions.
    environment.systemPackages = [
      cfg.package.kpmcore
      cfg.package
    ];
  };
}
