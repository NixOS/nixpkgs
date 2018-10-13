{ pkgs, system, stdenv, fetchurl, nodejs }:

with stdenv.lib;

let
  nodePackages = import ./composition.nix {
    inherit pkgs system nodejs;
  };

  xorg = pkgs.xorg;
in
nodePackages.package.override (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ [
    xorg.libX11
    xorg.libxkbfile
    xorg.libXext
    xorg.libXtst
  ];

  meta = {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt (SSB)";
    homepage = https://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.matthiasbeyer ];
  };
})

