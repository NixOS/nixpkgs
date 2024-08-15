{ callPackage }:
let
  standard = {
    meta = {
      description = "Standard Xen";
      longDescription = ''
        Standard version of Xen. Uses forks of QEMU, SeaBIOS, OVMF and iPXE provided
        by the Xen Project. This provides the vanilla Xen experince, but wastes space
        and build time. A typical NixOS setup that runs lots of VMs will usually need
        to build two different versions of QEMU when using this Xen derivation (one
        fork and upstream).
      '';
    };
  };
  slim = {
    meta = {
      description = "Without Internal Components";
      longDescription = ''
        Slimmed-down version of Xen that reuses nixpkgs packages as much as possible.
        Instead of using the Xen forks for various internal components, this version uses
        `seabios`, `ovmf` and `ipxe` from nixpkgs. These components may ocasionally get
        out of sync with the hypervisor itself, but this builds faster and uses less space
        than the default derivation.
      '';
    };
  };
in
# TODO: generalise this to automatically generate both Xen variants for each ./<version>/default.nix.
rec {
  xen_4_19 = callPackage ./4.19/default.nix { inherit (standard) meta; };
  xen_4_19-slim = xen_4_19.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta;
  };

  xen_4_18 = callPackage ./4.18/default.nix { inherit (standard) meta; };
  xen_4_18-slim = xen_4_18.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta;
  };

  xen_4_17 = callPackage ./4.17/default.nix { inherit (standard) meta; };
  xen_4_17-slim = xen_4_17.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta;
  };

  xen_4_16 = callPackage ./4.16/default.nix { inherit (standard) meta; };
  xen_4_16-slim = xen_4_16.override {
    withInternalQEMU = false;
    withInternalSeaBIOS = false;
    withInternalOVMF = false;
    withInternalIPXE = false;
    inherit (slim) meta;
  };

  xen = xen_4_19;
  xen-slim = xen_4_19-slim;
}
