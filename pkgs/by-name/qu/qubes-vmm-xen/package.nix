{
  lib,
  fetchpatch,
  buildXenPackage,
  qubes-seabios,
  xen,
}:

let
  version = "4.19.0";
  revision = "3";

  qubesPatches = import ./patches.nix {
    inherit fetchpatch version revision;
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

buildXenPackage.override
  {
    seabios = qubes-seabios;
  }
  {
    pname = "qubes-vmm-xen";
    inherit version;
    vendor = "qubes";

    withSeaBIOS = true;
    withOVMF = true;
    withIPXE = false;

    rev = "026c9fa29716b0ff0f8b7c687908e71ba29cf239";
    hash = "sha256-Q6x+2fZ4ITBz6sKICI0NHGx773Rc919cl+wzI89UY+Q=";
    patches = qubesPatchList;
    useDefaultPatchList = false;

    meta = {
      inherit (xen.meta) license mainProgram platforms;
      description = "Qubes component: vmm-xen";
      longDescription = ''
        Qubes OS' modified version of the Xen Project Hypervisor.
        Contains dozens of Qubes-specific patches, and is intended to power a Qubes OS Domain 0.

        Use with `qemu_qubes`.
      '';
      homepage = "https://qubes-os.org";
      downloadPage = "https://github.com/QubesOS/qubes-vmm-xen";
      maintainers = with lib.maintainers; [
        lach
        sigmasquadron
      ];
    };
  }
