{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.5.1";
  sha256 = "1l358gmivhpjyibcar8z4c3jlz6rwmlyzki71ar5j2k9irdjzqa3";
  vendorHash = "sha256-sLLgTZN7Zvxkf9J1omh/YGMBUgAtvQD+nbhSuR7/PZg=";
}
