{ pkgs ? import ../. { } }:
(import ./default.nix { }).overrideAttrs
(x: { buildInputs = (x.buildInputs or [ ]) ++ [ pkgs.xmloscopy pkgs.ruby ]; })
