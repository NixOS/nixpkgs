{ lib
, stdenv
, fetchFromGitHub
, pkgs
}:

let
  src = fetchFromGitHub {
    owner = "gignsky";
    repo = "nufetch";
    rev = "feature/add-non-flake-files";
    sha256 = "onoGbqhqSGTHosaVFwFqJEaFPgkgAgtvFhiIjfsw3pQ=";
  };

  overlay = import "${src}/nix/overlays/neofetch-patch-nixos-module.nix";
  patchedPkgs = import pkgs.path {
    inherit (pkgs) system config;
    overlays = pkgs.overlays or [] ++ [ overlay ];
  };

  realPkg = import "${src}/default.nix" { pkgs = patchedPkgs; };
in
realPkg.overrideAttrs (old: {
  meta = old.meta // {
    description = "A patched version of neofetch for the nufetch NixOS module";
    homepage = "https://github.com/gignsky/nufetch";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ gignsky ];
  };
})
