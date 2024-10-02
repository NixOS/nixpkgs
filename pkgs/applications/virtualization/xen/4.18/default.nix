{
  lib,
  fetchpatch,
  callPackage,
  ocaml-ng,
  ...
}@genericDefinition:

let
  upstreamPatches = import ../generic/patches.nix {
    inherit lib;
    inherit fetchpatch;
  };

  upstreamPatchList = lib.lists.flatten (
    with upstreamPatches;
    [
      QUBES_REPRODUCIBLE_BUILDS
      XSA_462
    ]
  );
in

callPackage (import ../generic/default.nix {
  pname = "xen";
  branch = "4.18";
  version = "4.18.3";
  latest = false;
  pkg = {
    xen = {
      rev = "bd51e573a730efc569646379cd59ccba967cde97";
      hash = "sha256-OFiFdpPCXR+sWjzFHCORtY4DkWyggvxkcsGdgEyO1ts=";
      patches = [ ] ++ upstreamPatchList;
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
