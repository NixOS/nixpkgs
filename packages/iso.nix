{ inputs, ... }@flakeContext:
let
  isoModule = xnode;
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";
  modules = [
    isoModule
  ];
}
