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

      nvidiaSupport = lib.mkOption {
        type = lib.types.bool;
        default = lib.elem "nvidia" config.services.xserver.videoDrivers;
        defaultText = lib.literalExpression "lib.elem \"nvidia\" config.services.xserver.videoDrivers";
        description = ''
          Enable support for Nvidia GPUs.
        '';
      };
    };
  };

  ##### implementation
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Common
      ({
        environment.systemPackages = with pkgs.coolercontrol; [
          coolercontrol-gui
        ];

        systemd = {
          packages = with pkgs.coolercontrol; [
            coolercontrol-liqctld
            coolercontrold
          ];

          # https://github.com/NixOS/nixpkgs/issues/81138
          services = {
            coolercontrol-liqctld.wantedBy = [ "multi-user.target" ];
            coolercontrold.wantedBy = [ "multi-user.target" ];
          };
        };
      })

      # Nvidia support
      (lib.mkIf cfg.nvidiaSupport {
        systemd.services.coolercontrold.path =
          let
            nvidiaPkg = config.hardware.nvidia.package;
          in
          [
            nvidiaPkg # nvidia-smi
            nvidiaPkg.settings # nvidia-settings
          ];
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    OPNA2608
    codifryed
  ];
}
