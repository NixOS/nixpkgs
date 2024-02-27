{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.2.4";
  sha256 = "0hh2sfjvqz085hl2dpsa9zgr3dwpyc85gcbx0c7lzpjg411bxmim";
  vendorHash = "sha256-g1e1uY43fUC2srKK9erVFlJDSwWrEvq4ni0PgeCFaOg=";
}
