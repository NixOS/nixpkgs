{
  lib,
  fetchpatch,
  callPackage,
  ocaml-ng,
  xen,
  python3,
  qubes-seabios,
  qubes-vmm-stubdom-linux,
  ...
}@genericDefinition:

let
  pname = "qubes-vmm-xen";
  branch = "4.19";
  versionPatches = "4.19.0";
  versionSuffix = "3";
  version = "${versionPatches}-${versionSuffix}";
  latest = true;

  xenPatches = import ../../../applications/virtualization/xen/generic/patches.nix {
    inherit lib fetchpatch;
  };
  xenPatchList = lib.lists.flatten (
    with xenPatches;
    [
      XSA_460
      XSA_461
    ]
  );

  qubesPatches = import ./patches.nix {
    inherit fetchpatch version;
  };
  qubesPatchList = lib.lists.flatten (
    with qubesPatches;
    [
      EFI_WORKAROUNDS
      BACKPORTS
      UPSTREAMABLE_PATCHES
      QUBES_SPECIFIC_PATCHES
      OTHERS
    ]
  );
in

(callPackage
  (import ../../../applications/virtualization/xen/generic/default.nix {
    inherit
      pname
      branch
      version
      latest
      ;
    pkg = {
      xen = {
        rev = "026c9fa29716b0ff0f8b7c687908e71ba29cf239";
        hash = "sha256-Q6x+2fZ4ITBz6sKICI0NHGx773Rc919cl+wzI89UY+Q=";
        patches = [ ] ++ xenPatchList ++ qubesPatchList;
      };
      qemu = {
        rev = "0df9387c8983e1b1e72d8c574356f572342c03e6";
        hash = "sha256-BX+LXfNzwdUMALwwI1ZDW12dJ357oynjnrboLHREDGQ=";
        patches = [ ];
      };
      seaBIOS = {
        rev = "a6ed6b701f0a57db0569ab98b0661c12a6ec3ff8";
        hash = "sha256-hWemj83cxdY8p+Jhkh5GcPvI0Sy5aKYZJCsKDjHTUUk=";
        patches = [ ];
      };
      ovmf = {
        rev = "ba91d0292e593df8528b66f99c1b0b14fadc8e16";
        hash = "sha256-htOvV43Hw5K05g0SF3po69HncLyma3BtgpqYSdzRG4s=";
        patches = [ ];
      };
      ipxe = {
        rev = "1d1cf74a5e58811822bee4b3da3cff7282fcdfca";
        hash = "sha256-8pwoPrmkpL6jIM+Y/C0xSvyrBM/Uv0D1GuBwNm+0DHU=";
        patches = [ ];
      };
    };

    meta = {
      inherit branch;
      description = "Qubes component: vmm-xen";
      longDescription = ''
        Qubes OS' modified version of the Xen Hypervisor.
        Contains dozens of Qubes-specific patches, and is intended to power a Qubes OS Domain 0.

        This is effectively a `xen-slim` build. Use with `qemu_qubes`.
      '';
      homepage = "https://qubes-os.org";
      downloadPage = "https://github.com/QubesOS/qubes-vmm-xen";
      license = xen.meta.license;
      mainProgram = "xl";
      platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.x86_64;
      maintainers = with lib.maintainers; [ sigmasquadron ];
    };
  })
  (
    {
      python = python3;
      withInternalQEMU = false;
      withInternalSeaBIOS = false;
      seabios = qubes-seabios;
      withInternalIPXE = false;
      withInternalOVMF = false;
      withFlask = false;
      ocamlPackages = ocaml-ng.ocamlPackages_4_14;
    }
    // genericDefinition
  )
).overrideAttrs (oldAttrs: {
  # FIXME: Drop after rebasing to latest changes in https://github.com/NixOS/nixpkgs/pull/341429
  passthru = oldAttrs.passthru // {
    efi = "boot/xen-${versionPatches}.efi";
  };
  postInstall = oldAttrs.postInstall + ''
    ln -sf ${qubes-vmm-stubdom-linux}/libexec/xen/boot/qemu-stubdom-linux{-full,}-{kernel,rootfs} \
      $out/libexec/xen/boot/
  '';
})
