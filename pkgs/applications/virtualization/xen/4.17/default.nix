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
    upstreamPatches.XSA_460
    upstreamPatches.XSA_461
  ];
in

callPackage (import ../generic.nix {
  branch = "4.17";
  version = "4.17.4";
  latest = false;
  pkg = {
    xen = {
      rev = "d530627aaa9b6e03c7f911434bb342fca3d13300";
      hash = "sha256-4ltQUzo4XPzGT/7fGt1hnNMqBQBVF7VP+WXD9ZaJcGo=";
      patches = [
        ./0000-xen-ipxe-src-4.17.patch
        ./0001-xen-fig-geneneration-4.17.patch
      ] ++ upstreamPatchList;
    };
    qemu = {
      rev = "ffb451126550b22b43b62fb8731a0d78e3376c03";
      hash = "sha256-G0hMPid9d3fd1jAY7CiZ33xUZf1hdy96T1VUKFGeHSk=";
      patches = [ ];
    };
    seaBIOS = {
      rev = "d239552ce7220e448ae81f41515138f7b9e3c4db";
      hash = "sha256-UKMceJhIprN4/4Xe4EG2EvKlanxVcEi5Qcrrk3Ogiik=";
      patches = [ ];
    };
    ovmf = {
      rev = "7b4a99be8a39c12d3a7fc4b8db9f0eab4ac688d5";
      hash = "sha256-Qq2RgktCkJZBsq6Ch+6tyRHhme4lfcN7d2oQfxwhQt8=";
      patches = [ ];
    };
    ipxe = {
      rev = "1d1cf74a5e58811822bee4b3da3cff7282fcdfca";
      hash = "sha256-8pwoPrmkpL6jIM+Y/C0xSvyrBM/Uv0D1GuBwNm+0DHU=";
      patches = [ ];
    };
  };
}) ({ ocamlPackages = ocaml-ng.ocamlPackages_4_14; } // genericDefinition)
