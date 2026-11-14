{ config, lib, ... }:
{
  options.hardware.ntsync.enable = lib.mkEnableOption ''
    ntsync, a Linux kernel driver that emulates Windows NT
    synchronization primitives via /dev/ntsync. Used by Wine/Proton
    (>= Proton 11) for better performance and compatibility than the
    userspace esync/fsync alternatives.

    Requires Linux kernel 6.14 or newer
  '';

  config = lib.mkIf config.hardware.ntsync.enable {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.14";
        message = "hardware.ntsync requires kernel >= 6.14";
      }
    ];
    boot.kernelModules = [ "ntsync" ];
  };

  meta.maintainers = with lib.maintainers; [ mitchmindtree ];
}
