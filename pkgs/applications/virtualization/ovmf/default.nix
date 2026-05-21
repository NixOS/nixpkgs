{
  callPackage,
  edk2,
  lib,
  stdenv,
}:

{
  qemu = callPackage ./generic.nix { };

  full = callPackage ./generic.nix {
    pname = "ovmf-full";
    httpSupport = true;
    msVarsSupport = stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64;
    secureBoot = true;
    tlsSupport = true;
    tpmSupport = true;
  };

  xen = callPackage ./generic.nix {
    pname = "ovmf-xen";
    projectDscPathByCpu = {
      x86_64 = "OvmfPkg/OvmfXen.dsc";
    };
    meta = {
      description = "UEFI firmware for Xen guests";
      platforms = builtins.filter (lib.hasPrefix "x86_64-") edk2.meta.platforms;
      teams = [ lib.teams.xen ];
    };
  };

  cloud-hypervisor = callPackage ./generic.nix {
    pname = "ovmf-cloud-hypervisor";
    projectDscPathByCpu = {
      x86_64 = "OvmfPkg/CloudHv/CloudHvX64.dsc";
      aarch64 = "ArmVirtPkg/ArmVirtCloudHv.dsc";
    };
    firmwarePrefixByCpu = {
      x86_64 = "CLOUDHV";
      aarch64 = "CLOUDHV_EFI";
    };
    firmwareLayout = "single";
    meta = {
      description = "UEFI firmware for Cloud Hypervisor";
      broken = stdenv.hostPlatform.isDarwin;
      maintainers = with lib.maintainers; [ messemar ];
    };
  };
}
