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
      XSA_460
      XSA_461
      XSA_462
    ]
  );
in

callPackage (import ../generic/default.nix {
  pname = "xen";
  branch = "4.19";
  version = "4.19.0";
  latest = true;
  pkg = {
    xen = {
      rev = "026c9fa29716b0ff0f8b7c687908e71ba29cf239";
      hash = "sha256-Q6x+2fZ4ITBz6sKICI0NHGx773Rc919cl+wzI89UY+Q=";
      patches = [ ] ++ upstreamPatchList;
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
}) ({ ocamlPackages = ocaml-ng.ocamlPackages_4_14; } // genericDefinition)
