{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.boot.kernelPackages) tt-kmd;

  cfg = config.hardware.tenstorrent;
in
{
  options.hardware.tenstorrent.enable = mkEnableOption "Tenstorrent driver & utilities";

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = [ tt-kmd ];
      kernelModules = [ "tenstorrent" ];
    };

    services.udev.packages = [
      tt-kmd
    ];

    # TODO: add tt-smi to environment.systemPackages once https://github.com/NixOS/nixpkgs/pull/444714 is merged
    # TODO: add tt-system-tools to environment.systemPackages once https://github.com/NixOS/nixpkgs/pull/444748 is merged
  };

  meta.maintainers = with lib.maintainers; [ RossComputerGuy ];
}
