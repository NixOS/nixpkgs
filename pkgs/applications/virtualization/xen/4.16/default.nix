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
    upstreamPatches.XSA_458
    upstreamPatches.XSA_460
    upstreamPatches.XSA_461
  ];
in

callPackage (import ../generic.nix {
  branch = "4.16";
  version = "4.16.6";
  latest = false;
  pkg = {
    xen = {
      rev = "4b33780de790bd438dd7cbb6143b410d94f0f049";
      hash = "sha256-2kcmfKwBo3w1U5CSxLSYSteqvzcJaB+cA7keVb3amyA=";
      patches = [
        ./0000-xen-ipxe-src-4.16.patch
        ./0001-xen-fig-geneneration-4.16.patch
      ] ++ upstreamPatchList;
    };
    qemu = {
      rev = "c02cb236b5e4a76cf74e641cc35a0e3ebd3e52f3";
      hash = "sha256-LwlPry04az9QQowaDG2la8PYlGOUMbZaQAsCHxj+pwM=";
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
      rev = "3c040ad387099483102708bb1839110bc788cefb";
      hash = "sha256-y2QdZEoGsGUQjrrvD8YRa8VoqcZSr4tjLM//I/MrsLI=";
      patches = [ ];
    };
  };
}) ({ ocamlPackages = ocaml-ng.ocamlPackages_4_14; } // genericDefinition)
