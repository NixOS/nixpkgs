# based on upstream's nix packaging, which can be found here:
# https://git.federated.nexus/Nexus/nexus/src/commit/d7006ebeb0aff18f6802bd30c81d87fae3099235/linux/nix/module.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.matrix-nexus;
in
{
  options.programs.matrix-nexus = {
    enable = lib.mkEnableOption "Nexus, a simple and user-friendly Matrix client";
    package = lib.mkPackageOption pkgs "matrix-nexus" { };

    enableNotifications = lib.mkEnableOption "notifications support via UnifiedPush";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ];
    }
    (lib.mkIf cfg.enableNotifications {
      environment.systemPackages = [
        pkgs.kdePackages.kunifiedpush
      ];

      systemd.packages = [
        pkgs.kdePackages.kunifiedpush
      ];

      services.dbus.packages = [
        cfg.package
      ];
    })
  ]);

  meta.maintainers = with lib.maintainers; [ logn ];
}
