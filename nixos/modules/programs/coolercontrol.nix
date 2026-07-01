{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.coolercontrol;
in
{
  ##### interface
  options = {
    programs.coolercontrol = {
      enable = lib.mkEnableOption "CoolerControl GUI & its background services";
    };
  };

  imports = [
    # Added 2025-10-25
    (lib.mkRemovedOptionModule [ "programs" "coolercontrol" "nvidiaSupport" ] ''
      This option is deprecated as Nvidia drivers are automatically loaded at runtime.
    '')
  ];

  ##### implementation
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Common
      {
        environment.systemPackages = with pkgs.coolercontrol; [
          coolercontrol-gui
        ];

        systemd = {
          packages = with pkgs.coolercontrol; [
            coolercontrold
          ];

          # https://github.com/NixOS/nixpkgs/issues/81138
          services = {
            coolercontrold.wantedBy = [ "multi-user.target" ];
          };
        };
      }
    ]
  );

  meta.maintainers = with lib.maintainers; [
    OPNA2608
    codifryed
  ];
}
