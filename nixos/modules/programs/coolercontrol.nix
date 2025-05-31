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
        default = false;
        defaultText = lib.literalExpression "lib.elem \"nvidia\" config.services.xserver.videoDrivers";
        description = ''
          **Deprecated**: Nvidia support is now automatically provided by graphics drivers.
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
          lib.warn
            "programs.coolercontrol.nvidiaSupport is deprecated. Nvidia support is now provided automatically."
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
