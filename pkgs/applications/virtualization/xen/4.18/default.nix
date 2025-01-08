{
  lib,
  fetchpatch,
  callPackage,
  ocaml-ng,
  ...
}@genericDefinition:

let
  upstreamPatches = import ../patches.nix {
    inherit lib;
    inherit fetchpatch;
  };

  upstreamPatchList = lib.lists.flatten [
    upstreamPatches.QUBES_REPRODUCIBLE_BUILDS
    upstreamPatches.XSA_458
  ];
in

callPackage (import ../generic.nix {
  branch = "4.18";
  version = "4.18.2";
  latest = false;
  pkg = {
    xen = {
      rev = "d152a0424677d8b78e00ed1270a583c5dafff16f";
      hash = "sha256-pHCjj+Bcy4xQfB9xHU9fccFwVdP2DXrUhdszwGvrdmY=";
      patches = [
        ./0000-xen-ipxe-src-4.18.patch
        ./0001-xen-fig-geneneration-4.18.patch
      ] ++ upstreamPatchList;
    };
    qemu = {
      rev = "0df9387c8983e1b1e72d8c574356f572342c03e6";
      hash = "sha256-BX+LXfNzwdUMALwwI1ZDW12dJ357oynjnrboLHREDGQ=";
      patches = [ ];
    };
    seaBIOS = {
      rev = "ea1b7a0733906b8425d948ae94fba63c32b1d425";
      hash = "sha256-J2FuT+FXn9YoFLSfxDOxyKZvKrys59a6bP1eYvEXVNU=";
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
}) ({ ocamlPackages = ocaml-ng.ocamlPackages_4_14; } // genericDefinition)
