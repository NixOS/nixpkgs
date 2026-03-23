{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.hypervGuest.dxgkrnl;
  wslGpuLib = pkgs.callPackage ../../../pkgs/os-specific/linux/dxgkrnl/gpu-lib.nix { };
in
{
  options = {
    virtualisation.hypervGuest.dxgkrnl = {
      enable = lib.mkEnableOption ''
        Hyper-V GPU paravirtualization (GPU-PV).

        This builds and loads the dxgkrnl kernel module, which exposes
        {file}`/dev/dxg` for GPU access from a Hyper-V guest via the VMBus.
        It also installs the WSL GPU libraries (`libdxcore.so`,
        `libd3d12.so`, `libd3d12core.so`) and adds them to the dynamic
        linker search path.

        The host VM must have a GPU partition adapter attached
        (`Add-VMGpuPartitionAdapter` in PowerShell). Vendor-specific
        driver files (e.g., NVIDIA `.so`/`.bin`) must be copied from
        the host into {file}`/usr/lib/wsl/lib/` and
        {file}`/usr/lib/wsl/drivers/<driver-store-name>/`.

        The {file}`/dev/dxg` device is owned by the `video` group.
        Add users to the `video` group for access:
        `users.users.<name>.extraGroups = [ "video" ];`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.virtualisation.hypervGuest.enable;
        message = "virtualisation.hypervGuest.dxgkrnl requires virtualisation.hypervGuest.enable = true";
      }
    ];

    boot = {
      extraModulePackages = [ config.boot.kernelPackages.dxgkrnl ];
      kernelModules = [ "dxgkrnl" ];
    };

    services.udev.extraRules = ''
      KERNEL=="dxg", MODE="0660", GROUP="video"
    '';

    # WSL GPU libraries (libdxcore.so, libd3d12.so, libd3d12core.so)
    environment.sessionVariables.LD_LIBRARY_PATH = [ "${wslGpuLib}/lib" ];
  };

  meta.maintainers = with lib.maintainers; [
    lostmsu
  ];
}
