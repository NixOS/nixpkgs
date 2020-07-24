{ callPackage
, stdenv, overrideCC
}:

# TODO(@oxij) on new Xen version: generalize this to generate [vanilla slim
# light] for each ./<version>.nix.

rec {
  xen_4_8-vanilla = callPackage ./4.8.nix {
    meta = {
      description = "vanilla";
      longDescription = ''
        Vanilla version of Xen. Uses forks of Qemu and Seabios bundled
        with Xen. This gives vanilla experince, but wastes space and
        build time: typical NixOS setup that runs lots of VMs will
        build three different versions of Qemu when using this (two
        forks and upstream).
      '';
    };
  };

  xen_4_8-slim = xen_4_8-vanilla.override {
    withInternalQemu = false;
    withInternalTraditionalQemu = true;
    withInternalSeabios = false;
    withSeabios = true;

    meta = {
      description = "slim";
      longDescription = ''
        Slimmed-down version of Xen that reuses nixpkgs packages as
        much as possible. Different parts may get out of sync, but
        this builds faster and uses less space than vanilla. Use with
        `qemu_xen` from nixpkgs.
      '';
    };
  };

  xen_4_8-light = xen_4_8-vanilla.override {
    withInternalQemu = false;
    withInternalTraditionalQemu = false;
    withInternalSeabios = false;
    withSeabios = true;

    meta = {
      description = "light";
      longDescription = ''
        Slimmed-down version of Xen without `qemu-traditional` (you
        don't need it if you don't know what it is). Use with
        `qemu_xen-light` from nixpkgs.
      '';
    };
  };

  xen_4_10-vanilla = callPackage ./4.10.nix {
    meta = {
      description = "vanilla";
      longDescription = ''
        Vanilla version of Xen. Uses forks of Qemu and Seabios bundled
        with Xen. This gives vanilla experince, but wastes space and
        build time: typical NixOS setup that runs lots of VMs will
        build three different versions of Qemu when using this (two
        forks and upstream).
      '';
    };
  };

  xen_4_10-slim = xen_4_10-vanilla.override {
    withInternalQemu = false;
    withInternalTraditionalQemu = true;
    withInternalSeabios = false;
    withSeabios = true;

    meta = {
      description = "slim";
      longDescription = ''
        Slimmed-down version of Xen that reuses nixpkgs packages as
        much as possible. Different parts may get out of sync, but
        this builds faster and uses less space than vanilla. Use with
        `qemu_xen` from nixpkgs.
      '';
    };
  };

  xen_4_10-light = xen_4_10-vanilla.override {
    withInternalQemu = false;
    withInternalTraditionalQemu = false;
    withInternalSeabios = false;
    withSeabios = true;

    meta = {
      description = "light";
      longDescription = ''
        Slimmed-down version of Xen without `qemu-traditional` (you
        don't need it if you don't know what it is). Use with
        `qemu_xen-light` from nixpkgs.
      '';
    };
  };

  xen-vanilla = xen_4_8-vanilla;
  xen-slim = xen_4_8-slim;
  xen-light = xen_4_8-light;

}
