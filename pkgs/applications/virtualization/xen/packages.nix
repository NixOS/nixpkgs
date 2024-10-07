{
  python3Packages,
  python311Packages,
  callPackage,
}:
let
  standard = {
    # Broken with python 3.12+ when using internal QEMU due to https://github.com/NixOS/nixpkgs/issues/253751
    python3Packages = python311Packages;
    meta = {
      description = "Standard";
      longDescription = ''
        Standard version of the Xen Project Hypervisor. Uses forks of QEMU, SeaBIOS,
        OVMF and iPXE provided by the Xen Project. This provides the vanilla Xen
        experience, but wastes space and build time. A typical NixOS setup that runs
        lots of VMs will usually need to build two different versions of QEMU when using
        this Xen derivation (one fork and upstream).
      '';
    };
  };
  slim = {
    inherit python3Packages;
    meta = {
      description = "Without Internal Components";
      longDescription = ''
        Slimmed-down version of the Xen Project Hypervisor that reuses nixpkgs packages
        as much as possible. Instead of using the Xen Project forks for various internal
        components, this version uses `seabios`, `ovmf` and `ipxe` from Nixpkgs. These
        components may ocasionally get out of sync with the hypervisor itself, but this
        builds faster and uses less space than the default derivation.
      '';
    };
  };
in
# TODO: generalise this to automatically generate both Xen variants for each ./<version>/default.nix.
rec {
  xen_4_19 = callPackage ./4.19/default.nix {
    inherit (standard) meta python3Packages;
  };
  xen_4_19-slim = xen_4_19.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta python3Packages;
  };

  xen_4_18 = callPackage ./4.18/default.nix {
    inherit (standard) meta python3Packages;
  };
  xen_4_18-slim = xen_4_18.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta python3Packages;
  };

  xen_4_17 = callPackage ./4.17/default.nix {
    inherit (standard) meta python3Packages;
  };
  xen_4_17-slim = xen_4_17.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta;
    # Broken with python 3.12+ due to distutils missing.
    python3Packages = python311Packages;
  };
}
