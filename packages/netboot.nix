{ inputs, xnode, ... }@flakeContext:
let
  netboot = xnode;
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  customFormats = { "netboot" = import ./image/format/netboot.nix; };
  format = "netboot";
  modules = [
    netboot
  ];
}
