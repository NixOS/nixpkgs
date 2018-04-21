{ pkgs ? import ../. {} }:
(import ./default.nix).overrideAttrs (x: {
  buildInputs = x.buildInputs ++ [ pkgs.xmloscopy ];
})
